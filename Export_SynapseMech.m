%
%   Export_SynapseMech: Exports Surface and Spot coordinates and save as
%   *.mat-file
% 
%   Copyright Daryan Kempe, 2018-2022, UNSW Sydney
%   Last Update: 2020-11-30 (MT export included)
%   Last Update: 2020-12-01 (Target intensity export included)
%  Installation:
%
%  - Copy this file into the XTensions folder in the Imaris installation directory
%  - You will find this function in the Image Processing menu
%
%    <CustomTools>
%      <Menu>
%       <Submenu name=" Export_SynapseMech">
%        <Item name=" Export_SynapseMech" icon="Matlab" tooltip="Export Surfaces and Spots into *.mat-file.">
%          <Command>MatlabXT:: Export_SynapseMech(%i)</Command>
%        </Item>
%       </Submenu>
%      </Menu>
%
%      <SurpassTab>
%        <SurpassComponent name="bpSurfaces">
%          <Item name=" Export_SynapseMech" icon="Matlab" tooltip="Export Surfaces and Spots into *.mat-file.">
%            <Command>MatlabXT:: Export_SynapseMech(%i)</Command>
%          </Item>
%        </SurpassComponent>
%      </SurpassTab>
%     </CustomTools>

%
%
%  Description:
%
%   Exports Surfaces and Spots Coordinates from Imaris. Output saved as
%   *.mat-file
%


function  Export_SynapseMech(aImarisApplicationID)

%% connect to Imaris interface


if ~isa(aImarisApplicationID, 'Imaris.IApplicationPrxHelper')
    javaaddpath ImarisLib.jar % This file can either be called for access from working directory or from inside the application directory:
    %                                     such as Applications/Imaris8.1.2.app/Contents/SharedSupport/XT/matlab/ImarisLib.jar
    vImarisLib = ImarisLib;
    if ischar(aImarisApplicationID)
        aImarisApplicationID = round(str2double(aImarisApplicationID));
    end
    vImarisApplication = vImarisLib.GetApplication(aImarisApplicationID);
else
    vImarisApplication = aImarisApplicationID;
end

try
    vFactory = vImarisApplication.GetFactory;
catch ConnectError
    msgbox('MATLAB failed to connect to Imaris. Please restart MATLAB and Imaris and try again!', 'MATLAB Connection Error', 'error');
    return;
end

vDataSet = vImarisApplication.GetDataSet;

vSurpassScene = vImarisApplication.GetSurpassScene;

vFileName=vImarisApplication.GetCurrentFileName;

% the user has to create a scene
if isempty(vSurpassScene)
    msgbox('This XTension requires a Surpass Scene!', 'Surpass Scene Error', 'error');
    return;
end


%% Data dimensions
DataC = vDataSet.GetSizeC;
DataT = vDataSet.GetSizeT;
DataX = vDataSet.GetSizeX;
DataMinX = vDataSet.GetExtendMinX(); DataMaxX = vDataSet.GetExtendMaxX();
DataY = vDataSet.GetSizeY;
DataMinY = vDataSet.GetExtendMinY(); DataMaxY = vDataSet.GetExtendMaxY();
DataZ = vDataSet.GetSizeZ;
DataMinZ = vDataSet.GetExtendMinZ(); DataMaxZ = vDataSet.GetExtendMaxZ();
DataVoxelX = (DataMaxX-DataMinX)/DataX;
DataVoxelY = (DataMaxY-DataMinY)/DataY;
DataVoxelZ = (DataMaxZ-DataMinZ)/DataZ;
DataBitDepth = vDataSet.GetType; % can do: strcmp(DataBitDepth, 'eTypeUInt8') or strcmp(DataBitDepth, 'eTypeUInt16')
DataUnit = vDataSet.GetUnit; % can do: strcmp(DataUnit, 'um')

for m=0:DataC-1

        ChannelName=string(vImarisApplication.GetDataSet.GetChannelName(m));
        
        switch ChannelName
            
            case 'Lifeact'
                
                Lifeact_Channel=m;
        
      
            case 'Cytoplasm'
           
        
                Cytoplasm_Channel=m;
        
       
            case 'Target'
           
        
                Target_Channel=m;
        
       
            case 'PI'
           

                PI_Channel=m;
                
                
                case 'Microtubules'
                    
             MT_Channel=m;
                
            case 'Dextran'
                
                Dextran_Channel=m;
                
                for k=1:DataT
                
                DataOut.DextranInt{k}=uint16(vImarisApplication.GetDataSet.GetDataVolumeFloats(Dextran_Channel,k-1));
                end
 
        end

end


%% Get Surpass Tree structure and items
if vFactory.IsDataContainer(vSurpassScene) % if there is a top level Surpass Scene
    NrSurpassItems = vSurpassScene.GetNumberOfChildren; % Get number of Surpass Scene items
    
    SurpassTree = cell(NrSurpassItems, 2); % create cell array to hold all Surpass Scene items (col 1: name, col 2: type from GetSurpassItemType)
    
    for n = 0: NrSurpassItems - 1
        SurpassTree{n+1,1} = char(vSurpassScene.GetChild(n).GetName);
        SurpassTree{n+1,2} = GetSurpassItemType(vSurpassScene.GetChild(n), vFactory);
    end
    clear n;
end
clear NrSurpassItems;


%% Surface T cell and target cell %%
% object in the Surpass tree to work with
SurfaceSurpassItemsIndex = find([SurpassTree{:,2}]'== 9 );

if length(SurfaceSurpassItemsIndex)<1
 msgbox('You have to create at least one surface', 'Export', 'error');
else

for n=1:numel(SurfaceSurpassItemsIndex)

switch SurpassTree{SurfaceSurpassItemsIndex(n),1}
    
    case 'Lifeact'
           Lifeact_Sel= vSurpassScene.GetChild(SurfaceSurpassItemsIndex(n)-1);
           Lifeact=vImarisApplication.GetFactory.ToSurfaces(Lifeact_Sel);
           LifeactNrSurfaces=Lifeact.GetNumberOfSurfaces;
           Lifeact.SetSelectedIndices(0:LifeactNrSurfaces-1);
           LifeactTrackIDs = Lifeact.GetTrackIds;
           LifeactTrackEdges = Lifeact.GetTrackEdges;
           LifeactNrTracks = numel(unique(LifeactTrackIDs));
           LifeactSelSurf = Lifeact.GetSelectedIndices;
           
    case 'Cytoplasm'
         Cytoplasm_Sel= vSurpassScene.GetChild(SurfaceSurpassItemsIndex(n)-1);
         Cytoplasm=vImarisApplication.GetFactory.ToSurfaces(Cytoplasm_Sel);
         CytoplasmNrSurfaces=Cytoplasm.GetNumberOfSurfaces;
         Cytoplasm.SetSelectedIndices(0:CytoplasmNrSurfaces-1);
         CytoplasmTrackIDs = Cytoplasm.GetTrackIds;
         CytoplasmTrackEdges = Cytoplasm.GetTrackEdges;
         CytoplasmNrTracks = numel(unique(CytoplasmTrackIDs));
         CytoplasmSelSurf = Cytoplasm.GetSelectedIndices;
         
         
         
         
         case 'Microtubules'
           MT_Sel= vSurpassScene.GetChild(SurfaceSurpassItemsIndex(n)-1);
           MT=vImarisApplication.GetFactory.ToSurfaces(MT_Sel);
           MTNrSurfaces=MT.GetNumberOfSurfaces;
           MT.SetSelectedIndices(0:MTNrSurfaces-1);
           MTTrackIDs = MT.GetTrackIds;
           MTTrackEdges = MT.GetTrackEdges;
           MTNrTracks = numel(unique(MTTrackIDs));
           MTSelSurf = MT.GetSelectedIndices;

         
    case 'Target'
         Target_Sel= vSurpassScene.GetChild(SurfaceSurpassItemsIndex(n)-1);
         Target=vImarisApplication.GetFactory.ToSurfaces(Target_Sel);
         TargetNrSurfaces=Target.GetNumberOfSurfaces;
         Target.SetSelectedIndices(0:TargetNrSurfaces-1);
         TargetTrackIDs = Target.GetTrackIds;
         TargetTrackEdges = Target.GetTrackEdges;
         TargetNrTracks = numel(unique(TargetTrackIDs));
         TargetSelSurf = Target.GetSelectedIndices;
         
         TargetIDs=Target.GetIds;
         TargetStatsAll = Target.GetStatistics;
         TargetStats =cell(TargetStatsAll.mNames); 
         TargetStats(:,2)=num2cell(TargetStatsAll.mValues);
         TargetStats(:,3)=num2cell(TargetStatsAll.mIds);
         
        %INDALL_Target=strfind(TargetStats(:,1),'Intensity Sum');
        IND_Target=find(contains(cell(TargetStatsAll.mNames),'Intensity Sum')); 
        %IND_Target=find(not(cellfun('isempty',INDALL_Target)));
         IntensityValAll_Target=TargetStats(IND_Target,2);
         IntensityIDsAll_Target=TargetStats(IND_Target,3);

  
          INDEX_SEL_Target=Target_Channel+1:(DataC):(DataC*TargetNrSurfaces);
   
         IntensitySum_Target=IntensityValAll_Target(INDEX_SEL_Target);
         
         Test=exist('PI_Channel');
         
         if Test~=0
  
         INDEX_SEL_PI=PI_Channel+(1:(DataC):DataC*TargetNrSurfaces);


         IntensitySum_PI=IntensityValAll_Target(INDEX_SEL_PI);
         else
            IntensitySum_PI={NaN};
         end
          
         
    case 'PI'
        PI_Sel=vSurpassScene.GetChild(SurfaceSurpassItemsIndex(n)-1);
        PI=vImarisApplication.GetFactory.ToSurfaces(PI_Sel);
        PINrSurfaces=PI.GetNumberOfSurfaces;
        PI.SetSelectedIndices(0:PINrSurfaces-1);
        PITrackIDs = PI.GetTrackIds;
        PITrackEdges =PI.GetTrackEdges;
        PINrTracks = numel(unique(PITrackIDs));
        PISelSurf = PI.GetSelectedIndices;
        
        
        
        
        
   case 'Granules'
       
        Granules_Sel=vSurpassScene.GetChild(SurfaceSurpassItemsIndex(n)-1);
        Granules=vImarisApplication.GetFactory.ToSurfaces(Granules_Sel);
        GranulesNrSurfaces=Granules.GetNumberOfSurfaces;
        Granules.SetSelectedIndices(0:GranulesNrSurfaces-1);
        GranulesTrackIDs = Granules.GetTrackIds;
        GranulesTrackEdges =Granules.GetTrackEdges;
        GranulesNrTracks = numel(unique(GranulesTrackIDs));
        GranulesSelSurf = Granules.GetSelectedIndices;
        
        
    otherwise
        msgbox('Surface name error! Options are: Lifeact, Cytoplasm, Target, PI', 'Export', 'error'); 
end
             
end
end
%              
MaskSamplingX=3;
MaskSamplingY=3;
MaskSamplingZ=7.5;



aSizeX=MaskSamplingX*DataX; %increase surface mask sampling by factor MaskSamplingX
aSizeY=MaskSamplingY*DataY; %increase surface mask sampling by factor MaskSamplingY
aSizeZ=MaskSamplingZ*DataZ; %increase surface mask sampling by factor MaskSamplingZ

DataOut.Lifeact=[];
DataOut.Cytoplasm=[];
DataOut.Target=[];
DataOut.Microtubules=[];
DataOut.PI=[];
DataOut.Granules=[];
DataOut.SpotsPipetteTip=[];
DataOut.SpotsGranules=[];
DataOut.SpotsPipetteTip2=[];


if exist('LifeactSelSurf')
    
for k=1:length(LifeactSelSurf)
DataOut.Lifeact{k,1} = double(Lifeact.GetVertices(LifeactSelSurf(k)));
DataOut.Lifeact{k,2}=double(LifeactSelSurf(k,1));
DataOut.Lifeact{k,3}=double(Lifeact.GetTimeIndex(LifeactSelSurf(k)));
DataOut.Lifeact{k,4}=double(Lifeact.GetTriangles(LifeactSelSurf(k)));
Lifeact_MASK= Lifeact.GetMask(DataMinX, DataMinY, DataMinZ, DataMaxX, DataMaxY, DataMaxZ, aSizeX,aSizeY,aSizeZ, Lifeact.GetTimeIndex(LifeactSelSurf(k)));
Lifeact_MASK.SetType(Imaris.tType.eTypeUInt8);
DataOut.Lifeact{k,5} = Lifeact_MASK.GetDataVolumeBytes(0, 0);
DataOut.Lifeact{k,6}=double([DataVoxelX,DataVoxelY,DataVoxelZ]);
DataOut.Lifeact{k,7}=double([DataMinX,DataMinY,DataMinZ]);
DataOut.Lifeact{k,8}=double(Lifeact.GetNormals(LifeactSelSurf(k)));
DataOut.Lifeact{k,9}=double([MaskSamplingX,MaskSamplingY,MaskSamplingZ]);
DataOut.Lifeact{k,10}=uint16(vImarisApplication.GetDataSet.GetDataVolumeFloats(Lifeact_Channel,k-1)); 
end
else
end

if exist('CytoplasmSelSurf')
    
for k=1:length(CytoplasmSelSurf)
DataOut.Cytoplasm{k,1} = double(Cytoplasm.GetVertices(CytoplasmSelSurf(k)));
DataOut.Cytoplasm{k,2}=double(CytoplasmSelSurf(k,1));
DataOut.Cytoplasm{k,3}=double(Cytoplasm.GetTimeIndex(CytoplasmSelSurf(k)));
DataOut.Cytoplasm{k,4}=double(Cytoplasm.GetTriangles(CytoplasmSelSurf(k)));
Cytoplasm_MASK= Cytoplasm.GetMask(DataMinX, DataMinY, DataMinZ, DataMaxX, DataMaxY, DataMaxZ, aSizeX,aSizeY,aSizeZ, Cytoplasm.GetTimeIndex(CytoplasmSelSurf(k)));
Cytoplasm_MASK.SetType(Imaris.tType.eTypeUInt8);
DataOut.Cytoplasm{k,5} = Cytoplasm_MASK.GetDataVolumeBytes(0, 0);
DataOut.Cytoplasm{k,6}=double([DataVoxelX,DataVoxelY,DataVoxelZ]);
DataOut.Cytoplasm{k,7}=double([DataMinX,DataMinY,DataMinZ]);
DataOut.Cytoplasm{k,8}=double(Cytoplasm.GetNormals(CytoplasmSelSurf(k)));
DataOut.Cytoplasm{k,9}=double([MaskSamplingX,MaskSamplingY,MaskSamplingZ]);
 
end
else
end


if exist('MTSelSurf')
    
for k=1:length(MTSelSurf)
DataOut.MT{k,1} = double(MT.GetVertices(MTSelSurf(k)));
DataOut.MT{k,2}=double(MTSelSurf(k,1));
DataOut.MT{k,3}=double(MT.GetTimeIndex(MTSelSurf(k)));
DataOut.MT{k,4}=double(MT.GetTriangles(MTSelSurf(k)));
MT_MASK= MT.GetMask(DataMinX, DataMinY, DataMinZ, DataMaxX, DataMaxY, DataMaxZ, aSizeX,aSizeY,aSizeZ, MT.GetTimeIndex(MTSelSurf(k)));
MT_MASK.SetType(Imaris.tType.eTypeUInt8);
DataOut.MT{k,5} = MT_MASK.GetDataVolumeBytes(0, 0);
DataOut.MT{k,6}=double([DataVoxelX,DataVoxelY,DataVoxelZ]);
DataOut.MT{k,7}=double([DataMinX,DataMinY,DataMinZ]);
DataOut.MT{k,8}=double(MT.GetNormals(MTSelSurf(k)));
DataOut.MT{k,9}=double([MaskSamplingX,MaskSamplingY,MaskSamplingZ]);
DataOut.MT{k,10}=uint16(vImarisApplication.GetDataSet.GetDataVolumeFloats(MT_Channel,k-1)); 
end
else
end






if exist('TargetSelSurf')
    
for k=1:length(TargetSelSurf)
DataOut.Target{k,1} = double(Target.GetVertices(TargetSelSurf(k)));
DataOut.Target{k,2}=double(TargetSelSurf(k,1));
DataOut.Target{k,3}=double(Target.GetTimeIndex(TargetSelSurf(k)));
DataOut.Target{k,4}=double(Target.GetTriangles(TargetSelSurf(k)));
Target_MASK= Target.GetMask(DataMinX, DataMinY, DataMinZ, DataMaxX, DataMaxY, DataMaxZ, aSizeX,aSizeY,aSizeZ, Target.GetTimeIndex(TargetSelSurf(k)));
Target_MASK.SetType(Imaris.tType.eTypeUInt8);
DataOut.Target{k,5} = Target_MASK.GetDataVolumeBytes(0, 0);
DataOut.Target{k,6}=double([DataVoxelX,DataVoxelY,DataVoxelZ]);
DataOut.Target{k,7}=double([DataMinX,DataMinY,DataMinZ]);
DataOut.Target{k,8}=double(Target.GetNormals(TargetSelSurf(k)));
DataOut.Target{k,9}=double([MaskSamplingX,MaskSamplingY,MaskSamplingZ]);
DataOut.Target{k,10}=double(cell2mat(IntensitySum_Target(:)));
DataOut.Target{k,11}=double(cell2mat(IntensitySum_PI(:)));
DataOut.Target{k,12}=uint16(vImarisApplication.GetDataSet.GetDataVolumeFloats(Target_Channel,k-1)); 

end
else
end


if exist('PISelSurf')
    
for k=1:length(PISelSurf)
DataOut.PI{k,1} = double(PI.GetVertices(PISelSurf(k)));
DataOut.PI{k,2}=double(PISelSurf(k,1));
DataOut.PI{k,3}=double(PI.GetTimeIndex(PISelSurf(k)));
DataOut.PI{k,4}=double(PI.GetTriangles(PISelSurf(k)));
PI_MASK= PI.GetMask(DataMinX, DataMinY, DataMinZ, DataMaxX, DataMaxY, DataMaxZ, aSizeX,aSizeY,aSizeZ,PI.GetTimeIndex(PISelSurf(k)));
PI_MASK.SetType(Imaris.tType.eTypeUInt8);
DataOut.PI{k,5} = PI_MASK.GetDataVolumeBytes(0, 0);
DataOut.PI{k,6}=double([DataVoxelX,DataVoxelY,DataVoxelZ]);
DataOut.PI{k,7}=double([DataMinX,DataMinY,DataMinZ]);
DataOut.PI{k,8}=double(PI.GetNormals(PISelSurf(k)));
DataOut.PI{k,9}=double([MaskSamplingX,MaskSamplingY,MaskSamplingZ]);
end
else
end


if exist('GranulesSelSurf')
    
for k=1:length(GranulesSelSurf)
DataOut.Granules{k,1} = double(Granules.GetVertices(GranulesSelSurf(k)));
DataOut.Granules{k,2}=double(GranulesSelSurf(k,1));
DataOut.Granules{k,3}=double(Granules.GetTimeIndex(GranulesSelSurf(k)));
DataOut.Granules{k,4}=double(Granules.GetTriangles(GranulesSelSurf(k)));
Granules_MASK= Granules.GetMask(DataMinX, DataMinY, DataMinZ, DataMaxX, DataMaxY, DataMaxZ, aSizeX,aSizeY,aSizeZ,Granules.GetTimeIndex(GranulesSelSurf(k)));
Granules_MASK.SetType(Imaris.tType.eTypeUInt8);
DataOut.Granules{k,5} = Granules_MASK.GetDataVolumeBytes(0, 0);
DataOut.Granules{k,6}=double([DataVoxelX,DataVoxelY,DataVoxelZ]);
DataOut.Granules{k,7}=double([DataMinX,DataMinY,DataMinZ]);
DataOut.Granules{k,8}=double(Granules.GetNormals(GranulesSelSurf(k)));
DataOut.Granules{k,9}=double([MaskSamplingX,MaskSamplingY,MaskSamplingZ]);
end
else
end


%% Spots %%
% Spots object in the Surpass tree to work with
SpotsSurpassItemsIndex = find( [SurpassTree{:,2}]'== 8 );

if isempty(SpotsSurpassItemsIndex)
else

    for n=1:numel(SpotsSurpassItemsIndex)
        
        switch SurpassTree{SpotsSurpassItemsIndex(n),1}
            
            case 'PipetteTip'
    
SpotsPipetteTip = vSurpassScene.GetChild(SpotsSurpassItemsIndex(n)-1); 
vSpotsPipetteTip = vImarisApplication.GetFactory.ToSpots(SpotsPipetteTip);
SpotsPipetteTipXYZ(:,1:3) = double(vSpotsPipetteTip.GetPositionsXYZ);
SpotsPipetteTipXYZ(:,4) = double(vSpotsPipetteTip.GetIds);
SpotsPipetteTipXYZ(:,5)=double(vSpotsPipetteTip.GetIndicesT);
DataOut.SpotsPipetteTip=SpotsPipetteTipXYZ;

 case 'TailSpots'
    
SpotsTail = vSurpassScene.GetChild(SpotsSurpassItemsIndex(n)-1); 
vSpotsTail = vImarisApplication.GetFactory.ToSpots(SpotsTail);
SpotsTailOut(:,1:3) = double(vSpotsTail.GetPositionsXYZ);
SpotsTailOut(:,4)=double(vSpotsTail.GetIds);
SpotsTailOut(:,5)=double(vSpotsTail.GetIndicesT);
DataOut.SpotsTail=SpotsTailOut;


            case 'Granules'
                
 SpotsGranules = vSurpassScene.GetChild(SpotsSurpassItemsIndex(n)-1);  
 vSpotsGranules = vImarisApplication.GetFactory.ToSpots(SpotsGranules);
SpotsEdgesGranules=vSpotsGranules.GetTrackEdges;
SpotsEdgesIDGranules = vSpotsGranules.GetTrackIds;

SpotsOut(:,1:3) = double(vSpotsGranules.GetPositionsXYZ);
SpotsOut(:,4)=double(vSpotsGranules.GetIds);
SpotsOut(:,5)=double(vSpotsGranules.GetIndicesT);
SpotsOut(:,6)=double(vSpotsGranules.GetRadii);
DataOut.SpotsGranules=SpotsOut;

            case 'PipetteTip2'
     SpotsPipetteTip2 = vSurpassScene.GetChild(SpotsSurpassItemsIndex(n)-1); 
vSpotsPipetteTip2 = vImarisApplication.GetFactory.ToSpots(SpotsPipetteTip2);
SpotsPipetteTip2XYZ(:,1:3) = double(vSpotsPipetteTip2.GetPositionsXYZ);
DataOut.SpotsPipetteTip2=SpotsPipetteTip2XYZ;           
                

        end

    end
end






FileNameChar=char(vFileName);
FileNameCharShort= FileNameChar(1:end-4);
FileNameNew=[FileNameCharShort '_Export_SynapseMech.mat'];

save(FileNameNew,'DataOut','-v7.3') 


end


function CheckedSurpassItemType = GetSurpassItemType(SurpassItemToBeChecked, Factory)
% Function checks which IDataItem type SurpassItemToBeChecked is and returns a
% corresponding code value. Factory is a GetFactpry value of Imaris.
% 1 - Clipping Plane
% 2 - Data Container
% 3 - Filaments
% 4 - Frame
% 5 - Cells
% 6 - Light Source
% 7 - Measurement Points
% 8 - Spots
% 9 - Surfaces
% 10 - Volume
if Factory.IsClippingPlane(SurpassItemToBeChecked)
    CheckedSurpassItemType = 1;
elseif Factory.IsDataContainer(SurpassItemToBeChecked)
    CheckedSurpassItemType = 2;
elseif Factory.IsFilaments(SurpassItemToBeChecked)
    CheckedSurpassItemType = 3;
elseif Factory.IsFrame(SurpassItemToBeChecked)
    CheckedSurpassItemType = 4;
elseif Factory.IsCells(SurpassItemToBeChecked)
    CheckedSurpassItemType = 5;
elseif Factory.IsLightSource(SurpassItemToBeChecked)
    CheckedSurpassItemType = 6;
elseif Factory.IsMeasurementPoints(SurpassItemToBeChecked)
    CheckedSurpassItemType = 7;
elseif Factory.IsSpots(SurpassItemToBeChecked)
    CheckedSurpassItemType = 8;
elseif Factory.IsSurfaces(SurpassItemToBeChecked)
    CheckedSurpassItemType = 9;
elseif Factory.IsVolume(SurpassItemToBeChecked)
    CheckedSurpassItemType = 10;
else
    msgbox('Error: An item in the surpass scene is not of a recognised type!', 'Export Warning', 'warn');
end
end





% function NrTracks = GetNumberTracks(SurfObj, ImarisApp)
% if ~ImarisApp.GetFactory.IsSurfaces(SurfObj)
%     error('GetNumberTracks passed a non-Surfaces obiect');
% end;
% 
% edges = SurfObj.GetTrackEdges;
% NrTracks = 0;
% if isempty(edges)
%     return;
% else
%     NrTracks = 1;
%     for n=2 : size(edges,1)
%         if edges(n,1) < edges(n-1,1)
%             NrTracks = NrTracks + 1;
%         end;
%     end;
% end;


    
