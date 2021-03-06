"""
General purpose forth implemented in python

See README for more information.
"""
from __future__ import print_function
from time import time, sleep
import readline
import fileinput
import sys
import inspect
import operator as op

# builtins
class WordList(list): #cannot add func_doc to list
    pass

def find_last(lst, sought_elt): #rfind for lists
    for r_idx, elt in enumerate(reversed(lst)):
        if elt == sought_elt:
            return len(lst) - 1 - r_idx

def block_end(stack, words):
    """end of definition."""
    definition = WordList()
    def_end = find_last(stack, ":")
    definition.extend(stack[def_end+1:])
    del stack[def_end:]
    stack.append(definition)
    return 0

def call_func(stack, words):
    """call function recorded on the stack with arguments ( a n -- )"""
    argcount = stack.pop()
    func = stack.pop()
    if argcount == -1: #FIXME
        stack.append(func)
        return
    args = stack[-argcount:]
    del stack[-argcount:]
    if type(func) == WordList:
        res = execute(func, stack, words)
    else:
        res = func(*args)
    if res != None:
        stack.append(res)

def define(stack, words):
    """define a definition ( a b -- )"""
    name, definition = stack[-2:]
    del stack[-2:]
    words[name] = definition

def none_func(stack, words):
    """None constant"""
    stack.append(None)

def call_python(token, stack, argcount, isbuilt):
    if argcount == -1:
        if isbuilt:
            stack.append(builtins[token])
        else:
            stack.append(glob[token])
        return
    if argcount != 0:
        args = stack[-argcount:]
        del stack[-argcount:]
    else:
        args = []
    if isbuilt:
        res = builtins[token](*args)
    else:        
        res = glob[token](*args)
    if res != None:
        stack.append(res)

global_words = {
    ";"   : block_end,
    ":"   : lambda x: x,
    "call": call_func,
    "none": none_func,
    "def"  : define,
}
# end builtins

# global stack
global_stack = []
glob = globals()
b = glob['__builtins__']
if type(b) == dict: #profilers change module to dict
    builtins = dict(b)
else:
    builtins = dict(b.__dict__)
quoted_stack = []
quote_flag = False
ignore = False

# interpreter
def execute(tokens, lstack, words):
    global quoted_stack, quote_flag, ignore
    glob["stack"] = lstack
    glob["global_words"] = words
    for token in tokens:
        if token == "\\\"":
            lstack.append("\"")
            continue
        if token == "\"":
            if quote_flag:
                lstack.append(" ".join(quoted_stack))
                quote_flag = False
            else:
                quoted_stack = []
                quote_flag = True
            continue
        if quote_flag:
            quoted_stack.append(token)
            continue
        t = type(token)
        if t == WordList:
            lstack.append(token)
            continue
        if t == int or (t == str and token.lstrip("-").isdigit()):
            lstack.append(int(token))
        else:
            if token not in words:
                isbuilt = token in builtins
                if not ignore and (isbuilt or token in glob):
                    if isbuilt or callable(glob[token]):
                        argcount = lstack.pop()
                        call_python(token, lstack, argcount, isbuilt)
                    else:
                        lstack.append(glob[token])
                    continue
                lstack.append(token)
            else:
                if token == ":":
                    lstack.append(token)
                    ignore = True
                    continue
                if ignore and token != ";":
                    lstack.append(token)
                    continue
                func = words[token]
                if type(func) == WordList:
                    res = execute(func, lstack, words)
                else:
                    res = func(lstack, words)
                if res != None and (":" not in stack):
                    ignore = False
                # print("stack:" + str(stack) + "ignore: " + str(ignore))

def read_line_and_execute(line, stack, words):
    line = line.rstrip()
    tokens = line.split(" ")
    execute(tokens, stack, words)

def read_file_and_execute(filename, stack, words):
    with open(filename, "r") as f:
        tokens = []
        for line in f:
            tokens.extend(line[:-1].rstrip().split(" "))
        execute(tokens, stack, words)

if __name__ == '__main__':
    if len(sys.argv) > 1:
        read_file_and_execute(sys.argv[1], global_stack, global_words)
    while True:
        read_line_and_execute(
            raw_input(),
            global_stack,
            global_words)
