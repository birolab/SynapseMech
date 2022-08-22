clear all

%Test_Shrink
[filename, pathname]=uigetfile('*.ply', 'Exported surface mesh');

fileload=[pathname filename];

[TRI,PTS] = plyread(fileload,'tri');

PTS=PTS;

FV.vertices=PTS;
FV.faces=TRI;

TR=triangulation(FV.faces,FV.vertices(:,1),FV.vertices(:,2),FV.vertices(:,3));

FV2.vertices=zeros(size(PTS));
FV2.faces=TRI;

SHRINK_FACTOR=0.8;

 for i=1:numel(FV.faces(:,3))
     
 TRIAG{i}=TR.Points(TR.ConnectivityList(i,:)',:);
 
 NORMAL{i}=TR.faceNormal(i);
 
 AREA(i)=0.5*norm(cross((TRIAG{i}(2,:)-TRIAG{i}(1,:)),(TRIAG{i}(3,:)-TRIAG{i}(1,:))));
 
 CROSS{i}=cross((TRIAG{i}(2,:)-TRIAG{i}(1,:)),(TRIAG{i}(3,:)-TRIAG{i}(1,:)));
 
 TR_Center{i}=TR.incenter(i);
 
 TRIAG_DIFF{i}=TRIAG{i}-TR_Center{i};
 
 TRIAG_SHRINK{i}=TR_Center{i}+SHRINK_FACTOR*TRIAG_DIFF{i};
 
 AREA_SHRINK(i)=0.5*norm(cross((TRIAG_SHRINK{i}(2,:)-TRIAG_SHRINK{i}(1,:)),(TRIAG_SHRINK{i}(3,:)-TRIAG_SHRINK{i}(1,:))));
     

 end
 
 AREA_SHRINK_FULL=sum(AREA_SHRINK);
 AREA_FULL=sum(AREA);
 
 TRIAG_OI{1}=TRIAG_SHRINK{1};
 TRIAG_OI_SEARCH{1}=TRIAG{1};
 INDEX_OI{1}=1;
 INDEX_DONE=[];
 TRIAG_SAVE{1}=TRIAG_OI{1};
 
COUNT=0;
SWITCH=0;

AREA_MOM=0;

TRIAG_OUT=[];

VEC_SEL=1:1:numel(TRIAG);

RAND_START{1}=randsample(VEC_SEL,1);

IND_DEL=find(VEC_SEL==RAND_START{1});

 VEC_SEL(IND_DEL)=[];
 
 while ~isempty(VEC_SEL)
     
 COUNT=COUNT+1;
 
 for k=1:numel(RAND_START)
 
 INDEX_NN{k}=TR.neighbors(RAND_START{k});
 
 [C{k}]=intersect(INDEX_NN{k},VEC_SEL);
 
 INDEX_NN_C{k}=C{k}; 
 
 if ~isempty(INDEX_NN_C{k})
 
 for i=1:numel(INDEX_NN_C{k})
     
     IND_DEL2=find(VEC_SEL==INDEX_NN_C{k}(i));
     
     VEC_SEL(IND_DEL2)=[];
 
     [INDEX,D]=knnsearch(TRIAG{INDEX_NN_C{k}(i)},TRIAG{RAND_START{k}});
     
     MAX=max(D);
     
     if MAX>0
         
  INDMIN_ON=find(D<MAX);
  INDMIN_OFF=INDEX(INDMIN_ON(1));
  DIFF_VEC=TRIAG_SHRINK{RAND_START{k}}(INDMIN_ON(1),:)-TRIAG_SHRINK{INDEX_NN_C{k}(i)}(INDMIN_OFF,:);
  TRIAG_SAVE{i}=TRIAG_SHRINK{INDEX_NN_C{k}(i)}+DIFF_VEC;
  
 
     else
         
     end
     
 end
 
 else
     
     
 end
 
 TRIAG_OUT{COUNT}=[TRIAG_SHRINK{RAND_START}; cell2mat(TRIAG_SAVE(:))];     

 end
     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
  