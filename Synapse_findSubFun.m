function [SURFHR1OUT,SURFHR2OUT,SYNAPSEHR1OUT,SYNAPSEHR2OUT]=Synapse_findSubFun(SURF1,SURF2)

for l=1:numel(SURF1.VERT)
    
INDEX2{l}=find(SURF2.TIME==SURF1.TIME(l));

if ~isempty(INDEX2{l})

%% Define HighRes Surface
x=1:size(SURF1.MASK{l},1);
y=1:size(SURF1.MASK{l},2);
z=1:size(SURF1.MASK{l},3);

CC1=bwconncomp(~SURF1.MASK{l});
   
numPixels1 = cellfun(@numel,CC1.PixelIdxList);
[biggest1,idx1] = max(numPixels1);

MASK_DUMMY1=ones(size(SURF1.MASK{l}));
MASK_DUMMY1(CC1.PixelIdxList{idx1}) = 0;

SURF1.MASK{l}=MASK_DUMMY1;

CC2=bwconncomp(~SURF2.MASK{l});
   
numPixels2 = cellfun(@numel,CC2.PixelIdxList);
[biggest2,idx2] = max(numPixels2);

MASK_DUMMY2=ones(size(SURF2.MASK{l}));
MASK_DUMMY2(CC2.PixelIdxList{idx2}) = 0;

SURF2.MASK{l}=MASK_DUMMY2;


[X,Y,Z]=meshgrid(y,x,z);

[Faces1{l},VerticesVox1{l}] = isosurface(X,Y,Z,double(SURF1.MASK{l}),0.9);
[Faces2{l},VerticesVox2{l}] = isosurface(X,Y,Z,double(SURF2.MASK{INDEX2{l}}),0.9);

VerticesVox1{l}(:,1)=VerticesVox1{l}(:,1)-1.5;
VerticesVox1{l}(:,2)=VerticesVox1{l}(:,2)-1.5;
VerticesVox1{l}(:,3)=VerticesVox1{l}(:,3)-1.5;

VerticesVox2{l}(:,1)=VerticesVox2{l}(:,1)-1.5;
VerticesVox2{l}(:,2)=VerticesVox2{l}(:,2)-1.5;
VerticesVox2{l}(:,3)=VerticesVox2{l}(:,3)-1.5;



Vertices1{l}(:,1)=VerticesVox1{l}(:,2).*SURF1.RESMASK(1,1); % Vertices High res surface 1
Vertices1{l}(:,2)=VerticesVox1{l}(:,1).*SURF1.RESMASK(1,2); % Vertices High res surface 1
Vertices1{l}(:,3)=VerticesVox1{l}(:,3).*SURF1.RESMASK(1,3); % Vertices High res surface 1

Vertices2{l}(:,1)=VerticesVox2{l}(:,2).*SURF2.RESMASK(1,1); % Vertices High res surface 2
Vertices2{l}(:,2)=VerticesVox2{l}(:,1).*SURF2.RESMASK(1,2); % Vertices High res surface 2
Vertices2{l}(:,3)=VerticesVox2{l}(:,3).*SURF2.RESMASK(1,3); % Vertices High res surface 2

SURFHR1.VERT{l}=Vertices1{l};
SURFHR1.FACES{l}=Faces1{l};
SURFHR2.VERT{l}=Vertices2{l};
SURFHR2.FACES{l}=Faces2{l};


%% Define Synapse

Vert1_mask_IND{l}=find(SURF1.MASK{l}==1); %find 1s
Vert2_mask_IND{l}=find(SURF2.MASK{l}==1); %find 1s

[Vert1_mask_VOX{l}(:,1),Vert1_mask_VOX{l}(:,2),Vert1_mask_VOX{l}(:,3)]=ind2sub(size(SURF1.MASK{l}), Vert1_mask_IND{l});% find Voxels
[Vert2_mask_VOX{l}(:,1),Vert2_mask_VOX{l}(:,2),Vert2_mask_VOX{l}(:,3)]=ind2sub(size(SURF2.MASK{l}), Vert2_mask_IND{l});% find Voxels

Vert1_mask_Pos{l}(:,1)=Vert1_mask_VOX{l}(:,1).*SURF1.RESMASK(1,1); % Vertices High res mask 1
Vert1_mask_Pos{l}(:,2)=Vert1_mask_VOX{l}(:,2).*SURF1.RESMASK(1,2); % Vertices High res mask 1
Vert1_mask_Pos{l}(:,3)=Vert1_mask_VOX{l}(:,3).*SURF1.RESMASK(1,3); % Vertices High res mask 1

Vert2_mask_Pos{l}(:,1)=Vert2_mask_VOX{l}(:,1).*SURF2.RESMASK(1,1); % Vertices High res mask 2
Vert2_mask_Pos{l}(:,2)=Vert2_mask_VOX{l}(:,2).*SURF2.RESMASK(1,2); % Vertices High res mask 2
Vert2_mask_Pos{l}(:,3)=Vert2_mask_VOX{l}(:,3).*SURF2.RESMASK(1,3); % Vertices High res mask 2
 
LIM=sqrt(SURF1.RESMASK(1,1)^2+SURF1.RESMASK(1,2)^2+SURF1.RESMASK(1,3)^2);

idx1_Syn1{l} = rangesearch(Vert2_mask_Pos{l},Vertices1{l},LIM);


idxcount1_Syn1{l}=find(~cellfun(@isempty,idx1_Syn1{l}));


idx2_Syn2{l} = rangesearch(Vert1_mask_Pos{l},Vertices2{l},LIM);

idxcount2_Syn2{l}=find(~cellfun(@isempty,idx2_Syn2{l}));

if ~isempty(idxcount1_Syn1{l})&~isempty(idxcount2_Syn2{l})


SYNAPSEHR1.VERT{l}=Vertices1{l}(idxcount1_Syn1{l},:); % Vertices High res Synapse 1
SYNAPSEHR2.VERT{l}=Vertices2{l}(idxcount2_Syn2{l},:); % Vertices High res Synapse 2
SYNAPSEHR1.VERT_ID{l}=idxcount1_Syn1{l};
SYNAPSEHR2.VERT_ID{l}=idxcount2_Syn2{l};

[ID1{l},D1{l}]=knnsearch(SYNAPSEHR2.VERT{l},SYNAPSEHR1.VERT{l}); 
[ID2{l},D2{l}]=knnsearch(SYNAPSEHR1.VERT{l},SYNAPSEHR2.VERT{l}); 

SYNAPSEHR1.DISTANCES{l}=D1{l};
SYNAPSEHR2.DISTANCES{l}=D2{l};


else
    
SYNAPSEHR1.VERT{l}=double.empty(0,3);
SYNAPSEHR2.VERT{l}=double.empty(0,3);
SYNAPSEHR1.VERT_ID{l}=[];
SYNAPSEHR2.VERT_ID{l}=[];

SYNAPSEHR1.DISTANCES{l}=[];
SYNAPSEHR2.DISTANCES{l}=[];
    
end

else
    
SURFHR1.VERT{l}=double.empty(0,3);
SURFHR2.VERT{l}=double.empty(0,3);
SURFHR1.FACES{l}=double.empty(0,3);
SURFHR2.FACES{l}=double.empty(0,3);


SYNAPSEHR1.VERT{l}=double.empty(0,3);
SYNAPSEHR2.VERT{l}=double.empty(0,3);
SYNAPSEHR1.VERT_ID{l}=[];
SYNAPSEHR2.VERT_ID{l}=[];
SYNAPSEHR1.DISTANCES{l}=[];
SYNAPSEHR2.DISTANCES{l}=[];
end

end

SURFHR1OUT=SURFHR1;
SURFHR2OUT=SURFHR2;

SYNAPSEHR1OUT=SYNAPSEHR1;
SYNAPSEHR2OUT=SYNAPSEHR2;
end
