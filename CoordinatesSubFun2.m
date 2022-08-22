function Output=CoordinatesSubFun2(Input,Input2)

Time=unique(Input(:,5));

for l=1:numel(Time)
    
INDEX{l}=find(Input(:,5)==Time(l));
   
   if ~isempty(INDEX{l})
   
Output.XYZ{l}=Input(INDEX{l},1:3)-Input2{1,7};
Output.TIME(l)=Time(l);
  
   else
   end
end


end