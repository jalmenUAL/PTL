%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD ECORE September 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%LOAD_ECORE%%%%%%%%%%%%%%%%%%%%%%%%%%

load_ecore(_):-rdf_reset_db,fail.

%%%MODIFICATION November 2014


load_ecore(Model):- element(Name,IdS,Id),
		role_def(Name,_,_,_,_,Model,container),
		concat(id,IdS,AIdS),
		concat(id,Id,AId),
		nsp(Model,Name,MName), 
		rdf_assert(AIdS,MName,AId),
		load_link(Id,Model),
		fail.


load_ecore(Model):- element(Name,IdS,Id),\+element(Name,_,IdS),
		role_def(Name,_,Target,_,_,Model,container),
		concat(id,IdS,AIdS),
		concat(id,Id,AId),
		nsp(Model,Target,MTarget), 
		rdf_assert(AIdS,MTarget,AId),
		fail.
%%%%%%%%%%%%%%

load_ecore(Model):-element(Name,IdS,Id),
		\+role_def(Name,_,_,_,_,Model,container),
		concat(id,IdS,AIdS),
		concat(id,Id,AId), 
		nsp(Model,Name,MName),
		rdf_assert(AIdS,MName,AId),
		load_link(Id,Model),fail.



load_ecore(_).



%%%%%%%%%%%%LOAD_ASSOCIATIONS%%%%%%%%%%%%%%%%%%%%%


		     

load_link(Id,Model):-att(X,Y,Id,_),
			sub_atom(Y,0,_,_,'//@'),
			concat_atom(List,' ',Y),
			member(K,List),
			rdf_associations(Id,Model,X,K).

load_link(Id,Model):-att(X,Y,Id,_),
		\+sub_atom(Y,0,_,_,'//@'),
		concat(id,Id,AId),
		nsp(Model,X,MX),
		rdf_assert(AId,MX,literal(Y)).


rdf_associations(Id,Model,X,Y):-				

				concat(Z,T,Y),
				concat('.',StringNumber,T),
				concat('//@',Class,Z),
				atom_number(StringNumber,Number),
				element_ecore(Class,Number,Id2),!,
				concat(id,Id,AId),
				concat(id,Id2,AId2),
				nsp(Model,X,MX),
				rdf_assert(AId,MX,AId2).






 

			

 