over : -2 stack " __getitem__ " 2 getattr 1 call ; def
swap : over -3 stack " __delitem__ " 2 getattr 1 call ; def
negate : op " __neg__ " 2 getattr 1 call ; def
.item : swap __getitem__ 2 getattr 1 call ; def
.slice : 2 slice .item ; def
get-word : global_words swap .item ; def
.doc : swap 1 none .slice get-word swap func_doc swap 3 setattr ; def
included : stack global_words 3 read_file_and_execute ; def
.s : stack 1 print ; def
words : global_words " keys " 2 getattr 0 call 1 print ; def
depth : stack 1 len ; def
.m : 2 getattr swap call ; def
+ : op " __add__ " 2 getattr 2 call ; def
- : negate + ; def
and : op " __and__ " 2 getattr 2 call 1 bool 1 int negate ; def
or : op " __or__ " 2 getattr 2 call 1 bool 1 int negate ; def
* : op " mul " 2 getattr 2 call ; def
drop : -1 stack " __delitem__ " 2 getattr 1 call ; def
nip : -2 stack " __delitem__ " 2 getattr 1 call ; def
dup : -1 stack " __getitem__ " 2 getattr 1 call ; def
tuck : dup -2 swap stack " insert " 2 getattr 2 call ; def
2dup : over over ; def
rot : -3 stack " pop " 2 getattr 1 call ; def
rrot : -2 swap stack " insert " 2 getattr 2 call ; def
= : op " eq " 2 getattr 2 call 1 int negate ; def
> : op " gt " 2 getattr 2 call 1 int negate ; def
< : op " lt " 2 getattr 2 call 1 int negate ; def
>= : 2dup > rrot = or ; def
<= : 2dup < rrot = or ; def
xor : op " __xor__ " 2 getattr 2 call 1 int negate ; def
invert : op " __invert__ " 2 getattr 1 call ; def
true : -1 ; def
false : 0 ; def
0> : 0 > ; def
0< : 0 < ; def
empty : : . ; depth loop ; def
clearstack : none none 2 slice stack __delitem__ 2 getattr 1 call ; def
.help : 1 none .slice get-word func_doc 2 getattr 1 print ; def
bye : 0 exit ; def
. : 1 print ; def
loop : * stack global_words 3 execute ; def
if : swap 1 abs loop ; def
.split : 2 getattr 2 call ; def
imported : 0 globals 0 locals rot 4 __import__ ; def
" docs.fth " included
