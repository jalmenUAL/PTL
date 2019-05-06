%1.- All attribute names of a data have distinct names

%query query1 = er!data.allInstances()->forAll(d| d.attr_of->isUnique(a|a.name)).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(1):- \+ (data_attr_of(er,D,A1),data_attr_of(er,D,A2),A1\==A2,attribute_name(er,A1,N1),attribute_name(er,A2,N2),N1==N2).

%2.- Each data has a key attribute 

%query query1 = metamodelA!data.allInstances()->forAll(d| d.attr_of->exists(a|a.key)).toString().writeTo('/Users/jesusalmendros/%Desktop/result.txt');

vrule(2):- \+ (data_id(er,D),\+ (data_attr_of(er,D,A),attribute_key(er,A,true))).

%3.- All data have distinct names

%query query1 = metamodelA!data.allInstances()->isUnique(d|d.name).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(3):- \+ (data_id(er,D1),data_id(er,D2),D1\==D2,data_name(er,D1,N1),data_name(er,D2,N2),N1==N2).

%4.- All data have distinct containers

%query query1 = metamodelA!data.allInstances()->isUnique(d|d.container).toString().writeTo('/Users/jesusalmendros/Desktop/%result.txt');

vrule(4):- \+ (data_id(er,D1),data_id(er,D2),D1\==D2,data_container(er,D1,N1),data_container(er,D2,N2),N1==N2).

%5.- All qualifier names of a relation are distinct

%query query1 = metamodelA!relation.allInstances()->forAll(r| r.is_role->forAll(rl|rl.is->isUnique(q|q.name))).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

%NO FUNCIONA??

%6.- All qualifiers are key attributes (Falta key)

%query query1 = metamodelA!qualifier.allInstances()->forAll(q| metamodelA!attribute.allInstances()->exists(a|a.name=q.name)).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(6):-\+ (qualifier_id(er,Q),\+ (attribute_id(er,A),qualifier_name(er,Q,N1),attribute_name(er,A,N2),N1==N2)).
 

%7.- All role names of a data are distinct %cambiar role_of a *

%query query1 = metamodelA!data.allInstances()->forAll(d|d.role_of->isUnique(r|r.name)).toString().writeTo('/Users/jesusalmendros/%Desktop/result.txt');

vrule(7):- \+ (data_role_of(er,D,R1),data_role_of(er,D,R2),R1\==R2,role_name(er,R1,N1),role_name(er,R2,N2),N1==N2).

%8.- All column names of a row are distinct

%QUITAR!

%9.- All foreign keys of a row are keys of another row NO VA POR EL NOMBRE

%query query1 = metamodelB!row.allInstances()->forAll(r1|r1.is_foreign->forAll(f| metamodelB!row.allInstances()->exists(r2 | %r2.is_key->exists (k | f.name=r1.name+k.name)))).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');


%10.- All table names are distinct

%query query1 = metamodelB!table.allInstances()->isUnique(t|t.name).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(10):-\+ (table_id(rl,T1),table_id(rl,T2),T1\==T2,table_name(rl,T1,N1),table_name(rl,T2,N2),N1==N2).

%11.- All row names are distinct

%query query1 = metamodelB!row.allInstances()->isUnique(r|r.name).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(11):-\+ (row_id(rl,R1),row_id(rl,R2),R1\==R2,row_name(rl,R1,N1),row_name(rl,R2,N2),N1==N2).


%12.- All rows have either all key and columns or all foreign keys

%query query1 = metamodelB!row.allInstances()->forAll(r | r.is_foreign->isEmpty() or (r.is_key->isEmpty()
%and r.is_col->isEmpty())).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(12):- \+ (row_id(rl,R),((row_is_foreign(rl,R,F),row_is_key(rl,R,K));(row_is_foreign(rl,R,F),row_is_col(rl,R,C)))).

%13.- Key and column names and types are names and types of data attributes

%query query1=metamodelB!key.allInstances()->forAll(k | metamodelA!attribute.allInstances()-> exists(a | a.name=k.name)).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

%query query1=metamodelB!key.allInstances()->forAll(k | metamodelA!attribute.allInstances()-> exists(a | a.type=k.type)).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(13):- \+ (key_id(rl,K),\+ (attribute_id(er,A),key_name(rl,K,N1),attribute_name(er,A,N2),N1==N2)).

vrule(13):- \+ (key_id(rl,K),\+ (attribute_id(er,A),key_type(rl,K,N1),attribute_type(er,A,N2),N1==N2)).


%Igual para columnas

%14.- Table names are either container names or role names

%query query1 = metamodelB!table.allInstances()->forAll(t | (metamodelA!data.allInstances()-> exists(d | d.container=t.name))
	or (metamodelA!role.allInstances()->exists(r | r.name=t.name))).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(14):-\+ (table_id(rl,T), \+ (data_id(er,D),data_container(er,D,N1),table_name(rl,T,N2),N1==N2),\+ (role_id(er,R),role_name(er,R,N1),table_name(rl,T,N2),N1==N2)).


%15.- Row names are either data names or concatenations of role and data 
%names

%query query1 = metamodelB!row.allInstances()->forAll(r | (metamodelA!data.allInstances()-> exists(d | d.name=r.name))
%	or (metamodelA!data.allInstances()-> exists(d | metamodelA!role.allInstances()->exists(rl | r.name=rl.name%+d.name))) ).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');

vrule(15):- \+ (row_id(rl,R), \+ (data_id(er,D),data_name(er,D,N1),row_name(rl,R,N2),N1==N2),\+ (role_id(er,RL),data_id(er,D),role_name(er,RL,N1),data_name(er,D,N3),row_name(rl,R,N2),concat(N1,N3,N2))).

 

%16.- Foreign key names are concatenations of role, data and key names

 

%query query1 = metamodelB!foreign.allInstances()->forAll(f | metamodelA!role.allInstances()-> exists(r |
	metamodelA!data.allInstances()-> exists(d | metamodelB!key.allInstances()->exists(k | f.name=r.name+d.name+k.name))) ).toString().writeTo('/Users/jesusalmendros/Desktop/result.txt');


vrule(16):- \+ (foreign_id(rl,F), \+ (data_id(er,D),data_name(er,D,N1),role_id(er,R),role_name(er,R,N2),key_id(rl,K),key_name(rl,K,N3),foreign_name(rl,F,N4),concat(N2,N1,AUX),concat(AUX,N3,N4))).

