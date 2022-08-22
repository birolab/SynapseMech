function VOL_ENCLOSED=VOL_BOUND_Fun(SYNAPSE_ER,SYNAPSE,NO_FILES)

for i=1:NO_FILES
   

        
            
 VOL_ENCLOSED{i,1}=VOL_BOUND_SubFun(SYNAPSE_ER{i,1},SYNAPSE_ER{i,2});
           
 VOL_ENCLOSED{i,2}=VOL_BOUND_SubFun(SYNAPSE{i,1},SYNAPSE{i,2});          

    
    
    
    
end





end