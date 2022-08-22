function Output=CoordinatesSubFun(Input)

RETRIEVE=Input;

for l=RETRIEVE{1,3}+1:RETRIEVE{end,3}+1
    
   INDEX{l}=find(cell2mat(RETRIEVE(:,3))==l-1);
   
   if ~isempty(INDEX{l})
    
   Output.VERT{l}=RETRIEVE{INDEX{l}}-RETRIEVE{INDEX{l},7};
   Output.FACES{l}=RETRIEVE{INDEX{l},4}+1;
   
   MASK_OR{l}=RETRIEVE{INDEX{l},5};
   
   CC=bwconncomp(~MASK_OR{l});
   
numPixels = cellfun(@numel,CC.PixelIdxList);
[biggest,idx] = max(numPixels);

MASK_DUMMY=ones(size(MASK_OR{l}));
MASK_DUMMY(CC.PixelIdxList{idx}) = 0;

Output.MASK{l}=MASK_DUMMY;

clear CC numPixels biggest idx MASK_DUMMY
   
   
   
   
   
   
   
 
   
   Output.TIME(l)=l-1;
   
   Output.RES(:,1)=RETRIEVE{INDEX{l},6}(1,1);
   Output.RES(:,2)=RETRIEVE{INDEX{l},6}(1,2);
   Output.RES(:,3)=RETRIEVE{INDEX{l},6}(1,3);
    
   Output.RESMASK(:,1)=(RETRIEVE{INDEX{l},6}(1,1)/RETRIEVE{INDEX{l},9}(1,1));
   Output.RESMASK(:,2)=(RETRIEVE{INDEX{l},6}(1,2)/RETRIEVE{INDEX{l},9}(1,2));
   Output.RESMASK(:,3)=(RETRIEVE{INDEX{l},6}(1,3)/RETRIEVE{INDEX{l},9}(1,3));
    
   Output.SizeFOV(:,1)=size(RETRIEVE{1,5},1)*RETRIEVE{1,6}(1,1)/RETRIEVE{1,9}(1,1);
   Output.SizeFOV(:,2)=size(RETRIEVE{1,5},2)*RETRIEVE{1,6}(1,2)/RETRIEVE{1,9}(1,2);
   Output.SizeFOV(:,3)=size(RETRIEVE{1,5},3)*RETRIEVE{1,6}(1,3)/RETRIEVE{1,9}(1,3);
   
   else
       
       Output.VERT{l}=NaN;
   Output.FACES{l}=NaN;
   Output.MASK{l}=NaN;
   
   Output.TIME(l)=NaN;  
       
       
       
   end
end


end