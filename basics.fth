: - negate + ;
: 2dup over over ;
: >= 2dup > rot = or ;
: <= 2dup < rot = or ;
: xor 2dup and invert rot or and ;
