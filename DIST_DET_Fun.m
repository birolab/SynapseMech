function DIST_SPOTS=DIST_DET_Fun(SYNAPSEHR,SYNAPSEHR_ER, SPOTS,CMean_Map,CMean_ER_Map,NO_FILES)

for i=1:NO_FILES
   

 if ~isempty(SPOTS{i})       
            
 DIST_SPOTS{i}=DIST_DET_subFun(SYNAPSEHR{i,1},SYNAPSEHR_ER{i,1},SPOTS{i},CMean_Map{i,1},CMean_ER_Map{i,1});
 else
 DIST_SPOTS{i}=double.empty(1,0);
 end
           

    
    
    
    
end





end