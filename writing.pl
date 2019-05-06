%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XMI WRITING September 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% XMI-WRITE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xmi_write(File):-xmi(XMI),
			write_xml(File,XMI).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WRITE-XML
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

write_xml(File,Term):-open(File,write,F),
			xml_write(F,Term,[]),
			close(F).

%%%%%%%%%%%%%%%%%%%%%%%%
% XMI  
%%%%%%%%%%%%%%%%%%%%%%%%

xmi(XMI):-retrieve_all(XMI).

%%%%%%%%%%%%%%%%%%%%%%%%
% RETRIEVE-ALL  
%%%%%%%%%%%%%%%%%%%%%%%%


retrieve_all(XMI):-retrieve_each_one([2],XMI).

			
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RETRIEVE-EACH-ONE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%


retrieve_each_one([],[]).

retrieve_each_one([Id|RId],[element(El,Atts,Nested)|Relement]):-
				element2(El,_,Id),!,
				findall(Name=Value,att2(Name,Value,Id,_),Atts),
				findall(IdN,element2(_,Id,IdN),NIds),  
				retrieve_each_one(NIds,Nested),
				retrieve_each_one(RId,Relement).

