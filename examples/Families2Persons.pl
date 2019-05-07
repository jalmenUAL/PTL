input('xmi','XMI',families,'sample-Families.xmi').
output('xmi','XMI',persons,'sample-Persons.xmi').
rdf_db::ns(fam, 'http:://www.example.org/Families#').
rdf_db::ns(per, 'http:://www.example.org/Persons#').

metamodel(families,[
	 class('Family',[lastName]),
	 class('Member',[firstName]),
	 role(father,'Family','Member',"0","1",container),
	 role(mother,'Family','Member',"0","1",container),
         role(sons,'Family','Member',"0","*",container),
         role(daughters,'Family','Member',"0","*",container)
	 ]).

metamodel(persons,[
	 class('Male',[fullName]),
	 class('Female',[fullName])
	 ]).

helper(isMale).

isMale(X,true):- 'Family_father'(families,_,X);'Family_sons'(families,_,X).

helper(isFemale).

isFemale(X,true):- 'Family_mother'(families,_,X);'Family_daughters'(families,_,X).

helper(familyName).

familyName(X,Z):-('Family_father'(families,Y,X),'Family_lastName'(families,Y,Z));('Family_sons'(families,Y,X),'Family_lastName'(families,Y,Z));
('Family_mother'(families,Y,X),'Family_lastName'(families,Y,Z));('Family_daughters'(families,Y,X),'Family_lastName'(families,Y,Z)).


rule member2Male 
	from
		s :: families#'Member' where (isMale(s) == true)
	to
		t :: persons#'Male'(
			fullName <- concat(concat(s@firstName," "),familyName(s))	
		).


rule member2Female 
	from
		s :: families#'Member' where (isFemale(s) == true)
	to
		t :: persons#'Female'(
			fullName <- concat(concat(s@firstName," "),familyName(s))	
		).

