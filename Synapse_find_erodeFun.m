function [SURFHR1OUT,SURFHR2OUT,SYNAPSEHR1OUT,SYNAPSEHR2OUT]=Synapse_find_erodeFun(SURF1,SURF2,FACTOR,THRESH)

for l=1:numel(SURF1.VERT)
    
INDEX2{l}=find(SURF2.TIME==SURF1.TIME(l));

if ~isempty(INDEX2{l})

%% Define HighRes image

IND_ONES_1{l}=find(SURF1.MASK{l}==1);
IND_ONES_2{l}=find(SURF2.MASK{INDEX2{l}}==1);

NUM_ONES_1{l}=numel(IND_ONES_1{l});
NUM_ONES_2{l}=numel(IND_ONES_2{l});

OVERLAP_THRESH{l}=0;

x=size(SURF1.MASK{l},1);
y=size(SURF1.MASK{l},2);
z=size(SURF1.MASK{l},3);

xq=(0:FACTOR:x)';
yq=(0:FACTOR:y)';
zq=(0:FACTOR:z)';

F1=griddedInterpolant(double(SURF1.MASK{l}));
F2=griddedInterpolant(double(SURF2.MASK{INDEX2{l}}));

SURF1_INTERP.MASK{l}=uint8(F1({xq,yq,zq}));
SURF2_INTERP.MASK{l}=uint8(F2({xq,yq,zq}));

SURF1_INTERP.RESMASK=SURF1.RESMASK.*1./(size(SURF1_INTERP.MASK{l})./size(SURF1.MASK{l}));
SURF2_INTERP.RESMASK=SURF2.RESMASK.*1./(size(SURF2_INTERP.MASK{l})./size(SURF2.MASK{INDEX2{l}}));

clear F1 F2 x y z xq yq zq

SUM_MASK{l}=SURF1_INTERP.MASK{l}+SURF2_INTERP.MASK{l};

IND_OVERLAP{l}=find(SUM_MASK{l}==2);

VOLUME_OVERLAP(l)=numel(IND_OVERLAP{l});

OVERLAP{l}=numel(IND_OVERLAP{l});

COUNT{l}=0;

SE = strel('cube',3);


ERODE1_START{l}=SURF1_INTERP.MASK{l};
ERODE2_START{l}=SURF2_INTERP.MASK{l};

while OVERLAP{l}>OVERLAP_THRESH{l}

clear IND_OVERLAP{l}    
    
COUNT{l}=COUNT{l}+1;
    
ERODE1{l} = imerode(ERODE1_START{l},SE);
    
ERODE2{l} = imerode(ERODE2_START{l},SE);

clear ERODE1_START{l} ERODE2_START{l}

SUM_MASK{l}=ERODE1{l}+ERODE2{l};

IND_OVERLAP{l}=find(SUM_MASK{l}==2);

OVERLAP{l}=numel(IND_OVERLAP{l});

ERODE1_START{l}=ERODE1{l};
ERODE2_START{l}=ERODE2{l};

clear  ERODE1{l} ERODE2{l}

end

 

else
    
end
end

COUNT_MAX=median(cell2mat(COUNT(:)))+1; % common number of erosion steps

for l=1:numel(SURF1.VERT)
    
INDEX2{l}=find(SURF2.TIME==SURF1.TIME(l));

if ~isempty(INDEX2{l})

%% Erode all volumes to same amount

COUNT_NEW{l}=0;

SE = strel('cube',3);

ERODE1_START{l}=SURF1_INTERP.MASK{l};
ERODE2_START{l}=SURF2_INTERP.MASK{l};

while COUNT_NEW{l}<COUNT_MAX
    
COUNT_NEW{l}=COUNT_NEW{l}+1;   
    
ERODE1{l} = imerode(ERODE1_START{l},SE);
    
ERODE2{l} = imerode(ERODE2_START{l},SE);

clear ERODE1_START{l} ERODE2_START{l}


ERODE1_START{l}=ERODE1{l};
ERODE2_START{l}=ERODE2{l};

clear  ERODE1{l} ERODE2{l}

end

 

else
    
end
end

%% Find index of overlapping parts of Synapse

for l=1:numel(SURF1.VERT)
    
INDEX2{l}=find(SURF2.TIME==SURF1.TIME(l));

if ~isempty(INDEX2{l})

SUM_ERODE_FINAL{l}=ERODE1_START{l}+ERODE2_START{l};

INDEX_OVERLAP_FINAL{l}=find(SUM_ERODE_FINAL{l}==2);

NUM_OVERLAP_FINAL{l}=numel(INDEX_OVERLAP_FINAL{l});

INDEX_FINAL1{l}=find(ERODE1_START{l}==1);
INDEX_FINAL2{l}=find(ERODE2_START{l}==1);

INDEX_OVERLAP_FINAL1{l}=intersect(INDEX_OVERLAP_FINAL{l},INDEX_FINAL1{l});
INDEX_OVERLAP_FINAL2{l}=intersect(INDEX_OVERLAP_FINAL{l},INDEX_FINAL2{l});

[VORT1_X{l},VORT1_Y{l},VORT1_Z{l}]=ind2sub(size(ERODE1_START{l}),INDEX_OVERLAP_FINAL1{l});
[VORT2_X{l},VORT2_Y{l},VORT2_Z{l}]=ind2sub(size(ERODE2_START{l}),INDEX_OVERLAP_FINAL2{l});

VERT_OVERLAP1{l}=[VORT1_X{l},VORT1_Y{l},VORT1_Z{l}].*SURF1.RESMASK*FACTOR;
VERT_OVERLAP2{l}=[VORT2_X{l},VORT2_Y{l},VORT2_Z{l}].*SURF2.RESMASK*FACTOR;

else
    
end
end

%% Create isosurface

for l=1:numel(SURF1.VERT)
    
INDEX2{l}=find(SURF2.TIME==SURF1.TIME(l));

if ~isempty(INDEX2{l})

x=1:size(ERODE1_START{l},1);
y=1:size(ERODE1_START{l},2);
z=1:size(ERODE1_START{l},3);

[X,Y,Z]=meshgrid(y,x,z);

[Faces1{l},VerticesVox1{l}] = isosurface(X,Y,Z,double(ERODE1_START{l}),0.9);
[Faces2{l},VerticesVox2{l}] = isosurface(X,Y,Z,double(ERODE2_START{l}),0.9);

if ~isempty(VerticesVox1{l})
Vertices1{l}(:,1)=VerticesVox1{l}(:,2).*SURF1_INTERP.RESMASK(1,1); % Vertices High res surface 1
Vertices1{l}(:,2)=VerticesVox1{l}(:,1).*SURF1_INTERP.RESMASK(1,2); % Vertices High res surface 1
Vertices1{l}(:,3)=VerticesVox1{l}(:,3).*SURF1_INTERP.RESMASK(1,3); % Vertices High res surface 1


else
Vertices1{l}=[NaN NaN NaN];
Faces1{l}=[NaN NaN NaN];
end

if ~isempty(VerticesVox2{l})
    
Vertices2{l}(:,1)=VerticesVox2{l}(:,2).*SURF2_INTERP.RESMASK(1,1); % Vertices High res surface 2
Vertices2{l}(:,2)=VerticesVox2{l}(:,1).*SURF2_INTERP.RESMASK(1,2); % Vertices High res surface 2
Vertices2{l}(:,3)=VerticesVox2{l}(:,3).*SURF2_INTERP.RESMASK(1,3); % Vertices High res surface 2


else
Vertices2{l}=[NaN NaN NaN];  
Faces2{l}=[NaN NaN NaN];
end

SURFHR1OUT.VERT{l}=Vertices1{l};
SURFHR1OUT.FACES{l}=Faces1{l};
SURFHR2OUT.VERT{l}=Vertices2{l};
SURFHR2OUT.FACES{l}=Faces2{l};


else
    
    SURFHR1OUT.VERT{l}=[];
    
SURFHR1OUT.FACES{l}=[];
SURFHR2OUT.VERT{l}=[];
SURFHR2OUT.FACES{l}=[];
    
    
end

end

%% Find Synapse

for l=1:numel(SURF1.VERT)
    
INDEX2{l}=find(SURF2.TIME==SURF1.TIME(l));

if ~isempty(INDEX2{l})
    
  [ID1{l},D1{l}]=knnsearch(Vertices2{l},Vertices1{l}); 
  [ID2{l},D2{l}]=knnsearch(Vertices1{l},Vertices2{l}); 
  
  [ID_OV1{l},DOV1{l}]=knnsearch(Vertices1{l},VERT_OVERLAP1{l});
  [ID_OV2{l},DOV2{l}]=knnsearch(Vertices2{l},VERT_OVERLAP2{l});
   
   D1{l}(ID_OV1{l})=0;
   D2{l}(ID_OV2{l})=0;
   
  
  IND_COARSE1{l}=find(D1{l}<THRESH&D1{l}>0.02);
  IND_COARSE2{l}=find(D2{l}<THRESH&D2{l}>0.02);
  
  D1_COARSE{l}=D1{l}(IND_COARSE1{l});
  D2_COARSE{l}=D2{l}(IND_COARSE2{l});
  
%   
% [Hist1{l},Bin1{l}]=hist(D1_COARSE{l}(:),50);
% [Hist2{l},Bin2{l}]=hist(D2_COARSE{l}(:),50);  
% 
% Hist1{l}=Hist1{l}./sum(Hist1{l});
% Hist2{l}=Hist2{l}./sum(Hist2{l});
% 
% Hist1{l}=smooth(Hist1{l},10);
% Hist2{l}=smooth(Hist2{l},10);
% 
% [MaxY1{l},MaxX1{l}]=max(Hist1{l});
% [MaxY2{l},MaxX2{l}]=max(Hist2{l});
% 
% [MinY1{l},MinX1{l}]=min(Hist1{l});
% [MinY2{l},MinX2{l}]=min(Hist2{l});
% 
% THRESH_MAX1{l}=Bin1{l}(MaxX1{l});
% THRESH_MAX2{l}=Bin2{l}(MaxX2{l});
% 
% THRESH_MIN1{l}=Bin1{l}(MinX1{l});
% THRESH_MIN2{l}=Bin2{l}(MinX2{l});
% 
% THRESH_MIN1_ALT{l}=THRESH_MAX1{l}+0.25;
% THRESH_MIN2_ALT{l}=THRESH_MAX2{l}+0.25;


THRESH_MIN1_ALT{l}=median(D1_COARSE{l})+0.2;
THRESH_MIN2_ALT{l}=median(D2_COARSE{l})+0.2;

THRESH_MIN{l}=mean([THRESH_MIN1_ALT{l} THRESH_MIN2_ALT{l}]); % common threshold

ID_SYN1{l}=find(D1{l}<THRESH_MIN{l});
ID_SYN2{l}=find(D2{l}<THRESH_MIN{l});

ID_SYN2_ALT{l}=ID1{l}(ID_SYN1{l}); %selection via T cell only

AREA1{l}=numel(ID_SYN1{l});
AREA2{l}=numel(ID_SYN2{l});


% Define histograms

IND_COARSE1_H{l}=find(D1{l}<THRESH);
IND_COARSE2_H{l}=find(D2{l}<THRESH);
  
D1_COARSE_H{l}=D1{l}(IND_COARSE1_H{l});
D2_COARSE_H{l}=D2{l}(IND_COARSE2_H{l});
  
[Hist1_H{l},Bin1_H{l}]=hist(D1_COARSE_H{l}(:),50);
[Hist2_H{l},Bin2_H{l}]=hist(D2_COARSE_H{l}(:),50);  

Hist1_H{l}=Hist1_H{l}./sum(Hist1_H{l});
Hist2_H{l}=Hist2_H{l}./sum(Hist2_H{l});

Hist1_H{l}=smooth(Hist1_H{l},10);
Hist2_H{l}=smooth(Hist2_H{l},10);

MAT_HIST1_H(l,:)=Hist1_H{l};
MAT_HIST2_H(l,:)=Hist2_H{l};

SYNAPSEHR1OUT.VERT{l}=Vertices1{l}(ID_SYN1{l},:);
SYNAPSEHR2OUT.VERT{l}=Vertices2{l}(ID_SYN2{l},:);
SYNAPSEHR2OUT.VERT_ALT{l}=Vertices2{l}(ID_SYN2_ALT{l},:);

SYNAPSEHR1OUT.VERT_ID{l}=ID_SYN1{l};
SYNAPSEHR2OUT.VERT_ID{l}=ID_SYN2{l};
SYNAPSEHR2OUT.VERT_ALT_ID{l}=ID_SYN2_ALT{l};

SYNAPSEHR1OUT.DISTANCES{l}=D1{l}(ID_SYN1{l});
SYNAPSEHR2OUT.DISTANCES{l}=D2{l}(ID_SYN2{l});
SYNAPSEHR1OUT.VERT_OVERLAP{l}=VERT_OVERLAP1{l};
SYNAPSEHR2OUT.VERT_OVERLAP{l}=VERT_OVERLAP2{l};


SYNAPSEHR1OUT.VOL_OVERLAP(l)=VOLUME_OVERLAP(l);

SYNAPSEHR1OUT.DIST_HIST{l}=MAT_HIST1_H;
SYNAPSEHR2OUT.DIST_HIST{l}=MAT_HIST2_H;
SYNAPSEHR1OUT.NOPOINTS{l}=AREA1{l};

clear MAT_HIST1_H MAT_HIST1_H


else
    
 
SYNAPSEHR1OUT.VERT{l}=double.empty(1,0);
SYNAPSEHR2OUT.VERT{l}=double.empty(1,0);
SYNAPSEHR1OUT.DISTANCES{l}=double.empty(1,0);
SYNAPSEHR2OUT.DISTANCES{l}=double.empty(1,0);
SYNAPSEHR1OUT.VERT_OVERLAP{l}=double.empty(1,0);
SYNAPSEHR2OUT.VERT_OVERLAP{l}=double.empty(1,0);

SYNAPSEHR1OUT.DIST_HIST{l}=double.empty(1,0);
SYNAPSEHR2OUT.DIST_HIST{l}=double.empty(1,0) ;  
  SYNAPSEHR1OUT.VERT_ID{l}=double.empty(1,0);
SYNAPSEHR2OUT.VERT_ID{l}=double.empty(1,0);
SYNAPSEHR2OUT.VERT_ALT_ID{l}=double.empty(1,0);
SYNAPSEHR1OUT.VOL_OVERLAP(l)=NaN;
    
    
    
end

end




end
