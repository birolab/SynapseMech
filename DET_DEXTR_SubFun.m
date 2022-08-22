function OUTPUT=DET_DEXTR_SubFun(SYNAPSE1,SYNAPSE2,DEX_RADIUS,DEX_MAT,RES,VOL_BOUND_IN)

MAT_DUMMY=ones(size(DEX_MAT{1}));

INDEX_1=find(MAT_DUMMY==1);

[X,Y,Z]=ind2sub(size(MAT_DUMMY),INDEX_1);

SEARCH_FIELD=[X,Y,Z];

for l=1:numel(SYNAPSE1.VERT)
    
    if ~isempty(VOL_BOUND_IN.ALPHA_ALT{l}.Points)
    
tf{l} = find(inShape(VOL_BOUND_IN.ALPHA_ALT{l},X*RES(1),Y*RES(2),Z*RES(3))==1);

TARGET_IND{l}=sub2ind(size(MAT_DUMMY),X(tf{l}),Y(tf{l}),Z(tf{l}));

DEX_MAT_TARGET{l}=DEX_MAT{l}(TARGET_IND{l});

Center{l}=sum([X(tf{l}),Y(tf{l}),Z(tf{l})]./numel(X(tf{l})));

[ID1{l},D1{l}]=knnsearch(SYNAPSE1.VERT{l},Center{l}.*RES);
[ID2{l},D2{l}]=knnsearch(SYNAPSE2.VERT{l},Center{l}.*RES);

Center{l}=0.5*(SYNAPSE1.VERT{l}(ID1{l},:)+SYNAPSE2.VERT{l}(ID2{l},:));

Center_VOX{l}=round(Center{l}./RES);
 
 [idx{l}, dist{l}] = rangesearch(SEARCH_FIELD,Center_VOX{l},DEX_RADIUS);
 
 TARGET_IND_RADIUS{l}=sub2ind(size(MAT_DUMMY),SEARCH_FIELD(idx{l}{1},1),SEARCH_FIELD(idx{l}{1},2),SEARCH_FIELD(idx{l}{1},3));

 DEX_MAT_TARGET_RADIUS{l}=DEX_MAT{l}(TARGET_IND_RADIUS{l});
 DEX_MAT_MED{l}=medfilt3(DEX_MAT{l});
 DEX_MAT_TARGET_RADIUS_MED{l}=DEX_MAT_MED{l}(TARGET_IND_RADIUS{l});

 %% Define Output
OUTPUT.DEXTRAN_INT_SUM{l}=sum(sum(sum(DEX_MAT_TARGET{l})));% Intensity in Volume between Synapse areas
OUTPUT.DEXTRAN_INT_MEAN{l}=mean(mean(mean(DEX_MAT_TARGET{l})));

OUTPUT.DEXTRAN_INT_SUM_RADIUS{l}=sum(sum(sum(DEX_MAT_TARGET_RADIUS{l})));
OUTPUT.DEXTRAN_INT_MEAN_RADIUS{l}=mean(mean(mean(DEX_MAT_TARGET_RADIUS{l})));
OUTPUT.DEXTRAN_INT_MEAN_MED_RADIUS{l}=mean(mean(mean(DEX_MAT_TARGET_RADIUS_MED{l})));
OUTPUT.CENTER{l}=Center{l};

    else
        
        OUTPUT.DEXTRAN_INT_SUM{l}=[];
        OUTPUT.DEXTRAN_INT_MEAN{l}=[];
        OUTPUT.DEXTRAN_INT_SUM_RADIUS{l}=[];
        OUTPUT.DEXTRAN_INT_MEAN_RADIUS{l}=[];
        OUTPUT.CENTER{l}=double.empty(0,3);
        
        
    end

end