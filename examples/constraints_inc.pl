%ptl(‘incquery1.ptl’),time(findall(R1,signalNeighbor(R1),LR1)),ptl(‘incquery2.ptl’),time(findall(R2,signalNeighbor(R2),LR2)),ptl(‘incquery4.ptl’),time(findall(R4,signalNeighbor(R4),LR4)),ptl(‘incquery8.ptl’),time(findall(R8,signalNeighbor(R8),LR8)),ptl(‘incquery16.ptl’),time(findall(R16,signalNeighbor(R16),LR16)),ptl(‘incquery32.ptl’),time(findall(R32,signalNeighbor(R32),LR32)),ptl(‘incquery64.ptl’),time(findall(R64,signalNeighbor(R64),L64)),ptl(‘incquery128.ptl’),time(findall(R128,signalNeighbor(R128),LR128)),ptl(‘incquery256.ptl’),time(findall(R256,signalNeighbor(R256),L256)),ptl(‘incquery512.ptl’),time(findall(R512,signalNeighbor(R512),L512)).


switchSensor(Individual):-'contains_xsi:type'(concept,Individual,'Concept:Switch'),
			\+ contains_TrackElement_sensor(concept,Individual,_).

posLength(Source,Target):-%’contains_xsi:type'(concept,Source,'Concept:Segment'),
			contains_Segment_length(concept,Source,Target),
			atom_number(Target,D),D=<0.

routeSensor(Sen,Sw,Sp,R):-%’contains_xsi:type'(concept,R,'Concept:Route'),
			%’contains_xsi:type'(concept,Sw,'Concept:Switch'),
			%’contains_xsi:type'(concept,Sp,'Concept:SwitchPosition'),
			%’contains_xsi:type'(concept,Sen,'Concept:Sensor'),
			contains_Route_switchPosition(concept,R,Sp),
			contains_SwitchPosition_switch(concept,Sp,Sw),
			contains_TrackElement_sensor(concept,Sw,Sen),
			\+ contains_Route_routeDefinition(concept,R,Sen).

signalNeighbor(R1):-exitSignalSensor(SigA,R1,Sen1A),
			connectingSensors(Sen1A,Sen2A),
			rDefinition(R3A,Sen2A),
			R3A \== R1,
			\+ entrySignalSensor(SigA,_R2A,Sen2A).

exitSignalSensor(Sig,R1,Sen1):-exitSignal(R1,Sig),
				rDefinition(R1,Sen1).

entrySignalSensor(Sig,R2,Sen2):-entrySignal(R2,Sig),
			rDefinition(R2,Sen2).

entrySignal(R,Sig):-%’contains_xsi:type'(concept,R,'Concept:Route'),
			%’contains_xsi:type'(concept,Sig,'Concept:Signal'),
			contains_Route_entry(concept,R,Sig).

exitSignal(R,Sig):-
			%’contains_xsi:type'(concept,R,'Concept:Route'),
			%’contains_xsi:type'(concept,Sig,'Concept:Signal'),
			contains_Route_exit(concept,R,Sig).


rDefinition(R,Sen):- 
			%’contains_xsi:type'(concept,R,'Concept:Route'),
			%’contains_xsi:type'(concept,Sen,'Concept:Sensor'),
			contains_Route_routeDefinition(concept,R,Sen).

connectingSensors(Sen1,Sen2):-sensorTrackelement(Sen1,Te1),
				sensorTrackelement(Sen2,Te2),
				trackelementConnected(Te1,Te2).

trackelementConnected(Te1,Te2):-
			contains_TrackElement_connectsTo(concept,Te1,Te2).

sensorTrackelement(Sen,Te):-%’contains_xsi:type'(concept,Sen,'Concept:Sensor'),
				contains_Sensor_trackElement(concept,Sen,Te).