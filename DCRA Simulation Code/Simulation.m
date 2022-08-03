function Simu_data = Simulation(Total_subframe,M_Preamble,Aggregate_input_rate,Node_Number,ACBfactor,UBfactor,TransRate,P_detect)
% Aggregate_input_rate is the aggregate request input rate of the network
UB=1;
Lamdda = Aggregate_input_rate/Node_Number; %request input rate of each node at RA Slot
%Lamdda = 1-(1-Lamdda)^(1/Period);          %data input rate of each node at subframe
Node_state = zeros(Node_Number,11); 
%{
fisrt colum  = preamble 
second colum = packet number, 
thrid        = the time slot in which a fresh access request is generated
four         = UB counter
five         = request queue 0: empty,1: fresh access request, 2, old access request
six          = total number of time slot request queu in tau_H
seven         = total number of successful access request from State 0
%}
Total_attempt  = 0;  %total number of attempts at each slot, TotalAttempt does not account the attemot from the MTD who is
               % currently transmitting data packets
Succes_attempt = 0;  %total number of successful attempts at each slot
Total_attempt_Part =  0; %to capture the dropping of p with t, we separately account 
%the total attempts and successful attempts in [1,T/2] and in [T/2,T]
Succes_attempt_Part =  0;
TauH_Part =  0;
Nonempty_Part = 0;
TauHAccount_Part = 0;
Subframe_count = 1;
TotalDelay = 0;
Request_T  = 0;  % the total time slot in which each MTDs has data packets (non-empty probability)
ChannelH = 0 ;
ChannelH2 = 0;
Request_Temple = 0;
Transmitted_Data = 0;
Transmitted_Data_Part2 = 0;
Preamble_Used_All=0;
PUSCH_assigned_All=0;
[collided0_all,collided1_all,collided2_all,collided3_all,collided4_all,collided5_all]=deal(0);
PreambleOccupied = zeros(1,M_Preamble); % 0=available; =x, represents that the preamble is busy and occupied by node x
TAp_total = 0;
while 1 
        Node_state = Generate_packets(Node_state,Node_Number,Lamdda,PreambleOccupied,Subframe_count);
        for node = 1:Node_Number      % how many MTDs have packets
            if  Node_state(node,2)>0
                    Request_T = Request_T+1; %total number of access requests
                    Request_Temple = Request_Temple+1;
            end    
        end  
        if Subframe_count>(Total_subframe*0.8)
           Nonempty_Part = Request_Temple+Nonempty_Part;
        end 
        Request_Temple = 0;
        Node_state(:,1) = zeros(Node_Number,1); %intial the chosen preamble at each node 
        % choosing a preamble,TotalAttempt does not account the attemot from the MTD who is
        % currently transmitting data packets
        [Node_state,TotalAttempt] = Generate_attempts(Node_state,Node_Number,PreambleOccupied,ACBfactor);
        TAp = TACD(TotalAttempt,M_Preamble);
        TAp_total = TAp_total + TAp;
        % if two or more nodes choose same preamble collison happens, all will backoff 
        [Success_Node,Node_state,PreambleOccupied,Tau,TauFlag,Preamble_Used,PUSCH_assigned,collided0,collided1,collided2,collided3,collided4,collided5] = Transmission_Collision(Node_state,Node_Number,M_Preamble,TransRate,PreambleOccupied,P_detect,UBfactor);
        Total_attempt= TotalAttempt+Total_attempt;
        Succes_attempt = sum(Success_Node)+Succes_attempt; 
        Preamble_Used_All=Preamble_Used_All+Preamble_Used;
        PUSCH_assigned_All=PUSCH_assigned_All+PUSCH_assigned;
        collided0_all=collided0_all+collided0;
        collided1_all=collided1_all+collided1;
        collided2_all=collided2_all+collided2;
        collided3_all=collided3_all+collided3;
        collided4_all=collided4_all+collided4;
        collided5_all=collided5_all+collided5;
        if sum(Success_Node)>=1
            SuccessNodeVector = find(Success_Node==1);
            for i=1:max(size(SuccessNodeVector))
                 Transmitted_Data = Transmitted_Data +Node_state(SuccessNodeVector(i),2); %number of data packets will be transmitted
            end
        end
        if Subframe_count>(Total_subframe*0.8)
           Total_attempt_Part = TotalAttempt+Total_attempt_Part ;
           Succes_attempt_Part =  sum(Success_Node)+Succes_attempt_Part; 
           TauH_Part = Tau+TauH_Part;
           TauHAccount_Part = TauFlag+TauHAccount_Part;
          if  sum(Success_Node)>=1
               for i=1:max(size(SuccessNodeVector))
                  Transmitted_Data_Part2 = Transmitted_Data_Part2 +Node_state(SuccessNodeVector(i),2);
               end
           end
        end
        if sum(PreambleOccupied)>0 % at least one preamble is occupied, data is transmitted
            for i=1:M_Preamble
                if PreambleOccupied(i)>0 % preamble i is occupied
                    Node_state(PreambleOccupied(i),2) = Node_state(PreambleOccupied(i),2)-TransRate; 
                   if Node_state(PreambleOccupied(i),2)<1
                        Node_state(PreambleOccupied(i),2)=0;
                        Node_state(PreambleOccupied(i),5)=0; % request queue 0: empty,1: fresh access request, 2, old access request
                        if Subframe_count>(Total_subframe*0.8)
                          TotalDelay = TotalDelay+Subframe_count-Node_state(PreambleOccupied(i),3)+1;
                        end
                        Node_state(PreambleOccupied(i),3) = 0;
                        PreambleOccupied(i) = 0;
                   end
                end
            end
        end    
        for i=1:M_Preamble
             if PreambleOccupied(i)>0 
                ChannelH = ChannelH+1;
                 if Subframe_count>(Total_subframe*0.8)
                     ChannelH2 = ChannelH2+1;
                 end
             end
        end
        Subframe_count = Subframe_count+1;
        if Subframe_count >Total_subframe
            break
        end
end
collided_all=collided0_all+collided1_all+collided2_all+collided3_all+collided4_all+collided5_all;

%% below here is to get the successful trans proba along the time
Simu_data(1)  = Succes_attempt/Total_attempt;      %Success prob
Simu_data(2)  = 1-ChannelH/(Subframe_count-1);      %channel is not in State H probability
Simu_data(3)  = Succes_attempt/(Subframe_count-1);      %Throughput
Simu_data(4)  = Succes_attempt/Preamble_Used_All;  % preamble utilzation
Simu_data(5)  = PUSCH_assigned_All/Total_subframe;  % PUSCH utilzation
Simu_data(6)  = TotalDelay/Succes_attempt_Part;   %delay
Simu_data(7)  = Request_T/(Node_Number*Total_subframe);   % non-empty probability
Simu_data(8)  = Succes_attempt_Part/Total_attempt_Part;  % Success prob1 
Simu_data(9) = Succes_attempt_Part/(Total_subframe*0.2);  % Throuput2
Simu_data(10)  = TauH_Part/TauHAccount_Part;  % TauH2
Simu_data(11)  = 1-ChannelH2/(Total_subframe*0.2);      %channel is not in State H probability
Simu_data(12)  = Transmitted_Data/(Subframe_count-1);  % data throughput
Simu_data(13)  = Transmitted_Data_Part2/(Total_subframe*0.2);       % data throughput
Simu_data(14)  = Nonempty_Part/(Node_Number*Total_subframe*0.2);   % non-empty probability2
Simu_data(15)  = collided0_all/collided_all;
Simu_data(16)  = collided1_all/collided_all;
Simu_data(17)  = collided2_all/collided_all;
Simu_data(18)  = collided3_all/collided_all; 
Simu_data(19)  = collided4_all/collided_all;
Simu_data(20)  = collided5_all/collided_all; 
Simu_data(21) = TAp_total/(Subframe_count-1);

