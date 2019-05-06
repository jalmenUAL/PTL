%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PTL 2 ECORE September 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%WARNING Only allowed all container or all non container

%%%%%%%%%%%%WRITE_ECORE%%%%%%%%%%%%%%%%%%%%%

write_ecore(Schema,Root,_):- concat(Schema,':',SchemaD),
			concat(SchemaD,Root,RootT),
			assert(element2(RootT,1,2)),fail.

write_ecore(_,_,_):-assert(att2('xmi:version','2.0',2,3)),fail.

write_ecore(_,_,_):-assert(att2('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance',2,3)),fail.

write_ecore(_,_,_):-assert(att2('xmlns:xmi', 'http://www.omg.org/XMI', 2, 4)),fail.

write_ecore(Schema,_,_):-concat('xmlns:',Schema,Meta),
			schema(Schema,Url,_),
			assert(att2(Meta, Url, 2, 5)),fail.

write_ecore(Schema,_,_):-
			schema(Schema,Url,Location),
			concat(Url,' ',UrlB),
			concat(UrlB,Location,LocationS),
			assert(att2('xsi:schemaLocation',LocationS, 2, 5)),fail.

write_ecore(_,_,Model):-objectM(Model,Name,Id,_,_,_),
			update_ecore2(Name,Id,_),fail.

write_ecore(_,_,Model):-objectM(Model,Name,Id,_,Atts,_),
			write_element(Model,Name,2,Id,Atts).
			
write_ecore(_,_,_).


write_element(Model,Name,Root,Id,Atts):- \+ role_def(_,_,Name,_,_,Model,container), 
			
			assert_elements(Name,Root,Id,Atts),fail.

write_element(Model,Name,_,Id,_):-  
			\+ role_def(Role,_,Name,_,_,Model,container),
			setof(Id2,associationObjectsM(Model,Role,Id,Id2),L), %bagof
			concat(Id,Role,IdRole),
			process_set(L,Set),
			assert(att2(Role,Set,Id,IdRole)),fail.

write_element(Model,Name,_,Id,_):-role_def(Role,Name,Target,_,_,Model,container),
			setof(Id2,associationObjectsM(Model,Role,Id,Id2),L), %bagof
			process_children(Id,L,Model,Target,Role),		
			fail.

%%%%%%%%%PROCESS_CHILDREN%%%%%%%%%%%%%%%%%%%

process_children(_,[],_,_,_).
process_children(Id,[Ch|RCh],Model,Target,Role):-
				objectM(Model,Target,Ch,_,Atts,_),
				write_element(Model,Role,Id,Ch,Atts),
				process_children(Id,RCh,Model,Target,Role).


%%%%%%%%%%%PROCESSS SET%%%%%%%%%%%%%%%%%%%%%%%

process_set([],'').

process_set([S|RS],Res):-identifier_ecore2(Name,S,Number), 
			concat('//@',Name,CName),
			concat(CName,'.',Point),
			concat(Point,Number,PS),
			process_set(RS,PRS),
			concat(' ',PRS,PRSB),
			concat(PS,PRSB,Res).

%%%%%%%%%%ASSERT_ELEMENTS%%%%%%%%%%%%%%%%%%%%%%%%%%%
			 

assert_elements(Name,Root,Id,Atts):- 
			assert(element2(Name,Root,Id)),
			process_attributes(Atts,Id).

process_attributes([],_).
process_attributes([A|RA],Id):-A=..[Name,Value],
			    concat(Id,Name,IdAtt),
			    assert(att2(Name,Value,Id,IdAtt)),
			    process_attributes(RA,Id).

%%%%%%%%%%UPDATE_ECORE2%%%%%%%%%%%%%%%%%%%%%%%%%%%


update_ecore2(C,Id,N):-identifier_ecore2(C,M),!,
			N is M+1,
			retract(identifier_ecore2(C,M)),
			assert(identifier_ecore2(C,N)),
			assert(identifier_ecore2(C,Id,N)).

update_ecore2(C,Id,N):-N=0,
			assert(identifier_ecore2(C,N)),
			assert(identifier_ecore2(C,Id,N)).