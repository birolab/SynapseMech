%% SynapseMech
%
%    Copyright Daryan Kempe, 2018-2022, UNSW Sydney
%    email: d (dot) kempe (at) unsw (dot) edu (dot) au


%%  Description:
%
%   Input: *_ExportSynapseMech.mat-file 
%   created with Imaris XT "Export_SynapseMech"
 

%% Citation

%  If you use ExportSynapseMech and SynapseMech successfully for your research, 
%  please be so kind to cite our work:

%  "T cell cytoskeletal forces shape synapse topography for targeted lysis
%  via membrane curvature bias of perforin"
%
%  by Matt A. Govendir, Daryan Kempe, Setareh Sianati, James Cremasco, Jessica K. Mazalo, Feyza Colakoglu, Matteo Golo, Kate Poole, and Maté Biro
%
%  Developmental Cell (2022) [In press]


clear all 
   
[FileNames,PathNames] = uigetfile('*Export_SynapseMech.mat','Select files','MultiSelect','on');

%% USER INPUT

INTERFACE_LIMIT=sqrt(3); %Voxel Diagonal


%% LOAD AND CHECK INPUT

if iscell(FileNames)
    
 NO_FILES=numel(FileNames);
 
 for i=1:NO_FILES
    
 FileMerge{i}=[PathNames FileNames{i}];
    
 Input{i}=load(FileMerge{i});
 
 
if isempty(Input{i}.DataOut.Cytoplasm)&&isempty(Input{i}.DataOut.Lifeact)
 
     error('Surface 1 missing! Cell-cell interface determination not possible')
     
 elseif isempty(Input{i}.DataOut.Target)
     
     error('Surface 2 missing! Cell-cell interface determination not possible')
     
 else
     
 end
 
 
 
end
 
else
    
    NO_FILES=1;
    
    for i=1:NO_FILES
    
 FileMerge{i}=[PathNames FileNames];
    
 Input{i}=load(FileMerge{i});
 
 
if isempty(Input{i}.DataOut.Cytoplasm)&&isempty(Input{i}.DataOut.Lifeact)
 
     error('Surface 1 missing! Cell-cell interface determination not possible')
     
 elseif isempty(Input{i}.DataOut.Target)
     
     error('Surface 2 missing! Cell-cell interface determination not possible')
     
 else
     
 end
 
 
end
    
end


%% Retrieve Surface and Spots coordinates
 
[SURF,SPOTS]=CoordinatesFun(Input,NO_FILES);

%% Determine Tail Length

[TAIL_LENGTH, TAIL_VOLUME, TIMEOFCONTACT]=Tail_lengthFun(Input,SURF,NO_FILES);

%% Create high-res surfaces and determine cell-cell-interface
%  based on binary mask overlap

[SURFHR,SYNAPSEHR]=Synapse_findFun(SURF,NO_FILES,INTERFACE_LIMIT);


%% Determine Synapse area

%AREA{i,1}: Interface 1
%AREA{i,2}: Interface 2

[AREA, SYNAPSE_FACES]=Synapse_AreaFun(SYNAPSEHR,SURFHR,NO_FILES);

%% Determine curvature of low-res surface and map to high res synapse

[SURFCURVATURE,SYNAPSECURVATURE]=Curvature_detFun(SURF,SYNAPSEHR,NO_FILES);

%% Determine distances of spots to synapses and degranulation pockets and curvatures at degranulation pockets

[DISTANCES,CURVATURES,DEGRANULATIONPOCKETS]=DIST_DET_Fun(SPOTS,SYNAPSEHR, SYNAPSECURVATURE, NO_FILES);

%% Save result

for i=1:NO_FILES
    
FileNameSave{i}= [FileMerge{i}(1:end-23) '_Analysis_SynapseMech.mat'];

OUTPUT.SURF{i,1}=SURF{i,1};
OUTPUT.SURF{i,2}=SURF{i,2};
OUTPUT.SURF{i,3}=SURF{i,3};

OUTPUT.SPOTS{i}=SPOTS{i};

OUTPUT.TAIL_LENGTH{i}=TAIL_LENGTH{i};
OUTPUT.TAIL_VOLUME{i}=TAIL_VOLUME{i};
OUTPUT.TIMEOFCONTACT(i)=TIMEOFCONTACT(i);


OUTPUT.SURFHR{i,1}=SURFHR{i,1};
OUTPUT.SURFHR{i,2}=SURFHR{i,2};

OUTPUT.SYNAPSEHR{i,1}=SYNAPSEFHR{i,1};
OUTPUT.SYNAPSEHR{i,2}=SYNAPSEHR{i,2};

OUTPUT.AREA{i,1}=AREA{i,1};
OUTPUT.AREA{i,2}=AREA{i,2};

OUTPUT.SYNAPSE_FACES{i,1}=SYNAPSE_FACES{i,1};
OUTPUT.SYNAPSE_FACES{i,2}=SYNAPSE_FACES{i,2};

OUTPUT.SURFCURVATURE{i,1}=SURFCURVATURE{i,1};
OUTPUT.SURFCURVATURE{i,2}=SURFCURVATURE{i,2};

OUTPUT.SYNAPSECURVATURE{i,1}=SYNAPSECURVATURE{i,1};
OUTPUT.SYNAPSECURVATURE{i,2}=SYNAPSECURVATURE{i,2};

OUTPUT.DISTANCES{i}=DISTANCES{i};
OUTPUT.CURVATURES{i}=CURVATURES{i};
OUTPUT.DEGRANULATIONPOCKETS{i}=DEGRANULATIONPOCKETS{i};

save(FileNameSave{i},'OUTPUT','-v7.3')
  
end

