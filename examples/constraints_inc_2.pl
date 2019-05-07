


switchSensor(Individual):-'contains_xsi:type'(concept,Individual,'Concept:Switch'),
			\+ contains_TrackElement_sensor(concept,Individual,_).

posLength(Source,Target):-%’contains_xsi:type'(concept,Source,'Concept:Segment'),
			contains_Segment_length(concept,Source,Target),
			'contains_xsi:type'(concept,Source,'Concept:Segment'),
			atom_number(Target,D),D=<0.

routeSensor(Sen,Sw,Sp,R):-%’contains_xsi:type'(concept,R,'Concept:Route'),
			%’contains_xsi:type'(concept,Sw,'Concept:Switch'),
			%’contains_xsi:type'(concept,Sp,'Concept:SwitchPosition'),
			%’contains_xsi:type'(concept,Sen,'Concept:Sensor'),
			contains_Route_switchPosition(concept,R,Sp),
			contains_SwitchPosition_switch(concept,Sp,Sw),
			contains_TrackElement_sensor(concept,Sw,Sen),
			'contains_xsi:type'(concept,R,'Concept:Route'),
			'contains_xsi:type'(concept,Sw,'Concept:Switch'),
			'contains_xsi:type'(concept,Sp,'Concept:SwitchPosition'),
			'contains_xsi:type'(concept,Sen,'Concept:Sensor'),
			\+ contains_Route_routeDefinition(concept,R,Sen).


signalNeighbor(R1):-
			contains_Route_exit(concept,R1,SigA),
			contains_Route_routeDefinition(concept,R1,Sen1A),
			contains_Route_routeDefinition(concept,R3A,Sen2A),
			R3A \== R1,
			contains_Sensor_trackElement(concept,Sen2A,Te2),
			\+ entrySignalSensor(SigA,_R2A,Sen2A),
			contains_Sensor_trackElement(concept,Sen1A,Te1),
			contains_TrackElement_connectsTo(concept,Te1,Te2).

entrySignalSensor(Sig,R2,Sen2):- 
			contains_Route_entry(concept,R2,Sig),
			contains_Route_routeDefinition(concept,R2,Sen2).

 
 

 

