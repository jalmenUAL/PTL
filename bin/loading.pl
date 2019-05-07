
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XMI LOADING September 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XMI_LOAD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmi_load(Doc):-load_facts(Doc).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD-XML
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load_xml(Doc,List):-load_structure(Doc,List,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD_FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load_facts(Doc):-	
			load_xml(Doc,List), 
			update(N),
			facts(List,N).

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FACTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

facts([],_):-!.


facts([element(Name,Att,Nested)|Relem],IdF):-!,update(Id),
						update-ecore(Name,Id2),
						assert(element(Name,IdF,Id)),
						assert(element_ecore(Name,Id2,Id)),
						facts_att(Att,Id),
						facts(Nested,Id),
						facts(Relem,IdF).

facts([_|Relem],IdF):-facts(Relem,IdF).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FACTS_ATT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

facts_att([],_):-!.

facts_att([Att=Value|RAtt],IdF):-update(Id),
				assert(att(Att,Value,IdF,Id)),
				facts_att(RAtt,IdF).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


update(N):-identifier(M),!,
		N is M+1,
		retract(identifier(M)),
		assert(identifier(N)).

update(N):-N=1,assert(identifier(1)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATE-ECORE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

update-ecore(C,N):-identifier_ecore(C,M),!,
			N is M+1,
			retract(identifier_ecore(C,M)),
			assert(identifier_ecore(C,N)).

update-ecore(C,N):-N=0,assert(identifier_ecore(C,N)).
