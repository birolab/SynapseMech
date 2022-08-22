function DEXTRAN_INT=DET_DEXTR_Fun(SYNAPSE,NO_FILES,DEX_RADIUS,Input,SURF,VOL_BOUND)

for i=1:NO_FILES
   

        
 if isfield(Input{i}.DataOut,'DextranInt')    
     
     if ~isempty(Input{i}.DataOut.DextranInt)
         
 DEXTRAN_INT{i}=DET_DEXTR_SubFun(SYNAPSE{i,1},SYNAPSE{i,2},DEX_RADIUS,Input{i}.DataOut.DextranInt,SURF{i,1}.RES,VOL_BOUND{i});
     else
         
        DEXTRAN_INT{i}=[];
     end
 else   
DEXTRAN_INT{i}=[];
     end
    
    
    
    
end





end