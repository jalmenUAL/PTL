
%%%%%%%%%%%%%LOAD_ECORE%%%%%%%%%%%%%%%%%%%%%%%%%%

load_ecore(_):-rdf_reset_db,fail.

load_ecore(Model):-element(Name,IdS,Id),
		concat(id,IdS,AIdS),
		concat(id,Id,AId), 
		rdf_assert(AIdS,Name,AId),
		load_atts2(Id),
		load_associations2(Id,Model),
		fail.

%load_ecore(Model):-element(_,_,Id),
%		 load_associations(Id,Model),fail.

load_ecore(_).

%%%%%%%%%%%LOAD_ATTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load_atts(Model,Name,Id):-
%		load_att(Id,Atts),
%		assert(Clause),
%		%
%		rdf_att(Id,Atts),
%		%
%		recorda(object,Clause).
		
%load_att(Pos,Atts):- findall(Z,(att(X,Y,Pos,_),Z=..[X,Y],\+ sub_atom(Y,_,_,_,'//@')),Atts).


load_atts2(Id):-att(X,Y,Id,_),\+ sub_atom(Y,_,_,_,'//@'),concat(id,Id,AId),rdf_assert(AId,X,literal(Y)),fail.

load_atts2(_).

rdf_att(Id,Atts):-member(Att,Atts),
		Att=..[Name,Value],
		concat(id,Id,AId),
		rdf_assert(AId,Name,literal(Value)),fail.
rdf_att(_,_).


%%%%%%%%%%%%LOAD_ASSOCIATIONS%%%%%%%%%%%%%%%%%%%%%

load_associations(Id,Model):-  findall([X,Y],(att(X,Y,Id,_),sub_atom(Y,0,_,_,'//@')),L),
			       generate_associations(Id,Model,L).

generate_associations(Id,Model,L):- member([Role,Values],L),
				concat_atom(List,' ',Values),
				generate_each_association(Role,List,Id,Model).

generate_each_association(_,[],_,_).
generate_each_association(Role,[X|L],Id,Model):-generate_each(Role,X,Id,Model),
						generate_each_association(Role,L,Id,Model).


load_associations2(Id,Model):-att(X,Y,Id,_),sub_atom(Y,0,_,_,'//@'), 
				concat_atom(List,' ',Y),
				member(K,List),
				load_associations3(Id,Model,X,K).


load_associations3(Id,Model,X,Y):-				

				concat(Z,T,Y),
				concat('.',StringNumber,T),
				concat('//@',Class,Z),
				atom_number(StringNumber,Number),
				element_ecore(Class,Number,Id2),!,
				concat(id,Id,AId),concat(id,Id2,AId2),
				Clause=..[associationEnds,Model,X,AId,AId2],
				assert(Clause),
				%
				concat(id,Id,AId),
				concat(id,Id2,AId2),
				rdf_assert(AId,X,AId2).
			

generate_each(Role,One,Id,Model):-
				concat(Z,Y,One),
				concat('.',StringNumber,Y),
				concat('//@',Class,Z),
				atom_number(StringNumber,Number),
				element_ecore(Class,Number,Id2),!,
				%
				concat(id,Id,AId),concat(id,Id2,AId2),
				Clause=..[associationEnds,Model,Role,AId,AId2],
				assert(Clause),
				%
				concat(id,Id,AId),
				concat(id,Id2,AId2),
				rdf_assert(AId,Role,AId2).


 