generate_test(_):-assert(element2('metamodelA:root',1,2)),fail.
generate_test(N):-generate_element('store',N),fail.
generate_test(N):-generate_element('data',N),fail.
generate_test(N):-generate_element('attribute',N),fail.
generate_test(N):-generate_element('role',N),fail.
generate_test(N):-generate_element('qualifier',N),fail.
generate_test(N):-generate_element('relation',N),fail.
generate_test(N):-generate_att('store','name',N),fail.
generate_test(N):-generate_att('data','name',N),fail.
generate_test(N):-generate_att('data','container',N),fail.
generate_test(N):-generate_att('attribute','name',N),fail.
generate_test(N):-generate_att('attribute','type',N),fail.
generate_test(N):-generate_att('attribute','key',N),fail.
generate_test(N):-generate_att('relation','name',N),fail.
generate_test(N):-generate_att('role','name',N),fail.
generate_test(N):-generate_att('role','navigable',N),fail.
generate_test(N):-generate_att('role','min',N),fail.
generate_test(N):-generate_att('role','max',N),fail.
generate_test(N):-generate_att('qualifier','name',N),fail.
generate_test(N):-generate_att('qualifier','type',N),fail.
generate_test(N):-generate_ass('store','data','contains',N),fail.
generate_test(N):-generate_ass('data','store','contained_in',N),fail.
generate_test(N):-generate_ass('attribute','data','is',N),fail.
generate_test(N):-generate_ass('data','attribute','attr_of',N),fail.
generate_test(N):-generate_ass('relation','role','is_role',N),fail.
generate_test(N):-generate_ass('role','relation','has_role',N),fail.
generate_test(N):-generate_ass('role','data','id_data',N),fail.
generate_test(N):-generate_ass('data','role','role_of',N),fail.
generate_test(N):-generate_ass('role','qualifier','is',N),fail.
generate_test(N):-generate_ass('qualifier','role','has',N),fail.
generate_test(_).

generate_element(_,0):-!.
generate_element(Name,N):-concat(Name,N,NameN),assert(element2(Name,2,NameN)),
				M is N-1,
				generate_element(Name,M).

generate_att(_,_,0):-!.
generate_att(Class,Name,N):-concat(Class,N,ClassN),
			concat(Name,N,NameN),
			assert(att2(Name,'',ClassN,NameN)),
			M is N-1,
			generate_att(Class,Name,M).

generate_ass(_,_,_,0):-!.
generate_ass(Class1,Class2,Role,N):-
				concat(Class1,N,Class1N),
				concat(Class2,N,Class2N),
				concat(Role,N,RoleN),
				assert(att2(Role,Class1N,Class2N,RoleN)),
				M is N-1,
				generate_ass(Class1,Class2,Role,M).

