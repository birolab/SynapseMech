%% SynapseMech
% Daryan Kempe, UNSW Sydney, 2020-2022

clear all 
   
[FileNames,PathNames] = uigetfile('*Export_SynapseMech.mat','Select files','MultiSelect','on');

%% USER INPUT

SWITCH_HR='off';
FACTOR=1; %(Smaller values will improve distance/Synapse estimation but will increase running time)
THRESH_DIST=2;
SWITCH_PLOT='on';


%% LOAD AND CHECK INPUT

if iscell(FileNames)
    
 NO_FILES=numel(FileNames);
 
 for i=1:NO_FILES
    
 FileMerge{i}=[PathNames FileNames{i}];
    
 Input{i}=load(FileMerge{i});
 
 
if isempty(Input{i}.DataOut.Cytoplasm)&&isempty(Input{i}.DataOut.Lifeact)
 
     error('Surface 1 missing! No Synapse determination possible')
     
 elseif isempty(Input{i}.DataOut.Target)
     
     error('Surface 2 missing! No Synapse determination possible')
     
 else
     
 end
 
 
 
end
 
else
    
    NO_FILES=1;
    
    for i=1:NO_FILES
    
 FileMerge{i}=[PathNames FileNames];
    
 Input{i}=load(FileMerge{i});
 
 
if isempty(Input{i}.DataOut.Cytoplasm)&&isempty(Input{i}.DataOut.Lifeact)
 
     error('Surface 1 missing! No Synapse determination possible')
     
 elseif isempty(Input{i}.DataOut.Target)
     
     error('Surface 2 missing! No Synapse determination possible')
     
 else
     
 end
 
 
end
    
end


%% Retrieve Surface and Spots coordinates
    
[SURF,SPOTS]=CoordinatesFun(Input,NO_FILES);

%% Determine Tail Length

TAIL_LENGTH=Tail_lengthFun(Input,SURF,NO_FILES);

%% Determine Synapse (direct and with erosion)

[SURFHR,SYNAPSEHR,SURFHR_ER,SYNAPSEHR_ER]=Synapse_findFun(SURF,NO_FILES,FACTOR,THRESH_DIST);

%% Determine Synapse area (direct and with erosion)
%AREA{i,1}: eroded Synapse 1
%AREA{i,2}: eroded Synapse 2
%AREA{i,3}: non-eroded Synapse 1
%AREA{i,3}: non-eroded Synapse 2

AREA=Synapse_AreaFun(SYNAPSEHR, SYNAPSEHR_ER,SURFHR,SURFHR_ER,NO_FILES);


%% Determine Volume between Synapses
%VOL_BOUND{i,1}: eroded Synapse %ALT captures enclosed volume better 
%VOL_BOUND{i,2}: non-eroded Synapse

VOL_BOUND=VOL_BOUND_Fun(SYNAPSEHR_ER,SYNAPSEHR,NO_FILES); 

%% Determine Dextran signal in central point between Synapses

DEXTRAN_INT=DET_DEXTR_Fun(SYNAPSEHR_ER,NO_FILES,DEX_RADIUS,Input,SURF,VOL_BOUND);

%% Determine curvature of low-res surface and map to high res surface
% OPTION: Determine curvature of high-res surface (not recommended)

[CMean,CGauss,CMeanHR,CGaussHR,CMean_Map,CMean_ER_Map]=Curvature_detFun(SURF,NO_FILES,SURFHR,SYNAPSEHR,SYNAPSEHR_ER,SWITCH_HR);

%% Determine distances of spots to T Cell Synapse (all, negative curvature)

DIST_SPOTS=DIST_DET_Fun(SYNAPSEHR,SYNAPSEHR_ER, SPOTS,CMean_Map,CMean_ER_Map,NO_FILES);

%% Save result

for i=1:NO_FILES
    
FileNameSave{i}= [FileMerge{i}(1:end-23) '_Analysis_SynapseMech.mat'];

OUTPUT.TCELL_IN.VERT=SURF{i,1};

OUTPUT.TARGET_IN.VERT=SURF{i,2};
OUTPUT.TARGET_IN.INTENSITY=Input{i}.DataOut.Target{1,10};

if ~isnan(Input{i}.DataOut.Target{1,11})
OUTPUT.TARGET_IN.PI_INTENSITY = Input{i}.DataOut.Target{1,11};
else
  OUTPUT.TARGET_IN.PI_INTENSITY = NaN;
end

OUTPUT.TCELL_OUT.TAIL=TAIL_LENGTH{i};

OUTPUT.TCELL_OUT.CMEAN=CMean{i,1};
OUTPUT.TCELL_OUT.CGAUSS=CGauss{i,1};

OUTPUT.TCELL_OUT.SURFHR=SURFHR{i,1};
OUTPUT.TCELL_OUT.SURFHR_ER=SURFHR_ER{i,1};

switch SWITCH_HR 
    case 'on'
OUTPUT.TCELL_OUT.SURFHR.CMEAN_HR=CMeanHR{i,1};
OUTPUT.TCELL_OUT.SURFHR.CGAUSS_HR=CGaussHR{i,1};
    case 'off'
     OUTPUT.TCELL_OUT.SURFHR.CMEAN_HR=[];
OUTPUT.TCELL_OUT.SURFHR.CGAUSS_HR=[];
end

OUTPUT.TCELL_OUT.SYNAPSEHR=SYNAPSEHR{i,1};
OUTPUT.TCELL_OUT.SYNAPSEHR_ER=SYNAPSEHR_ER{i,1};

OUTPUT.TCELL_OUT.SYNAPSEHR.AREA=AREA{i,3};
OUTPUT.TCELL_OUT.SYNAPSEHR_ER.AREA=AREA{i,1};



OUTPUT.TCELL_OUT.SYNAPSEHR.CMEAN_HR=CMean_Map{i,1};
OUTPUT.TCELL_OUT.SYNAPSEHR_ER.CMEAN_HR_ER=CMean_ER_Map{i,1};


OUTPUT.TARGET_OUT.CMEAN=CMean{i,2};
OUTPUT.TARGET_OUT.CGAUSS=CGauss{i,2};

OUTPUT.TARGET_OUT.SURFHR=SURFHR{i,2};
OUTPUT.TARGET_OUT.SURFHR_ER=SURFHR_ER{i,2};

switch SWITCH_HR 
    case 'on'
OUTPUT.TARGET_OUT.SURFHR.CMEAN_HR=CMeanHR{i,2};
OUTPUT.TARGET_OUT.SURFHR.CGAUSS_HR=CGaussHR{i,2};
   case 'off'
     OUTPUT.TARGET_OUT.SURFHR.CMEAN_HR=[];
OUTPUT.TARGET_OUT.SURFHR.CGAUSS_HR=[];
end



OUTPUT.TARGET_OUT.SYNAPSEHR=SYNAPSEHR{i,2};
OUTPUT.TARGET_OUT.SYNAPSEHR_ER=SYNAPSEHR_ER{i,2};

OUTPUT.TARGET_OUT.SYNAPSEHR_ER.AREA_ER=AREA{i,2};
OUTPUT.TARGET_OUT.SYNAPSEHR.AREA=AREA{i,4};


OUTPUT.TARGET_OUT.SYNAPSEHR.CMEAN_HR=CMean_Map{i,2};
OUTPUT.TARGET_OUT.SYNAPSEHR_ER.CMEAN_HR_ER=CMean_ER_Map{i,2};


OUTPUT.VOLUME.SYNAPSEHR_ER=VOL_BOUND{i,1};
OUTPUT.VOLUME.SYNAPSEHR=VOL_BOUND{i,2};

OUTPUT.DEXTRAN=DEXTRAN_INT{i};
OUTPUT.DIST_SPOTS=DIST_SPOTS{i};
OUTPUT.SPOTS=SPOTS{i};



save(FileNameSave{i},'OUTPUT','-v7.3')
  
end

