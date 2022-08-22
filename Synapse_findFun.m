function [SURFHR,SYNAPSEHR,SURFHR_ER,SYNAPSEHR_ER]=Synapse_findFun(SURF,NO_FILES,FACTOR,THRESH_DIST)

for i=1:NO_FILES
   

        
            
 [SURFHR{i,1},SURFHR{i,2},SYNAPSEHR{i,1},SYNAPSEHR{i,2}]=Synapse_findSubFun(SURF{i,1},SURF{i,2});
           
 [SURFHR_ER{i,1},SURFHR_ER{i,2},SYNAPSEHR_ER{i,1},SYNAPSEHR_ER{i,2}]=Synapse_find_erodeFun(SURF{i,1},SURF{i,2},FACTOR,THRESH_DIST);               

    
    
    
    
end





end