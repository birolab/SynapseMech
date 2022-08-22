function AREA=Synapse_AreaFun(SYNAPSEHR, SYNAPSEHR_ER,SURFHR,SURFHR_ER,NO_FILES)

for i=1:NO_FILES
   

        
AREA{i,1}=Synapse_AreaSubFun(SYNAPSEHR_ER{i,1},SURFHR_ER{i,1});
AREA{i,2}=Synapse_AreaSubFun(SYNAPSEHR_ER{i,2},SURFHR_ER{i,2});            
AREA{i,3}=Synapse_AreaSubFun(SYNAPSEHR{i,1},SURFHR{i,1});
AREA{i,4}=Synapse_AreaSubFun(SYNAPSEHR{i,2},SURFHR{i,2});  

   
    
end





end