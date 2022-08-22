function [SURF,SPOTS]=CoordinatesFun(Input,NO_FILES)

for i=1:NO_FILES
    
 if ~isempty(Input{i}.DataOut.Cytoplasm)
    
 SURF{i,1}=CoordinatesSubFun(Input{i}.DataOut.Cytoplasm);
 
        
 elseif ~isempty(Input{i}.DataOut.Lifeact)
    
SURF{i,1}=CoordinatesSubFun(Input{i}.DataOut.Lifeact);

    
end
    
if ~isempty(Input{i}.DataOut.Target)
    
SURF{i,2}=CoordinatesSubFun(Input{i}.DataOut.Target);
    
else
    
end

if isfield(Input{i}.DataOut,'SpotsGranules')
    
    if ~isempty(Input{i}.DataOut.SpotsGranules)
    
    SPOTS{i}=CoordinatesSubFun2(Input{i}.DataOut.SpotsGranules,Input{i}.DataOut.Target);
    
    else

    
    SPOTS{i}=[];


        
    end
else
        SPOTS{i}=[];
end
    




end




end