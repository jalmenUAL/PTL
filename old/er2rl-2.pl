input('metamodelA','root',er,'object-model-A-2.xmi').
output('metamodelB','root',rl,'object-model-B-2.xmi').
schema('metamodelA','http:://www.example.org/metamodelA','metamodelA.ecore').
schema('metamodelB','http:://www.example.org/metamodelB','metamodelB.ecore').
rdf_db::ns(er, 'http:://www.example.org/metamodelA#').
rdf_db::ns(rl, 'http:://www.example.org/metamodelB#').

 
metamodel(er,[
	class(data,[name,container]),
	class(store,[name]),
	class(attribute,[name,type,key]),
	class(relation,[name]),
	class(role,[name,navigable,min,max]),
	class(qualifier,[name,type]),
	role(contains,store,data,"1","1"),
	role(contained_in,data,store,"1","1"),
	role(attr_of,data,attribute,"0","*",container),
	role(has_role,role,relation,"1","1"),
	role(is_role,relation,role,"1","*"),
	role(has,qualifier,role,"1","1"),
	role(is,role,qualifier,"0","*"),
	role(is_data,role,data,"1","1"),
	role(role_of,data,role,"1","1")]
).

metamodel(rl,[
		class(table,[name]),
		class(row,[name]),
		class(key,[name,type]),
		class(foreign,[name,type]),
		class(col,[name,type]),
		role(has,table,row,"1","1",container),
		role(has_key,key,row,"1","1"),
		role(is_key,row,key,"0","*"),
		role(is_foreign,row,foreign,"0","*"),
		role(has_foreign,foreign,row,"1","1"),
		role(has_col,col,row,"1","1"),
		role(is_col,row,col,"0","*")]
).

%%%%%%%%%
 
 
rule table1_er2rl from 
	p::er#data to 
		(t::rl#table(
			name <- p@container,
			has <- r
			   ),
		 r::rl#row(
			name <- p@name, 
			%table <- t, 
			is_key <- resolveTemp(p@attr_of,k), 
			is_col <- resolveTemp(p@attr_of,c)
			  )
		 ).

%%%%%%%%%%%%

rule table2_er2rl from 
	p::er#role where (p@navigable==true and p@max=="*") to 
		(t::rl#table(
			name <- p@name, 
			has <- r
			   ),
		 r::rl#row(
			name <- concat(p@name,p@is_data@name),
			%table <-t, 
			is_foreign <- sequence([resolveTemp((p@is,p),f1),
					resolveTemp(
					(inverse1_qualifier( p ),
					inverse2_qualifier( p )),
					f2)])
			 )
		 ).

%%%%%%%%%%%%%

rule key_er2rl from 
	p::er#attribute where (p@key==true)  
		to 
             (k::rl#key(
		    name <- p@name,
		    type <- p@type, 
                    has_key <-resolveTemp(p@is,r)
                      )
              ).

%%%%%%%%%%%%%%

rule col_er2rl from 
	 p::er#attribute where (p@key==false) to 
		(c::rl#col(
                      name <- p@name,
                      type <- p@type, 
                      has_col <- resolveTemp(p@is,r)
                         )
                 ).

%%%%%%%%%%%%%%

rule foreign1_er2rl from 
	(p::er#qualifier,q::er#role) where (p@has == q   and q@navigable==true) to 
		 (f1::rl#foreign(
			   name <- 
concat(concat(q@name,q@is_data@name),p@name), 

			   type <- p@type,
			   has_foreign <- resolveTemp(q,r)
			       )
		).

%%%%%%%%%%%%%%

rule foreign2_er2rl from 
	(p::er#qualifier,q::er#role) where (p@has == q and q@navigable==false) to 
		(f2::rl#foreign(
			name <- concat(concat(q@name,q@is_data@name),p@name), 
			type <- p@type,
			has_foreign <- resolveTemp(inverse2_row( p ),r)
			      )
		).


helper(inverse1_qualifier).

inverse1_qualifier(IdP,IdQ):- 
			associationEnds(er,has_role,IdP,IdAss),
			associationEnds(er,is_role,IdAss,IdRole),
			role_navigable(er,IdRole,false),
			associationEnds(er,is,IdRole,IdQ).
			 
helper(inverse2_qualifier).
			 
inverse2_qualifier(IdP,IdRole):- 
			associationEnds(er,has_role,IdP,IdAss),
			associationEnds(er,is_role,IdAss,IdRole),
			role_navigable(er,IdRole,false).
			 
helper(inverse2_row).

inverse2_row(IdQ,IdRole2):-associationEnds(er,has,IdQ,IdRole),
			associationEnds(er,has_role,IdRole,IdAss),
			associationEnds(er,is_role,IdAss,IdRole2),
			role_navigable(er,IdRole2,true).
			 

 