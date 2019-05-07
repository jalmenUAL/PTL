%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TEST CASE GENERATION BETA September 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



gen_test(N,File):-
		generate_test(N),
		write_ecore('metamodelA','root',er),xmi_write(File),clean_atl.

schema('metamodelA','http://www.example.org/metamodelA','metamodelA.ecore').
input('metamodelA','root',er,'prueba100.xmi').

generate_test(N):-generate_obj(er,'store',[name('s1')],'s1',N),fail.
generate_test(N):-generate_obj(er,'store',[name('s2')],'s2',N),fail.
generate_test(N):-generate_obj(er,'data',[name('d1'),container('c1')],'d1',N),fail.
generate_test(N):-generate_obj(er,'data',[name('d2'),container('c2')],'d2',N),fail.
generate_test(N):-generate_obj(er,'attribute',[name('a11'),type(''),key('true')],'a11',N),fail.
generate_test(N):-generate_obj(er,'attribute',[name('a12'),type(''),key('false')],'a12',N),fail.
generate_test(N):-generate_obj(er,'attribute',[name('a21'),type(''),key('true')],'a21',N),fail.
generate_test(N):-generate_obj(er,'attribute',[name('a22'),type(''),key('false')],'a22',N),fail.
generate_test(N):-generate_obj(er,'relation',[name('r')],'r',N),fail.
generate_test(N):-generate_obj(er,'role',[name('r1'),navigable('true'),min('0'),max('*')],'r1',N),fail.
generate_test(N):-generate_obj(er,'role',[name('r2'),navigable('false'),min('0'),max('*')],'r2',N),fail.
generate_test(N):-generate_obj(er,'qualifier',[name('a11'),type('')],'a11',N),fail.
generate_test(N):-generate_obj(er,'qualifier',[name('a21'),type('')],'a21',N),fail.
generate_test(N):-generate_ass(er,'store','data','contains','s1','d1',N),fail.
generate_test(N):-generate_ass(er,'data','store','contained_in','d1','s1',N),fail.
generate_test(N):-generate_ass(er,'store','data','contains','s2','d2',N),fail.
generate_test(N):-generate_ass(er,'data','store','contained_in','d2','s2',N),fail.
generate_test(N):-generate_ass(er,'attribute','data','is','a11','d1',N),fail.
generate_test(N):-generate_ass(er,'data','attribute','attr_of','d1','a11',N),fail.
generate_test(N):-generate_ass(er,'attribute','data','is','a12','d1',N),fail.
generate_test(N):-generate_ass(er,'data','attribute','attr_of','d1','a12',N),fail.
generate_test(N):-generate_ass(er,'attribute','data','is','a21','d2',N),fail.
generate_test(N):-generate_ass(er,'data','attribute','attr_of','d2','a21',N),fail.
generate_test(N):-generate_ass(er,'attribute','data','is','a22','d2',N),fail.
generate_test(N):-generate_ass(er,'data','attribute','attr_of','d2','a22',N),fail.
generate_test(N):-generate_ass(er,'relation','role','is_role','r','r1',N),fail.
generate_test(N):-generate_ass(er,'relation','role','is_role','r','r2',N),fail.
generate_test(N):-generate_ass(er,'role','relation','has_role','r1','r',N),fail.
generate_test(N):-generate_ass(er,'role','relation','has_role','r2','r',N),fail.
generate_test(N):-generate_ass(er,'role','data','is_data','r1','d1',N),fail.
generate_test(N):-generate_ass(er,'role','data','is_data','r2','d2',N),fail.
generate_test(N):-generate_ass(er,'data','role','role_of','d1','r1',N),fail.
generate_test(N):-generate_ass(er,'data','role','role_of','d2','r2',N),fail.
generate_test(N):-generate_ass(er,'role','qualifier','is','r1','a11',N),fail.
generate_test(N):-generate_ass(er,'qualifier','role','has','a11','r1',N),fail.
generate_test(N):-generate_ass(er,'role','qualifier','is','r2','a21',N),fail.
generate_test(N):-generate_ass(er,'qualifier','role','has','a21','r2',N),fail.
generate_test(_).

generate_obj(_,_,_,_,0):-!.
generate_obj(Metamodel,Class,Atts,Name,N):-
				M is N-1,
				concat(Class,N,ClassN),
				concat(ClassN,Name,ClassName),
				assert(objectM(Metamodel,Class,ClassName,'',Atts,'test')),
				generate_obj(Metamodel,Class,Atts,Name,M).

generate_ass(_,_,_,_,_,_,0):-!.
generate_ass(Metamodel,Class1,Class2,Role,Name1,Name2,N):-
				concat(Class1,N,Class1N),
				concat(Class1N,Name1,Class1Name),
				concat(Class2,N,Class2N),
				concat(Class2N,Name2,Class2Name),
				assert(associationObjectsM(Metamodel,Role,Class1Name,Class2Name)),
				M is N-1,
				generate_ass(Metamodel,Class1,Class2,Role,Name1,Name2,M).

