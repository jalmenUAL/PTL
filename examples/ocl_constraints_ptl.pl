vrule(1):- \+ (data_attr_of(er,D,A1),data_attr_of(er,D,A2),A1\==A2,attribute_name(er,A1,N1),attribute_name(er,A2,N2),N1==N2).

vrule(2):- \+ (data_id(er,D),\+ (data_attr_of(er,D,A),attribute_key(er,A,true))).

vrule(2):- \+ (data_id(er,D),(data_attr_of(er,D,A),attribute_key(er,A,true),data_attr_of(er,D,B),attribute_key(er,B,true),A\==B)).

vrule(3):- \+ (data_id(er,D1),data_id(er,D2),D1\==D2,data_name(er,D1,N1),data_name(er,D2,N2),N1==N2).

vrule(4):- \+ (data_id(er,D1),data_id(er,D2),D1\==D2,data_container(er,D1,N1),data_container(er,D2,N2),N1==N2).

vrule(5):- \+ (qualifier_id(er,Q),\+ (attribute_id(er,A),qualifier_name(er,Q,N1),attribute_name(er,A,N2),N1==N2)).
 
vrule(6):- \+ (data_role_of(er,D,R1),data_role_of(er,D,R2),R1\==R2,role_name(er,R1,N1),role_name(er,R2,N2),N1==N2).

vrule(7):- \+ (table_id(rl,T1),table_id(rl,T2),T1\==T2,table_name(rl,T1,N1),table_name(rl,T2,N2),N1==N2).

vrule(8):- \+ (row_id(rl,R1),row_id(rl,R2),R1\==R2,row_name(rl,R1,N1),row_name(rl,R2,N2),N1==N2).

vrule(9):- \+ (row_id(rl,R),((row_is_foreign(rl,R,_),row_is_key(rl,R,_));(row_is_foreign(rl,R,_),row_is_col(rl,R,_)))).

vrule(10):- \+ (key_id(rl,K),\+ (attribute_id(er,A),key_name(rl,K,N1),attribute_name(er,A,N2),N1==N2)).

vrule(10):- \+ (key_id(rl,K),\+ (attribute_id(er,A),key_type(rl,K,N1),attribute_type(er,A,N2),N1==N2)).

vrule(11):- \+ (table_id(rl,T), \+ (data_id(er,D),data_container(er,D,N1),table_name(rl,T,N2),N1==N2),\+ (role_id(er,R),role_name(er,R,N1),table_name(rl,T,N2),N1==N2)).

vrule(12):- \+ (row_id(rl,R), \+ (data_id(er,D),data_name(er,D,N1),row_name(rl,R,N2),N1==N2),\+ (role_id(er,RL),data_id(er,D),role_name(er,RL,N1),data_name(er,D,N3),row_name(rl,R,N2),concat(N1,N3,N2))).

 vrule(13):- \+ (foreign_id(rl,F), \+ (data_id(er,D),data_name(er,D,N1),role_id(er,R),role_name(er,R,N2),key_id(rl,K),key_name(rl,K,N3),foreign_name(rl,F,N4),concat(N2,N1,AUX),concat(AUX,N3,N4))).

