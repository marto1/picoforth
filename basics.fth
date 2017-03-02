: .item swap __getitem__ 2 getattr 1 call ;
: .slice 2 slice .item ;
: get-word global_words swap .item ;
: .doc swap 1 None .slice get-word swap func_doc swap 3 setattr ;
'.item " access a with index b (a b -- c) " .doc
'.slice " get slice from a from b to c (a b c -- d) " .doc
'.doc " set documentation for word ('word doc -- ) " .doc
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
: .help 1 None .slice get-word func_doc 2 getattr 1 print ;
'.help " get documention for word ('word -- doc) " .doc
