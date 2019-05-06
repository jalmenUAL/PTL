 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MODEL TRANSFORMATION TOOL
% Jesus Almendros and Luis Iribarne (September 2014)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:-use_module(library('semweb/rdf_db')).
:-use_module(library('semweb/rdfs')).
:- use_module(library(lists)).


%%%%%%%DYNAMIC_PRED%%%%%%%%%%%%%%%%


:-      dynamic (element)/3.
:-      dynamic element_ecore/3.
:-      dynamic  (element2)/3.
:-      dynamic  att2/4.
:-      dynamic  att/4.
:-      dynamic  identifier/1.
:-      dynamic  identifier_ecore/2.
:-      dynamic  identifier_ecore2/2.
:-      dynamic  identifier_ecore2/3.
:-      dynamic  (rule)/1.
:-      dynamic  from/2. 
:-      dynamic (metamodel)/2.
:-      dynamic class_def/3.
:-      dynamic role_def/6.
:-      dynamic role_def/7.

:-      dynamic objectM/6.
:-      dynamic associationObjectsM/4.
:-      dynamic object/6.
:-      dynamic associationObjects/4.
:-      dynamic associationEnds/4.

:-      dynamic class/3.
:-      dynamic property/3.
:-      dynamic stereotype/3.
:-      dynamic association/3.

:-      dynamic input/4.
:-      dynamic output/4.

:-      dynamic vrule/1.
:-      dynamic pred_def/2.

:-      dynamic bcond/2.
 



 

load_op :-op(1040,xfy,[from]),
	op(1030,xfy,[to]),
	op(1010,xfy,[and]),
	op(885,xfy,[@]),
	op(1020,fx,[rule]),
	op(890,xfy,[#]),
	op(895,xfy,[::]),
	op(1000,xfy,[==]),
	op(1000,xfy,[=\=]),
	op(890,xfy,[<-]),
	op(1020,xfy,[where]).

:-load_op.
 

:- multifile (input)/3. 
:- multifile (output)/3.
:- multifile (metamodel)/2.
:- multifile (rule)/1.
:- multifile (vrule)/1.
:- multifile (helper)/1.


:-style_check(-discontiguous).

:-include('loading.pl').
:-include('writing.pl').
:-include('ecore2ptl.pl').
:-include('ptl2ecore.pl').
 

%%%%%%%LOAD_OP%%%%%%%%%%%%%%%%

load_op:-op(1040,xfy,[from]),
	op(1030,xfy,[to]),
	op(1010,xfy,[and]),
	op(885,xfy,[@]),
	op(1020,fx,[rule]),
	op(890,xfy,[#]),
	op(895,xfy,[::]),
	op(1000,xfy,[==]),
	op(1000,xfy,[=\=]),
	op(890,xfy,[<-]),
	op(1020,xfy,[where]).

 

nsp(A,B,R):-concat(A,':',AP),concat(AP,B,R).

%%%%%%%%%%%%%%INTERFACE%%%%%%%%%%%%%%

transform(Files):-clean_atl,%tell('transformation.log'),
		transform_files(Files).

debugging(Files):-clean_atl,%tell('debugging.log'),
		debugging_files(Files).

tracing(Files,Id):-clean_atl,%tell('tracing.log'),
		tracing_files(Files,Id).

intro:-assert(associationEnds(Model,B,C,D):-(nsp(Model,B,NB),rdf(C,NB,D))),fail.
intro.

ptl(Files):-clean_atl,%tell('transformation.log'),
		intro,
		transform_files([Files]).

debug(Files):-clean_atl,%tell('debugging.log'),
		intro,
		debugging_files([Files]).

trace(Files,Id):-clean_atl,%tell('tracing.log'),
		intro,
		tracing_files([Files],Id).



transform_files([]):-!.
transform_files([F|RF]):-
		   
		  atl(F),
		  transform_files(RF).		   

debugging_files([]):-!.
debugging_files([F|RF]):-
		   
		  debug_atl(F),
		  debugging_files(RF).		   

tracing_files([F],Id):-!,trace_atl(F,Id).
tracing_files([F|RF],Id):-
		   
		  atl(F),
		  tracing_files(RF,Id).		   


%%%%%%%%%%%%%MAIN CALLS%%%%%%%%%%

atl(Program):-rewrite(Program,Program2),
		[Program2],
		write('Compiling Metamodels: '),nl,
		time(generate_metamodels),
		write('Compiling Rules: '),nl,
		time(generate_rules),
		catch(load_models,_,(write('Compiler: Syntax error'),nl,fail)),
		clean_transformation.


debug_atl(Program):-nl,
		write('DEBUGGER...........................'),nl,
		rewrite(Program,Program2),[Program2],
		generate_metamodels,
		generate_rules,
		catch(load_models_deb,_,(write('Compiler: Syntax error'),nl,fail)),
		clean_transformation.

trace_atl(Program,Id):-nl,
		write('TRACER............................'),nl,
		write('Tracing the element: '),write(Id),nl,
		rewrite(Program,Program2),[Program2],
		generate_metamodels,
		generate_rules,
		catch(load_models,_,(write('Compiler: Syntax error'),nl,fail)),		
		catch(trace_elem(object(_,_,Id,_,_,_)),_,(write('Compiler: Syntax error'),nl,fail)),	
		clean_transformation.

%%%%%%%%GENERATE METAMODELS%%%%%%%%%%%%%%%%%%%%%%

generate_metamodels:-generate_input_metamodel,generate_output_metamodel.

generate_input_metamodel:-input(_,_,Metamodel,_),generate_metamodel(Metamodel).

generate_output_metamodel:-output(_,_,Metamodel,_),generate_metamodel(Metamodel).



%%%%%%%%%LOAD MODELS%%%%%%%%%%%%%%%%%

load_models:-load_input_model,load_output_model.

load_input_model:-input(_,_,Model,File),
			write('Load input:'),nl,time(xmi_load(File)),
			write('fromEcore: '),nl,time(load_ecore(Model)).

load_output_model:-output(Schema,Root,Model,File),
			load_model(Model),
			write('toECore: '),nl,time(write_ecore(Schema,Root,Model)),
			write('Write Output: '),nl,time(xmi_write(File)).


 

 
load_models_deb:-load_input_model_deb,load_output_model_deb.

load_input_model_deb:-input(_,_,Model,File),
			xmi_load(File),
			load_ecore(Model).

load_output_model_deb:-output(Schema,Root,Model,File),
			load_model_deb(Model),
			write_ecore(Schema,Root,Model),
			xmi_write(File).

%%%%%%%LOAD_MODEL%%%%%%%%%%%%%%%%


load_model(Name):-write('Conditions:'),nl,time(load_conds),
		write('Objects:'),nl,time(load_object(Name)),
		write('Associations:'),nl,time(load_association(Name)),fail.

load_model(Name):-helper(Name),recorda(helper,Name),fail.

load_model(_).



load_model_deb(Name):-load_conds_deb,
		load_object_deb(Name),
		load_association_deb(Name),fail.

load_model_deb(Name):-helper(Name),recorda(helper,Name),fail.

load_model_deb(_).

%%%%%%LOAD_CONDS%%%%%%%%%%%%%

load_conds:-(rule NameRule from _ to _),Call=..[NameRule,A],call(Call),assert(bcond(NameRule,A)),fail.



load_conds.


load_conds_deb:-(rule NameRule from _ to _),Call=..[NameRule,A],
			((findall(A,Call,L),L=[])->
			(clause(Call,Cond),debug_condition(NameRule,Cond,A),!);
			(call(Call),assert(bcond(NameRule,A)),fail)).

load_conds_deb.

%%%LOAD_OBJECT%%%%%%%%%%%%%

load_object(Name):- object(Name,A,B,C,D,E),assert(objectM(Name,A,B,C,D,E)),fail.

load_object(_).



load_object_deb(Name):- debug_term(object(Name,A,B,C,D,E)),assert(objectM(Name,A,B,C,D,E)),fail.

load_object_deb(_).


%%%LOAD_ASSOCIATION%%%%%%%%%%%

load_association(Name):-associationObjects(Name,A,B,C),assert(associationObjectsM(Name,A,B,C)),fail.

load_association(_).



load_association_deb(Name):-debug_term(associationObjects(Name,A,B,C)),assert(associationObjectsM(Name,A,B,C)),fail.

load_association_deb(_).

 



%%%%%%%DEBUG%%%%%%%%%%%%%%%%

debug_term(Head):-clause(Head,(C,Condition)),C=..[bcond,Rule,A],
			((findall(A,(C,Condition),L),L=[])->(C,debug_object(Rule,Condition,A),!);(C,Condition)).


%%%%%%%DEBUG_OBJECT%%%%%%%%%%%%%%%%

debug_object(Rule,Cond,A):-write('Debugger: Objects of: '),write(Rule),write(' cannot be created.'),nl,
				debug_sequence(Cond,A).

%%%%%%%DEBUG_SEQUENCE%%%%%%%%%%%%%%%%

debug_sequence((O,RO),A):-!,
		((findall(A,O,L),L=[])->write('Found error in: '),O=..[Name|_],write(Name),nl;(O,debug_sequence(RO,A))).

debug_sequence(O,A):-((findall(A,O,L),L=[])->write('Found error in: '),O=..[Name|_],write(Name),nl;true).




debug_condition(Rule,Cond,A):-write('Debugger: Rule Condition of: '),write(Rule),write(' cannot be satisfied.'),nl,
				debug_sequence(Cond,A).
 

%%%%%%%%%%%TRACE_ELEM%%%%%%%%%%%%%%%

trace_elem(O):-clause(O,Condition),call(Condition),trace_atoms(Condition),!.


%%%%%%%%%%%%TRACE_ATOMS%%%%%%%%%%%%%
 
trace_atoms((O,RO)):-!, 
			(recorded(pointer,O),O=..[bcond,Name|Vars]->write('Traced Execution....'),nl,write('Rule: '),
			write(Name),nl,BC=..[Name|Vars],trace_elem(BC);
			(recorded(pointer,O),O=..[Name|Vars]->trace_element(O);
			(recorded(access,O)->trace_elem(O);
			(recorded(metamodel,O)->trace_elem(O);
			(O=rdf(A,B,literal( C ))->write('Id: '),write(A),nl,write('Role: '), write(B),nl, write('Value: '), 
			write( C ),nl,nl;
			(O=rdf(_,B,C)->write('Element: '),write(B),nl,write('Id: '),write( C ),nl,nl
			;true)))))),
			trace_atoms(RO).

trace_atoms(O):-
		(recorded(pointer,O),O=..[bcond,Name|Vars]->write('Traced Execution....'),nl,write('Rule: '),
		write(Name),nl,BC=..[Name|Vars],trace_elem(BC);
		(recorded(pointer,O),O=..[Name|Vars]->trace_element(O);
		(recorded(access,O)->trace_elem(O);
		(recorded(metamodel,O)->trace_elem(O);
		(O=rdf(A,B,literal( C ))->write('Id: '),write(A),nl,write('Role: '), write(B),nl, write('Value: '), 
		write( C ),nl,nl;
		(O=rdf(_,B,C)->write('Element: '),write(B),nl,write('Id: '),write( C ),nl,nl
		;true)))))).

%%%%%%%%%%%INVERSE%%%%%%%%%%%%%%%

% :-inverse(object(rl,key,A,B,[name( C),type(E)],D)).
% :-inverse(object(rl,foreign,A,B,[name( C),type(E)],D)).

inverse:-objectM(A,B,C,D,E,F),inverse(object(A,B,C,D,E,F)),fail.
inverse.

inverse(O):-clause(O,Condition), 
		inverse_atoms(Condition).


%%%%%%%%%%%%INVERSE_ATOMS%%%%%%%%%%%%%
 
inverse_atoms((O,RO)):-!, 
			(recorded(pointer,O),O=..[bcond,Name|Vars]->write('Rule: '),write(Name),nl,BC=..[Name|Vars],inverse(BC);
			(recorded(pointer,O),O=..[Name|Vars]->inverse(O);
			(recorded(access,O)->inverse(O);
			(recorded(metamodel,O)->inverse(O);
			(O=nsp(A,B,C)->nsp(A,B,C);
			(O=generate_ids(A,B,C)->C=(A,B);
			(O=concat(A,B,C)->C=(A,B); %La inversa
			(O=rdf_assert(A,B,C)->true
			
			;call(O))))))))),
			inverse_atoms(RO).

inverse_atoms(O):-
		(recorded(pointer,O),O=..[bcond,Name|Vars]->write('Rule: '),write(Name),nl,BC=..[Name|Vars],inverse(BC);
		(recorded(pointer,O),O=..[Name|Vars]->inverse(O);
		(recorded(access,O)->inverse(O);
		(recorded(metamodel,O)->inverse(O);
		(O=nsp(A,B,C)->nsp(A,B,C);
		(O=generate_ids(A,B,C)->C=(A,B);
		(O=concat(A,B,C)->C=(A,B); %La inversa
		(O=rdf_assert(A,B,C)->true
		
		;call(O))))))))).


 
 


 
 
		 
%%%%%%%%%%%%%VALIDATION%%%%%%%%%%%%%%%%

validate(Program,Rules):-
		clean_atl, 
		ptl(Program),
		%tell('validation.log'),
		write('Validation................'),nl,
		validate_rules(Rules),fail.
		
validate(_,_):-clean_validation.
	
%%%%VALIDATE_RULES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

validate_rules(Rules):-[Rules],validate_rules_one.

validate_rules_one:-Head=..[vrule,N],
		clause(Head,Body),
		validate_body(N,Body).

validate_body(_,Body):- call(Body),!.

validate_body(N,_):-write('Validation failure on rule: '),write(N),nl.

clean_validation:-retractall(vrule(_)).

 

%%%%%%%GENERATE_METAMODEL%%%%%%%%%%%%%%%%
 

generate_metamodel(Metamodel):- 
		metamodel(Metamodel,MetaElems),!,
		generate_elems(MetaElems,Metamodel).

 

%%%%%%%GENERATE_ELEMS%%%%%%%%%%%%%%%%

generate_elems([],_):-!.

generate_elems([class(Name,Atts)|RMet],Metamodel):-!,
		assert(class_def(Name,Atts,Metamodel)),
		generate_vars(Atts,Elems),
		AtomHead=..[Name,Metamodel,Identifier,Elems],
		(output(Metamodel)->generate_heads(Name,Identifier,AtomHead,Elems,Metamodel);true),
		generate_access(Name,AtomHead,Elems,Identifier,Metamodel),
		generate_elems(RMet,Metamodel).

generate_elems([role(Name,Class,Class2,Low,Up)|RMet],Metamodel):-!,
		assert(role_def(Name,Class,Class2,Low,Up,Metamodel)),
		atom_concat(Class,'_',ClassS),
		atom_concat(ClassS,Name,Head),
		AtomHead=..[Head,Metamodel,IdO1,IdO2],
		(output(Metamodel)->
		assert(AtomHead:-associationObjectsM(Metamodel,Name,IdO1,IdO2));
		assert(AtomHead:-associationEnds(Metamodel,Name,IdO1,IdO2))),
		recorda(metamodel,AtomHead),	
		generate_elems(RMet,Metamodel).

%%%%MODIFICATION November 2014

generate_elems([role(Name,Class,Class2,Low,Up,container)|RMet],Metamodel):-!,
		assert(role_def(Name,Class,Class2,Low,Up,Metamodel,container)),
		atom_concat(Class,'_',ClassS),
		atom_concat(ClassS,Name,Head),
		AtomHead=..[Head,Metamodel,IdO1,IdO2],
		(output(Metamodel)->
		assert(AtomHead:-associationObjectsM(Metamodel,Name,IdO1,IdO2));
		assert(AtomHead:-associationEnds(Metamodel,Name,IdO1,IdO2))),
		recorda(metamodel,AtomHead),	
		generate_elems(RMet,Metamodel).

%%%%%%%%%%%%%%%%%

%%%%%%%GENERATE_HEADS%%%%%%%%%%%%%%%%

generate_heads(Name,Identifier,AtomHead,Elems,Metamodel):-
		AtomTail=..[objectM,Metamodel,Name,Identifier,_,Elems,_],
		assert(AtomHead:-AtomTail),recorda(head,AtomHead).

%%%%%%%GENERATE_ACCESS%%%%%%%%%%%%%%%%



generate_access(Name,_AtomTail,[],Identifier,Metamodel):-!,
		atom_concat(Name,'_',NameS),
		atom_concat(NameS,id,Head),
		AtomHead=..[Head,Metamodel,Identifier],
		(output(Metamodel)->assert(AtomHead:-element2(Name,_,Identifier));
		assert(AtomHead:- (nsp(Metamodel,Name,MName),rdf(_,MName,Identifier)))), 
		recorda(access,AtomHead).

generate_access(Name,AtomTail,[Elem|Elems],Identifier,Metamodel):-
		Elem=..[Att,Var],
		atom_concat(Name,'_',NameS),
		atom_concat(NameS,Att,Head),
		atom_concat(NameS,id,NameId),
		HeadId=..[NameId,Metamodel,Identifier],
		AtomHead=..[Head,Metamodel,Identifier,Var],
		(output(Metamodel)->assert(AtomHead:-att2(Att,Var,Identifier,_)); 		
		assert(AtomHead:-(HeadId,nsp(Metamodel,Att,MAtt),rdf(Identifier,MAtt,literal(Var))))),
		recorda(metamodel,AtomHead),
		generate_access(Name,AtomTail,Elems,Identifier,Metamodel).	




%%%%%%%GENERATE_RULES%%%%%%%%%%%%%%%%

generate_rules:-generate_rule(_),fail.

generate_rules.


  
%%%%%%%GENERATE_RULE%%%%%%%%%%%%%%%%

%WARNING: Condition always use pointers! Change Right,_Atom

generate_rule(NameRule):- (rule NameRule from E to Body), E = (From where Cond), 
				generate_pointers(From,Vars,_Atom),
				generate_conditions(Cond,Conds,Vars),
				clean_vars(Vars,VarsClean),
				Head=..[NameRule,VarsClean], 
				generate_head(Body,Vars,bcond(NameRule,VarsClean)),
				%Right=..[',',Atom,Conds],
				Right=Conds,
				assert(Head:-Right), 
				recorda(pointer,bcond(NameRule,VarsClean)),
				recorda(pointer,Head).

generate_rule(NameRule):- (rule NameRule from From to Body),From \= (_ where _),
				generate_pointers(From,Vars,Atom),
				clean_vars(Vars,VarsClean),
				Head=..[NameRule,VarsClean],
				generate_head(Body,Vars,bcond(NameRule,VarsClean)),
				assert(Head:-Atom), 
				recorda(pointer,bcond(NameRule,VarsClean)),
				recorda(pointer,Head).


%%%%%%%GENERATE_HEAD%%%%%%%%%%%%%%%%

%WARNING ResolveTemp has not metamodel information


generate_head(((Object :: Metamodel # G), ROb),Vars,Head):- !,
				G =.. [Class|Bindings],
				class_def(Class,Atts,Metamodel),
				clean_vars(Vars,VarsClean),
				generate_vars(Atts,Elems),
				generate_bindings(Metamodel,Head,Object,Class,Bindings,Vars,Elems,Conds),
				assert(object(Metamodel,Class,Id,VarsClean,Elems,Object):-	
				(Head,Conds,generate_ids(VarsClean,Object,Id),
				generate_ids(VarsClean,'',Input),
				%nsp(Metamodel,Object,MObject),
				rdf_assert(Input,Object,Id))), 
				generate_head(ROb,Vars,Head).

%WARNING ResolveTemp has not metamodel information


generate_head((Object :: Metamodel # G),Vars,Head):-
				G =.. [Class|Bindings],
				class_def(Class,Atts,Metamodel),
				clean_vars(Vars,VarsClean),
				generate_vars(Atts,Elems),
				generate_bindings(Metamodel,Head,Object,Class,Bindings,Vars,Elems,Conds),
				assert(object(Metamodel,Class,Id,VarsClean,Elems,Object):-
				(Head,Conds,generate_ids(VarsClean,Object,Id),
				generate_ids(VarsClean,'',Input),
				%nsp(Metamodel,Object,MObject),
				rdf_assert(Input,Object,Id))).


%%%%%%%GENERATE_POINTERS%%%%%%%%%%%%%%%%

generate_pointers((Object::Metamodel#Class,B),(Pointer,RV),(Atom,RAtom)):-!,
				atom_concat(Class,'_',ClassS),
				atom_concat(ClassS,'id',Head),
				Atom=..[Head,Metamodel,Var],
				Pointer=..[Object,Var,Class,Metamodel],
				generate_pointers(B,RV,RAtom).

generate_pointers((Object::Metamodel#Class),Pointer,Atom):-
				atom_concat(Class,'_',ClassS),
				atom_concat(ClassS,'id',Head),
				Atom=..[Head,Metamodel,Var],
				Pointer=..[Object,Var,Class,Metamodel].




%%%%%%%GENERATE_BINDINGS%%%%%%%%%%%%%%%%

generate_bindings(_,_,_,_,[],_,_,true).

generate_bindings(Metamodel,Head,Object,Class,[_ <- sequence([])|RBindings],Vars,Elems,Conds):-!,
		generate_bindings(Metamodel,Head,Object,Class,RBindings,Vars,Elems,Conds).

generate_bindings(Metamodel,Head,Object,Class,[Att <- sequence([Expr|RExpr])|RBindings],Vars,Elems,Conds):-!,
				generate_bind(Metamodel,Head,Object,Class,Att,Expr,Vars,Elems,Cond),
				generate_bindings(Metamodel,Head,Object,Class,RBindings,Vars,Elems,RCond),
				(Cond\=true->Conds=(RCond,Cond);Conds=RCond),
				generate_bindings(Metamodel,Head,Object,Class,
				[Att <- sequence(RExpr)|RBindings],Vars,Elems,Conds).

generate_bindings(Metamodel,Head,Object,Class,[Att <- Expr|RBindings],Vars,Elems,Conds):-
				generate_bind(Metamodel,Head,Object,Class,Att,Expr,Vars,Elems,Cond),
				generate_bindings(Metamodel,Head,Object,Class,RBindings,Vars,Elems,RCond),
				(Cond\=true->Conds=(RCond,Cond);Conds=RCond).


%%%%%%%GENERATE_BIND%%%%%%%%%%%%%%%%

%WARNING ResolveTemp has not metamodel information

generate_bind(_,_,_,_,Name,Expr,Vars,Elems,Cond):- pointer_to2(Name,Elems,Var),!,
					encode(Expr,Vars,Id,Enc),
					(Enc\=true->Var=Id,Cond=(Enc);
					Var=Id,Cond=(true)).

generate_bind(Metamodel,Head,Object,Class,Role,Expr,Vars,_,true):-
					role_def(Role,Class,_,_,_,Metamodel),!,
					encode(Expr,Vars,Id,Enc),
					clean_vars(Vars,VarsClean),
					assert(associationObjects(Metamodel,Role,IdClass,Id):-
					(Head,Enc,generate_ids(VarsClean,'',Input),
					%nsp(Metamodel,Object,MObject),
					rdf(Input,Object,IdClass))). 

%%%%%MODIFICATION November 2014

generate_bind(Metamodel,Head,Object,Class,Role,Expr,Vars,_,true):-
					role_def(Role,Class,_,_,_,Metamodel,container),!,
					encode(Expr,Vars,Id,Enc),
					clean_vars(Vars,VarsClean),
					assert(associationObjects(Metamodel,Role,IdClass,Id):-
					(Head,Enc,generate_ids(VarsClean,'',Input),
					%nsp(Metamodel,Object,MObject),
					rdf(Input,Object,IdClass))).

%%%%%%%%%%%%%%%%%%%%

%%%%%%%GENERATE_CONDITIONS%%%%%%%%%%%%%%%%

generate_conditions((Boolean and RB),(EncBoolean,RE),Vars):-!,
				encode_boolean(Boolean,EncBoolean,Vars),
				generate_conditions(RB,RE,Vars).

generate_conditions(Boolean,EncBoolean,Vars):-
				encode_boolean(Boolean,EncBoolean,Vars).

%%%%%%%GENERATE_ID%%%%%%%%%%%%%%%%

generate_id([],Object,Object).

generate_id([Id|RId],Object,IdG):-generate_id(RId,Object,IdRId),atom_concat(Id,IdRId,IdG).


%%%%%%%GENERATE_IDS%%%%%%%%%%%%%%%%

generate_ids((Id,RId),Object,IdG):-!,generate_ids(RId,Object,IdRId),atom_concat(Id,IdRId,IdG).

generate_ids(Id,Object,NewId):-atom_concat(Id,Object,NewId).

%%%%%%%GENERATE_VARS%%%%%%%%%%%%%%%%

generate_vars([],[]):-!.

generate_vars([Name|L],[Atom|V]):-Atom=..[Name,_],generate_vars(L,V).


%%%%%%%ENCODE_BOOLEAN%%%%%%%%%%%%%%%%


encode_boolean(Expr1==Expr2,(%Id1=Id2,
			Atom1,Atom2),Vars):-Id1=Id2,
			encode(Expr1,Vars,Id1,Atom1),encode(Expr2,Vars,Id2,Atom2).
					 
encode_boolean(Expr1=\=Expr2,(Id1\=Id2,Atom1,Atom2),Vars):-
			encode(Expr1,Vars,Id1,Atom1),encode(Expr2,Vars,Id2,Atom2).

encode_boolean(Expr1>Expr2,( 
			Atom1,Atom2,Id1>Id2),Vars):-
			encode(Expr1,Vars,Id1,Atom1),encode(Expr2,Vars,Id2,Atom2).

encode_boolean(Expr1>=Expr2,( 
			Atom1,Atom2,Id1>=Id2),Vars):-
			encode(Expr1,Vars,Id1,Atom1),encode(Expr2,Vars,Id2,Atom2).

encode_boolean(Expr1<Expr2,( 
			Atom1,Atom2,Id1<Id2),Vars):-
			encode(Expr1,Vars,Id1,Atom1),encode(Expr2,Vars,Id2,Atom2).

encode_boolean(Expr1=<Expr2,( 
			Atom1,Atom2,Id1=<Id2),Vars):-
			encode(Expr1,Vars,Id1,Atom1),encode(Expr2,Vars,Id2,Atom2).



%%%%%%%ENCODE%%%%%%%%%%%%%%%%

encode(Number,_,Number,true):-number(Number),!.

encode(true,_,true,true):-!.

encode(false,_,false,true):-!.

encode(String,_,Atom,true):-is_list(String),!,string_to_atom(String,Atom).

encode((Object@Role@Att),Vars,Id2,(Atom,Atom2)):-
			pointer_to(Object,Vars,Var,Class,Metamodel),
			atom_concat(Class,'_',ClassS),
			atom_concat(ClassS,Role,Head),
			Atom=..[Head,Metamodel,Var,Id],
			role_def(Role,Class,Class2,_,_,Metamodel),!,
			atom_concat(Class2,'_',ClassS2),
			atom_concat(ClassS2,Att,Head2),
			Atom2=..[Head2,Metamodel,Id,Id2].

%%%%%%%%MODIFICATION November 2014

encode((Object@Role@Att),Vars,Id2,(Atom,Atom2)):-
			pointer_to(Object,Vars,Var,Class,Metamodel),
			atom_concat(Class,'_',ClassS),
			atom_concat(ClassS,Role,Head),
			Atom=..[Head,Metamodel,Var,Id],
			role_def(Role,Class,Class2,_,_,Metamodel,container),!,
			atom_concat(Class2,'_',ClassS2),
			atom_concat(ClassS2,Att,Head2),
			Atom2=..[Head2,Metamodel,Id,Id2].

%%%%%%%%%%%%%%%%%%%%%%%%%
 
encode((Object@Att),Vars,Id,Atom):-!,
			pointer_to(Object,Vars,Var,Class,Metamodel),
			atom_concat(Class,'_',ClassS),
			atom_concat(ClassS,Att,Head),
			Atom=..[Head,Metamodel,Var,Id].

encode(resolveTemp(List,Pointer),Vars,Id,Atom):-!,
				encode_seq(List,Vars,Ids,Atoms),
				Atom=(Atoms,resolveTemp(Ids,Pointer,Id)).

encode(Compound,Vars,Id,Atom):-compound(Compound),Compound=..[Helper|List],atomic(Helper),!,
				encode_list(List,Vars,Ids,Atoms),
				append(Ids,[Id],Args),
				Call=..[Helper|Args],
				Atom=(Atoms,Call).


encode(Object,Vars,Var,Atom):-pointer_to(Object,Vars,Var,Class,Metamodel),!,
			atom_concat(Class,'_',ClassS),
			atom_concat(ClassS,'id',Head),
			Atom=..[Head,Metamodel,Var].

encode(Object,Vars,Var,Atom):-atomic(Object),!,
			clean_vars(Vars,VarsClean),
			Atom=resolveTemp(VarsClean,Object,Var).

 

%%%%%%%ENCODE_LIST%%%%%%%%%%%%%%%%


encode_list([],_,[],true).

encode_list([Ob|ROb],Vars,[Id|RId],Atoms):-encode(Ob,Vars,Id,Atom),
				encode_list(ROb,Vars,RId,RAtoms),
				Atoms=(RAtoms,Atom).

%%%%%%%ENCODE_SEQ%%%%%%%%%%%%%%%%

encode_seq((Ob,ROb),Vars,(Id,RId),Atoms):-!,encode(Ob,Vars,Id,Atom),
				encode_seq(ROb,Vars,RId,RAtoms),
				Atoms=(RAtoms,Atom).

encode_seq(Ob,Vars,Id,Atom):-encode(Ob,Vars,Id,Atom).


%%%%%%%POINTERS_TO%%%%%%%%%%%%%%%%

pointer_to(Object,Pointer,Var,Class,Metamodel):-Pointer=..[Object,Var,Class,Metamodel],!.

pointer_to(Object,(Pointer,_),Var,Class,Metamodel):-Pointer=..[Object,Var,Class,Metamodel],!.

pointer_to(Object,(_,RPointers),Var,Class,Metamodel):-pointer_to(Object,RPointers,Var,Class,Metamodel).

%%%%%%%POINTERS_TO2%%%%%%%%%%%%%%%%

pointer_to2(Object,[Pointer|_],Var):-Pointer=..[Object,Var].

pointer_to2(Object,[_|RPointers],Var):-pointer_to2(Object,RPointers,Var).

%%%%%%%CLEAN_VARS%%%%%%%%%%%%%%%%
 
clean_vars((Var,RVar),(Name,RName)):-!,Var=..[_,Name,_,_],clean_vars(RVar,RName).

clean_vars(Var,Name):-Var=..[_,Name,_,_].



%%%%%%%ASSOCIATIONENDS AND OBJECTMM %%%%%%%%%%%%%%%%

%WARNING: RDF contains links of target model

%associationEnds(Model,Name,Id1,Id2):-associationObjectsM(Model,Name,Id1,Id2).

objectMM(A,B,C,D,E,F):-objectM(A,B,C,D,E,F),!.


%%%%%%%RESOLVETEMP%%%%%%%%%%%%%%%%

%WARNING ResolveTemp has not metamodel information

resolveTemp(Pointers,Name,Id):-generate_ids(Pointers,'',Input),rdf(Input,Name,Id).

%resolveTemp(Pointers,Name,Id):-objectM(_,_,Id,Pointers,_,Name),!.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

output(Model):-output(_,_,Model,_).

%%%%%%%CLEAN_TRANSFORMATION%%%%%%%%%%%

clean_transformation:-retractall((rule _ from _)),fail.
clean_transformation:-retractall(input(_,_,_,_)),fail.
clean_transformation:-retractall(output(_,_,_,_)),fail.
clean_transformation:-retractall(schema(_,_,_)),fail.
clean_transformation.

%%%%%%%CLEAN_ATL%%%%%%%%%%%

clean_atl:-retractall(element2(_,_,_)),fail.
clean_atl:-retractall(element(_,_,_)),fail.
clean_atl:-retractall(element_ecore(_,_,_)),fail.
clean_atl:-retractall(att2(_,_,_,_)),fail.
clean_atl:-retractall(att(_,_,_,_)),fail.
clean_atl:-retractall(identifier(_)),fail.
clean_atl:-retractall(identifier_ecore(_,_)),fail.
clean_atl:-retractall(identifier_ecore2(_,_)),fail.
clean_atl:-retractall(identifier_ecore2(_,_,_)),fail.
clean_atl:-retractall((rule _ from _)),fail.
clean_atl:-retractall(metamodel(_,_)),fail.
clean_atl:-retractall(class_def(_,_,_)),fail.
clean_atl:-retractall(role_def(_,_,_,_,_,_)),fail.
clean_atl:-retractall(role_def(_,_,_,_,_,_,_)),fail.
clean_atl:-recorded(metamodel,Term,Key),retractall(Term),erase(Key),fail.
clean_atl:-recorded(head,Term,Key),retractall(Term),erase(Key),fail.
clean_atl:-recorded(access,Term,Key),retractall(Term),erase(Key),fail.
clean_atl:-recorded(pointer,Term,Key),retractall(Term),erase(Key),fail.
clean_atl:-recorded(helper,Term,Key),retractall(Term),erase(Key),fail.
clean_atl:-recorded(object,Term,Key),retractall(Term),erase(Key),fail.
clean_atl:-retractall(objectM(_,_,_,_,_,_)),fail.
clean_atl:-retractall(associationObjectsM(_,_,_,_)),fail.
clean_atl:-retractall(object(_,_,_,_,_,_)),fail.
clean_atl:-retractall(associationObjects(_,_,_,_)),fail.
clean_atl:-retractall(associationEnds(_,_,_,_)),fail.
clean_atl:-retractall(input(_,_,_,_)),fail.
clean_atl:-retractall(output(_,_,_,_)),fail.
clean_atl:-retractall(schema(_,_,_)),fail.
clean_atl:-retractall(vrule(_)),fail.
%CHANGE
clean_atl:-retractall(bcond(_,_)),fail.

clean_atl.

%%%%%%%%%%REWRITE%%%%%%%%%%%%%%%

rewrite(File,File2):-open(File,read,Stream),
		atom_concat(NameFile,'.ptl',File),
		atom_concat(NameFile,'.pl',File2),
		open(File2,write,Stream2),
		rewrite_file(Stream,Stream2),
		close(Stream2),
		close(Stream).

rewrite_file(Stream,_):-at_end_of_stream(Stream),!.
rewrite_file(Stream,Stream2):-
		get_char(Stream,C), 
		(C='$'->put(Stream2,':');
		(C='!'->put(Stream2,'#');
		(C=':'->(
			 get_char(Stream,D),
			 (D='-'->
			 (put(Stream2,C),put(Stream2,D));	
			 (put(Stream2,':'),put(Stream2,':'),put(Stream2,D)) 
			 )
			);
		put(Stream2,C) 
		))),
		rewrite_file(Stream,Stream2).

 
 