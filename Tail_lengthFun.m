function Output=Tail_lengthFun(Input,SURF,NO_FILES)

for i=1:NO_FILES
    
    if ~isempty(Input{i}.DataOut.SpotsPipetteTip)
        
        PipetteX(i)=mean(Input{i}.DataOut.SpotsPipetteTip(:,1));
       
        
    else
        
        PipetteX(i)=NaN;
        
    end
    
    
    for l=1:numel(SURF{i,1}.VERT)
        
        
        CoM{l}=sum(SURF{i,1}.VERT{l})/numel(SURF{i,1}.VERT{l}(:,1));
        
        CoM_X(l)=CoM{l}(:,1);
        
    end
    
    CoM_TEST=mean(CoM_X);
  
    clear CoM_X
    
   if ~isempty(Input{i}.DataOut.SpotsPipetteTip)
    
    for l=1:numel(SURF{i,1}.VERT)
        
    
    
        
        if CoM_TEST>PipetteX(i)
            
            Output{i}(l)=PipetteX(i)-min(SURF{i,1}.VERT{l}(:,1));
            
        else
            Output{i}(l)=max(SURF{i,1}.VERT{l}(:,1))-PipetteX(i);
        end
        
       
    end
         
   else
       
        Output{i}=[];     
    
    end
    
    
    
    
    
end



end