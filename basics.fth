: included 1 read_file_and_execute ;
: .s stack 1 print ;
: words global_words " keys " 2 getattr 0 call 1 print ;
: ssize stack 1 len ;
: - negate + ;
: ++ over + ;
: * 0 '++ rot 1 - loop + ;
: 2dup over over ;
: >= 2dup > rot = or ;
: <= 2dup < rot = or ;
: xor 2dup and invert rrot or and ;
: true -1 ;
: false 0 ;
: 0> 0 > ;
: empty '. ssize 1 - loop ;
: .item swap __getitem__ 2 getattr 1 call ;
: .slice 2 slice .item ;
