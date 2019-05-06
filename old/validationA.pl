%Metamodel A

%(1) All attributes of a data have distint names 

vrule(1):-		data_attr_of(er,Data,Att1),
						data_attr_of(er,Data,Att2),
						Att1\=Att2,
						attribute_name(er,Att1,Name1),
						attribute_name(er,Att2,Name2),
						Name1=Name2.
						
%(2) Each data has a key attribute

vrule(2):- setof(Att,data_attr_of(er,_,Att),LAtt),all_nonkey(LAtt).

all_nonkey([]).
all_nonkey([Att|RAtt]):-attribute_key(er,Att,false),all_nonkey(RAtt).


%(3) Each data has a unique key attribute 

vrule(3) :- data_attr_of(er,Data,Att1),
			data_attr_of(er,Data,Att2),
			Att1\=Att2,
			attribute_key(er,Att1,true),
			attribute_key(er,Att2,true).

%(4) Each attribute is associated to exactly one data 

vrule(4):-attribute_id(er,Att),
			attribute_is_att(er,Att,Data1),
			attribute_is_att(er,Att,Data2),
			Data1\=Data2.



%(5) Each data is contained in exactly one store

vrule(5):- setof(Store,data_contained_in(er,_,Store),Stores),Stores=[_,_|_].

 

%(6) All data have distinct names

vrule(6) :- data_name(er,Data,Name1),
					data_name(er,Data,Name2),
					Name1\=Name2.

%(7) All data have distinct containers

vrule(7) :-data_container(er,Data,Container1),
				data_container(er,Data,Container2),
				Container1\=Container2.


%(8) Each qualifier is associated to exactly one role

vrule(8) :- qualifier_has(er,Qualifier,Role1),
						qualifier_has(er,Qualifier,Role2),
						Role1\=Role2.

%(9)  All qualifier names of a data are distinct

vrule(9) :- qualifier_name(er,Qualifier,Name1),
						qualifier_name(er,Qualifier,Name2),
						Name1\=Name2.

%(10) All qualifiers are key attributes

vrule(10) :- qualifier_name(er,_,Name),
	\+(attribute_name(er,Attribute,Name)),
	attribute_key(er,Attribute,true).

%(11) Each relation has two roles

vrule(11) :- setof(Role,relation_is_role(er,_,Role),Roles),Roles\=[_,_].



%(12) All relation names are distinct

vrule(12):- relation_name(er,Relation1,Name1),
					relation_name(er,Relation2,Name2),
					Relation1\=Relation2,
					Name1=Name2.

%(13) Each role is associated to exactly one relation

vrule(13):- role_has_role(er,Role,Relation1),
				role_has_role(er,Role,Relation2),
				Relation1\=Relation2.

%(14) Each role is associated to exactly one data

vrule(14):-role_is_data(er,Role,Data1),
			role_is_data(er,Role,Data2),
			Data1\=Data2.

%(15) All role names of a data are distinct

vrule(15) :-data_role_of(er,Data,Role1),
				data_role_of(er,Data,Role2),
				role_name(er,Role1,Name1),
				role_name(er,Role2,Name2),
				Role1\=Role2,
				Name1=Name2.

%(16) Each store is associated to exactly one data

vrule(16) :- store_contains(er,Store,Data1),
					store_contains(er,Store,Data2),
					Data1\=Data2.


 