function [Node_state,TotalAttempt] = Generate_attempts(Node_state,Node_Number,PreambleOccupied,ACBfactor)
%if packets in queue and no in backoff state, then generate attempt by
%choosing a preamble
format long
TotalAttempt = 0;
AvailablePreamble = find(PreambleOccupied==0); % available preamble vector
if isempty(AvailablePreamble)~=1 %there exist available preambles
    Tem = max(size(AvailablePreamble)); %the number of available preambles
        for node = 1:Node_Number
            Node_state(node,4)=Node_state(node,4)-1;
            if Node_state(node,2)>0&&rand(1,1,'double') <= ACBfactor&&Node_state(node,4)<1 % has packets, uniform backoff =0 and 
                        Node_state(node,1) = AvailablePreamble(randi([1,Tem]));
                        TotalAttempt =TotalAttempt +1;
            end
        end
end        