function [CMean,CGauss,CMeanHR,CGaussHR,CMean_Map,CMean_ER_Map]=Curvature_detFun(SURF,NO_FILES,SURFHR,SYNAPSEHR,SYNAPSEHR_ER,SWITCH_HR)

  switch SWITCH_HR
      case 'on'
          
for i=1:NO_FILES
    
    
    for l=1:numel(SURF{i,1}.VERT)
       
        
        if ~isempty(SURF{i,1}.VERT{l})
        
FV1{i,l}.vertices=SURF{i,1}.VERT{l};
FV1{i,l}.faces=SURF{i,1}.FACES{l};

FV2{i,l}.vertices=SURF{i,2}.VERT{l};
FV2{i,l}.faces=SURF{i,2}.FACES{l};

FV1HR{i,l}.vertices=SURFHR{i,1}.VERT{l};
FV1HR{i,l}.faces=SURFHR{i,1}.FACES{l};

FV2HR{i,l}.vertices=SURFHR{i,2}.VERT{l};
FV2HR{i,l}.faces=SURFHR{i,2}.FACES{l};
            
        
[CMean{i,1}{l},CGauss{i,1}{l},Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV1{i,l},true);
[CMean{i,2}{l},CGauss{i,2}{l},Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV2{i,l},true);


[CMeanHR{i,1}{l},CGaussHR{i,1}{l},Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV1HR{i,l},true);
[CMeanHR{i,2}{l},CGaussHR{i,2}{l},Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV2HR{i,l},true);


 if ~isempty(SYNAPSEHR{i,1}{l})
[IdxMap1_C{i,l},DMap1_C{i,l}]=knnsearch(SURF{i,1}.VERT{l},SYNAPSEHR{i,1}.VERT{l});
CMean_Map{i,1}{l}=CMean{i,1}{l}(IdxMap1_C{i,l}); % Curvature High res Synapse 1
 else
CMean_Map{i,1}{l}=[];
 end

 
 if ~isempty(SYNAPSEHR{i,2}{l})
[IdxMap2_C{i,l},DMap2_C{i,l}]=knnsearch(SURF{i,2}.VERT{l},SYNAPSEHR{i,2}.VERT{l});
CMean_Map{i,2}{l}=CMean{i,2}{l}(IdxMap2_C{i,l}); % Curvature High res Synapse 2
 else
 CMean_Map{i,2}{l}=[];
 end
 
 
  
  if ~isempty(SYNAPSEHR_ER{i,1}.VERT{l})
[IdxMap1_ER_C{i,l},DMap1_ER_C{i,l}]=knnsearch(SURF{i,1}.VERT{l},SYNAPSEHR_ER{i,1}.VERT{l});
CMean_ER_Map{i,1}{l}=CMean{i,1}{l}(IdxMap1_ER_C{i,l}); % Curvature High res Synapse 1
 else
CMean_ER_Map{i,1}{l}=[];
 end

 
  if ~isempty(SYNAPSEHR_ER{i,2}.VERT{l})
[IdxMap2_ER_C{i,l},DMap2_ER_C{i,l}]=knnsearch(SURF{i,2}.VERT{l},SYNAPSEHR_ER{i,2}.VERT{l});
CMean_ER_Map{i,2}{l}=CMean{i,2}{l}(IdxMap2_ER_C{i,l}); % Curvature High res Synapse 1
 else
CMean_ER_Map{i,2}{l}=[];
  end
 
        else
            CMean{i,1}{l}=[];
            CGauss{i,1}{l}=[];
            CMeanHR{i,1}{l}=[];
            CGaussHR{i,1}{l}=[];
             CMean{i,2}{l}=[];
            CGauss{i,2}{l}=[];
            CMeanHR{i,2}{l}=[];
            CGaussHR{i,2}{l}=[];
            
        end
 
 
 
 
 

end


end

      case 'off'

for i=1:NO_FILES
    i
    for l=1:min(numel(SURF{i,1}.VERT),numel(SURF{i,2}.VERT))
        l
         if ~isempty(SURF{i,1}.VERT{l})&~isnan(SURF{i,2}.VERT{l}(1,1))&~isnan(SURF{i,1}.VERT{l}(1,1))
        
FV1{i,l}.vertices=SURF{i,1}.VERT{l};
FV1{i,l}.faces=SURF{i,1}.FACES{l};

FV2{i,l}.vertices=SURF{i,2}.VERT{l};
FV2{i,l}.faces=SURF{i,2}.FACES{l};
            
        
[CMean{i,1}{l},CGauss{i,1}{l},Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV1{i,l},true);
[CMean{i,2}{l},CGauss{i,2}{l},Dir1,Dir2,Lambda1,Lambda2]=patchcurvature(FV2{i,l},true);

CMeanHR=[];
CGaussHR=[];

 if ~isempty(SYNAPSEHR{i,1}.VERT{l})
[IdxMap1_C{i,l},DMap1_C{i,l}]=knnsearch(SURF{i,1}.VERT{l},SYNAPSEHR{i,1}.VERT{l});
CMean_Map{i,1}{l}=CMean{i,1}{l}(IdxMap1_C{i,l}); % Curvature High res Synapse 1
 else
CMean_Map{i,1}{l}=[];
 end

 
 if ~isempty(SYNAPSEHR{i,2}.VERT{l})
[IdxMap2_C{i,l},DMap2_C{i,l}]=knnsearch(SURF{i,2}.VERT{l},SYNAPSEHR{i,2}.VERT{l});
CMean_Map{i,2}{l}=CMean{i,2}{l}(IdxMap2_C{i,l}); % Curvature High res Synapse 2
 else
 CMean_Map{i,2}{l}=[];
 end

 
  if ~isempty(SYNAPSEHR_ER{i,1}.VERT{l})
[IdxMap1_ER_C{i,l},DMap1_ER_C{i,l}]=knnsearch(SURF{i,1}.VERT{l},SYNAPSEHR_ER{i,1}.VERT{l});
CMean_ER_Map{i,1}{l}=CMean{i,1}{l}(IdxMap1_ER_C{i,l}); % Curvature High res Synapse 1
 else
CMean_ER_Map{i,1}{l}=[];
 end

 
  if ~isempty(SYNAPSEHR_ER{i,2}.VERT{l})
[IdxMap2_ER_C{i,l},DMap2_ER_C{i,l}]=knnsearch(SURF{i,2}.VERT{l},SYNAPSEHR_ER{i,2}.VERT{l});
CMean_ER_Map{i,2}{l}=CMean{i,2}{l}(IdxMap2_ER_C{i,l}); % Curvature High res Synapse 1
 else
CMean_ER_Map{i,2}{l}=[];
 end

 else
            CMean{i,1}{l}=[];
            CGauss{i,1}{l}=[];
            CMeanHR{i,1}{l}=[];
            CGaussHR{i,1}{l}=[];
             CMean{i,2}{l}=[];
            CGauss{i,2}{l}=[];
            CMeanHR{i,2}{l}=[];
            CGaussHR{i,2}{l}=[];
            
        end 
 
 
 
 
 
 
end


end
  end

end