function Distance=Distance_estFun(SYNAPSEHR,NO_FILES)

for i=1:NO_FILES
    
    for l=1:numel(SYNAPSEHR{i,1})
    
 [Idx2{i}{l},D1{i}{l}]=knnsearch(SYNAPSEHR{i,2}.VERT{l},SYNAPSEHR{i,1}.VERT{l}); % D1 for Synapse1
 [Idx1{i}{l},D2{i}{l}]=knnsearch(SYNAPSEHR{i,1}.VERT{l},SYNAPSEHR{i,2}.VERT{l}); % D2 for Synapse2
    
   
end


end

Distance{i,1}=D1;
Distance{i,2}=D2;

end