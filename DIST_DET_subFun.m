function OUTPUT=DIST_DET_subFun(SYNAPSEHR_IN,SYNAPSEHR_ER_IN,SPOTS_IN,CMean_Map_IN,CMean_ER_Map_IN)

for l=1:numel(SPOTS_IN.XYZ)
    
    if ~isnan(SYNAPSEHR_IN.VERT{l})

 [ID_NN_HR{l},D_NN_HR{l}]=knnsearch(SYNAPSEHR_IN.VERT{l},SPOTS_IN.XYZ{l});
 
 if ~isempty(D_NN_HR{l})
     
 MED_D_NN_HR(l)=median(D_NN_HR{l});
 
 [MIN_D_NN_HR(l),ID_MIN_D_NN_HR(l)]=min(D_NN_HR{l});
 
 CURV_DIST_HR{l}=CMean_Map_IN{l}(ID_NN_HR{l});
 
 CURV_DIST_HR_MIN(l)=CMean_Map_IN{l}(ID_NN_HR{l}(ID_MIN_D_NN_HR(l)));
 
 else
     
     
     
 MED_D_NN_HR(l)=NaN;
 D_NN_HR{l}=NaN;

 MIN_D_NN_HR(l)=NaN;
 ID_MIN_D_NN_HR(l)=NaN;
 CURV_DIST_HR{l}=NaN;
 
 CURV_DIST_HR_MIN(l)=NaN;   
     
 end
  MED_D_NN_HR(l)=NaN;
 D_NN_HR{l}=NaN;

 MIN_D_NN_HR(l)=NaN;
 ID_MIN_D_NN_HR(l)=NaN;
 CURV_DIST_HR{l}=NaN;
 
 CURV_DIST_HR_MIN(l)=NaN;   
     
 
    end
    
    
    if ~isnan(SYNAPSEHR_ER_IN.VERT{l})
    
 [ID_NN_HR_ER{l},D_NN_HR_ER{l}]=knnsearch(SYNAPSEHR_ER_IN.VERT{l},SPOTS_IN.XYZ{l});

  if ~isempty(D_NN_HR_ER{l})
 MED_D_NN_HR_ER(l)=median(D_NN_HR_ER{l});
 
 [MIN_D_NN_HR_ER(l),ID_MIN_D_NN_HR_ER(l)]=min(D_NN_HR_ER{l});
 
 CURV_DIST_HR_ER{l}=CMean_ER_Map_IN{l}(ID_NN_HR_ER{l});
 
 CURV_DIST_HR_ER_MIN(l)=CMean_ER_Map_IN{l}(ID_NN_HR_ER{l}(ID_MIN_D_NN_HR_ER(l)));
 
 
 
 
  else
      
   MED_D_NN_HR_ER(l)=NaN;
 
 MIN_D_NN_HR_ER(l)=NaN;
     ID_MIN_D_NN_HR_ER(l)=NaN;
 
 CURV_DIST_HR_ER{l}=NaN;
 
 CURV_DIST_HR_ER_MIN(l)=NaN;
 D_NN_HR_ER{l}=NaN;
     
      
  end
    else
        
              
   MED_D_NN_HR_ER(l)=NaN;
 
 MIN_D_NN_HR_ER(l)=NaN;
     ID_MIN_D_NN_HR_ER(l)=NaN;
 
 CURV_DIST_HR_ER{l}=NaN;
 
 CURV_DIST_HR_ER_MIN(l)=NaN;
 D_NN_HR_ER{l}=NaN;
        
    end

end

OUTPUT.D_SYN_SPOTS=D_NN_HR;
OUTPUT.MED_D_SYN_SPOTS= MED_D_NN_HR;
OUTPUT.MIN_D_SYN_SPOTS= MIN_D_NN_HR;
OUTPUT.CURV_SPOTS=CURV_DIST_HR;
OUTPUT.CURV_SPOTS_MIN=CURV_DIST_HR_MIN;

OUTPUT.D_SYN_SPOTS_ER=D_NN_HR_ER;
OUTPUT.MED_D_SYN_SPOTS_ER= MED_D_NN_HR_ER;
OUTPUT.MIN_D_SYN_SPOTS_ER= MIN_D_NN_HR_ER;
OUTPUT.CURV_SPOTS_ER=CURV_DIST_HR_ER;
OUTPUT.CURV_SPOTS_MIN_ER=CURV_DIST_HR_ER_MIN;

end
