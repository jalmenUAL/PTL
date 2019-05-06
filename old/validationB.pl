 
%Metamodel  B


%(17) All col names of a row are distinct

vrule(17) :-row_is_col(rl,Row,Col1),
			row_is_col(rl,Row,Col2),
			Col1\=Col2,
			col_name(rl,Col1,Name1),
			col_name(rl,Col2,Name2),
			Name1=Name2.

%(18) All foreign names of a row are distinct

vrule(18) :-row_is_foreign(rl,Row,Foreign1),
				row_is_foreign(rl,Row,Foreign2),
				Foreign1\=Foreign2,
				foreign_name(rl,Foreign1,Name1),
				foreign_name(rl,Foreign2,Name2),
				Name1=Name2.

%(19) All key names of a row are distinct

vrule(19) :-row_is_key(rl,Row,Key1),
				row_is_key(rl,Row,Key2),
				Key1\=Key2,
				key_name(rl,Key1,Name1),
				key_name(rl,Key2,Name2),
				Name1=Name2.

%(20) All foreigns of a row are keys of another row

vrule(20):- row_is_foreign(rl,R,A),
			 row_name(rl,R,RC),
			 foreign_name(rl,A,NN),
			concat(RC,NameKey,NN),
			\+(key_name(rl,_,NameKey)).

%(21) Each table is associated to exactly one row

vrule(21) :- table_has(rl,Table,Row1),
			table_has(rl,Table,Row2),
			Row1\=Row2.

%(22) Each row is associated to exactly one table

vrule(22):-row_table(rl,Row,Table1),
			row_table(rl,Row,Table2),
			Table1\=Table2.

%(23) Each key is associated to exactly one row

vrule(23) :- key_has_key(rl,Key,Row1),
			key_has_key(rl,Key,Row2),
			Row1\=Row2.

%(24) Each col is associated to exactly one row

vrule(24) :- col_has_col(rl,Col,Row1),
			col_has_col(rl,Col,Row2),
			Row1\=Row2.

%(25) Each foreign is associated to exactly one row

vrule(25) :- foreign_has_foreign(rl,Foreign,Row1),
				foreign_has_foreign(rl,Foreign,Row2),
				Row1\=Row2.

%(26) All table names are distinct 

vrule(26) :- table_name(rl,Table1,Name1),
					table_name(rl,Table2,Name2),
					Table1\=Table2,
					Name1=Name2.

%(27) All row names are distinct

vrule(27) :- row_name(rl,Row1,Name1),
					row_name(rl,Row2,Name2),
					Row1\=Row2,
					Name1=Name2.

%(28) All rows have exactly one key

vrule(28) :- row_is_key(rl,Row,Key1),
			row_is_key(rl,Row,Key2),
			Key1\=Key2.

%(29) All rows have either all keys and cols or all foreigns

vrule(29):-row_is_key(rl,Row,_),
					row_is_foreign(rl,Row,_).
vrule(29):-row_is_col(rl,Row,_),
					row_is_foreign(rl,Row,_).


 