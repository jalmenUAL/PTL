%Cross Validation

%(30) Key and col names and types are names and types of attributes

vrule(30) :-  key_name(rl,_,Name),
					 attribute_name(er,_,Name).

vrule(30) :-  key_type(rl,_,Type),
					 attribute_type(er,_,Type).

vrule(30) :-  col_name(rl,_,Name),
					 \+(attribute_name(er,_,Name)).

vrule(30) :-  col_type(rl,_,Type),
					 \+(attribute_type(er,_,Type)).

%(31) Table names are either container names or role names 


vrule(31) :-  table_name(rl,_,Name),
					 \+(role_name(er,_,Name)),
					 \+(data_container(er,_,Name)).

 

%(32) Row names are data names or concatenations of role names and data

 
vrule(32) :-  row_name(rl,_,N),
					\+(data_name(er,_,N)),
					\+((role_name(er,_,N1),data_name(er,_,N2),
						concat(N1,N2,N))).
					
 
%(33) Foreign names are concatenations of roles, data and key attributes

vrule(33) :- foreign_name(rl,_,N),
				\+((role_name(er,_,N1),
					data_name(er,_,N2),
					attribute_name(er,_,N3),
					attribute_key(er,_,true),
					concat(N1,N2,NAux),
					concat(NAux,N3,N)
					)).
