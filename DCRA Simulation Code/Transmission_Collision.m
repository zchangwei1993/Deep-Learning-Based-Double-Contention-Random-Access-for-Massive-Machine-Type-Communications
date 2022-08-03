function [Success_Node,Node_state,PreambleOccupied,Tau,TauFlag,Preamble_Used,PUSCH_assigned,collided0,collided1,collided2,collided3,collided4,collided5] = Transmission_Collision(Node_state,Node_Number,M_Preamble,TransRate,PreambleOccupied,P_detect,UBfactor)
Success_Node = zeros(Node_Number,1); %=1 the transmission will success
Tau = 0;
TauFlag = 0;
Preamble_Used=0;
PUSCH_assigned=0;
collided0=0;
collided1=0;
collided2=0;
collided3=0;
collided4=0;
collided5=0;
for i= 1:M_Preamble
    Contender=find(Node_state(:,1)==i);  %Node who choose the same preamble
    if isempty(Contender)==1
        Size_Contender=0;
        collided0=collided0+1;
    else
        Preamble_Used=Preamble_Used+1;
        Size_Contender = max(size(Contender));
    end
    if Size_Contender==1&&PreambleOccupied(i)==0 % it chooses a unique preamble and the channel is empty
        collided1=collided1+1;
        PUSCH_assigned=PUSCH_assigned+1;
        Success_Node(Contender)=1;
        PreambleOccupied(i)= Contender;
        Node_state(Contender,9)=Node_state(Contender,9)+1; %9 total number of successful access request;
        %PacketNum = PacketNum+Node_state(Contender,2);
        Service = Node_state(Contender,2);%ceil(Node_state(Contender,2)/(TransRate*Period));
        if Node_state(Contender,5)==2  %five  0: empty,1: fresh access request, 2, old access request
            Node_state(Contender,7) = Node_state(Contender,7)+1; %total number of successful access request from State 0
            Node_state(Contender,6) = Node_state(Contender,6)+ ceil(Service/TransRate)-1;   %  six  = total number of time slot request queu in tau_H
            Node_state(Contender,8) = Node_state(Contender,8)+Service;
            Tau = ceil(Service/TransRate)-1;
            TauFlag = 1;
        end
    elseif Size_Contender==2&&rand(1,1,'double') <= P_detect
        collided2=collided2+1;
        PUSCH_assigned=PUSCH_assigned+2;
        for node = 1:2
            Node_state(Contender(node),11) = randi([1,2]);
        end
        for j = 1:2%二次竞争的资源块
            Contender_second=find(Node_state(:,11)==j);
            if isempty(Contender_second)==1
                Size_Contender_second = 0;
            else
                Size_Contender_second = max(size(Contender_second));
            end
            if Size_Contender_second==1 % it chooses a unique preamble and the channel is empty
                Success_Node(Contender_second)=1;
                Node_state(Contender_second,9)=Node_state(Contender_second,9)+1; %9 total number of successful access request;
                %PacketNum = PacketNum+Node_state(Contender,2);
                Service = Node_state(Contender_second,2);%ceil(Node_state(Contender,2)/(TransRate*Period));
                if Node_state(Contender_second,5)==2  %five  0: empty,1: fresh access request, 2, old access request
                    Node_state(Contender_second,7) = Node_state(Contender_second,7)+1; %total number of successful access request from State 0
                    Node_state(Contender_second,6) = Node_state(Contender_second,6)+ ceil(Service/TransRate)-1;   %  six  = total number of time slot request queu in tau_H
                    %%%%%%%%%%%%
                    Node_state(Contender_second,8) = Node_state(Contender_second,8)+Service;
                    Tau = ceil(Service/TransRate)-1;
                    TauFlag = 1;
                end
            end
        end
    elseif Size_Contender==3
        collided3=collided3+1;
    elseif Size_Contender==4
        collided4=collided4+1;
    elseif Size_Contender==5
        collided5=collided5+1;
    end
    Node_state(:,11)=zeros(Node_Number,1);
end



for node = 1:Node_Number
    if Node_state(node,1)>0&&Success_Node(node)~=1   %collision
        Node_state(node,4) = randi([0,UBfactor])+1; %UB
        Node_state(node,5) =  2; %five  0: empty,1: fresh access request, 2, old access request
    end
end
