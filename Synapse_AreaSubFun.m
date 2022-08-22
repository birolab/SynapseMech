function OUTPUT=Synapse_AreaSubFun(SYNAPSE_IN,SURF_IN)

for l=1:numel(SYNAPSE_IN.VERT)
    
    if ~isempty(SYNAPSE_IN.VERT_ID{l})

    
    OVERLAP{l}=ismember(SURF_IN.FACES{l},SYNAPSE_IN.VERT_ID{l});
    
    idx{l} = any(OVERLAP{l}==1,2);
    
    INDEX{l}=find(idx{l});
    
    SYNAPSE_FACES{l}=SURF_IN.FACES{l}(INDEX{l},:,:);
    
    SYNAPSE_FACES{l}=unique(sort(SYNAPSE_FACES{l},2),'rows'); %check for (permutated) duplicates and remove them
    
    
    MAT_VERT=zeros(size(SYNAPSE_FACES{l},1),9);
    
    MAT_VERT(:,1:3)=SURF_IN.VERT{l}(SYNAPSE_FACES{l}(:,1),:);
    MAT_VERT(:,4:6)=SURF_IN.VERT{l}(SYNAPSE_FACES{l}(:,2),:);
    MAT_VERT(:,7:9)=SURF_IN.VERT{l}(SYNAPSE_FACES{l}(:,3),:);
    
    MAT_EDGE1=MAT_VERT(:,4:6)-MAT_VERT(:,1:3);
    MAT_EDGE2=MAT_VERT(:,7:9)-MAT_VERT(:,1:3);
    
    MAT_CROSS=cross(MAT_EDGE1,MAT_EDGE2);
    
    MAT_AREA=0.5*sqrt(dot(MAT_CROSS,MAT_CROSS,2));
    
    AREA{l}=sum(MAT_AREA);
    
    clear MAT_CROSS MAT_AREA MAT_VERT
    
    else
     AREA{l}=[];
    end

OUTPUT.AREA=AREA;
end