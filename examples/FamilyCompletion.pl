input('xmi','XMI',families,'Families.xmi').
output('xmi','XMI',familiesFull,'FamiliesCompletion.xmi').
rdf_db::ns(families, 'http:://www.example.org/Families#').
rdf_db::ns(familiesFull, 'http:://www.example.org/FamiliesFull#').

metamodel(families,[
	 class('Family',[name]),
	 role(father,'Family','Family',"0","1"),
	 role(mother,'Family','Family',"0","1"),
         role(sons,'Family','Family',"0","*"),
         role(daughters,'Family','Family',"0","*")
	 ]).

metamodel(familiesFull,[
	 class('Person',[name]),
         role(ancestors,'Person','Person',"0","*"),
	 role(sisters,'Person','Person',"0","*"),
	 role(brothers,'Person','Person',"0","*"),
	 role(uncles,'Person','Person',"0","*"),
	 role(aunts,'Person','Person',"0","*")
	 ]).

helper(ancestors).

ancestors(X,Y):-'Family_father'(families,X,Y).
ancestors(X,Y):-'Family_mother'(families,X,Y).
ancestors(X,Z):-'Family_father'(families,X,Y),ancestors(Y,Z).
ancestors(X,Z):-'Family_mother'(families,X,Y),ancestors(Y,Z).

helper(sisters).

sisters(X,Y):-'Family_father'(families,X,Z),'Family_daughters'(families,Z,Y),Y\==X.
sisters(X,Y):-'Family_mother'(families,X,Z),'Family_daughters'(families,Z,Y),Y\==X.


helper(brothers).

brothers(X,Y):-'Family_father'(families,X,Z),'Family_sons'(families,Z,Y),Y\==X.
brothers(X,Y):-'Family_mother'(families,X,Z),'Family_sons'(families,Z,Y),Y\==X.

helper(uncles).

uncles(X,Y):- 'Family_father'(families,X,Z),brothers(Z,Y).
uncles(X,Y):- 'Family_mother'(families,X,Z),brothers(Z,Y).

helper(aunts).

aunts(X,Y):- 'Family_father'(families,X,Z),sisters(Z,Y).
aunts(X,Y):- 'Family_mother'(families,X,Z),sisters(Z,Y).


rule completion from f::families#'Family' to
			(ff::familiesFull#'Person'(name <- f@name,
			ancestors <- resolveTemp(ancestors( f ),ff),
			sisters <- resolveTemp(sisters( f ),ff),
			brothers <- resolveTemp(brothers( f ),ff),
			uncles <- resolveTemp(uncles(f),ff),
			aunts <- resolveTemp(aunts(f),ff)
			)).





