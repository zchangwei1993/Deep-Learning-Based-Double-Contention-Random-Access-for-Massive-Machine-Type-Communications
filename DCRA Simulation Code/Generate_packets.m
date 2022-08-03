function Node_state = Generate_packets(Node_state,Node_Number,Lamdda,PreambleOccupied,Subframe_count)
format long
% each node generates attempt according to rate Lamdda
for i = 1:Node_Number
    if rand(1,1,'double')<=Lamdda&&isempty(find(PreambleOccupied==i)) % no packet arrives when transmitting
        if Node_state(i,2) == 0
           Node_state(i,2)=1;
           Node_state(i,3)=Subframe_count;
           Node_state(i,5)=1; %five  0: empty,1: fresh access request, 2, old access request
        else
           Node_state(i,2)=Node_state(i,2)+1; 
        end
    end
end
