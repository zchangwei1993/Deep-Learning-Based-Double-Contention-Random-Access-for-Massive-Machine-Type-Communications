clc
clear
format long
M_Preamble_vector = 1;
Node_Number_vector = 50:5:100;
Total_subframe =10^6;
e=2.71828;
k=1;
TransRate = 10^10;
RunSim = 1;
Input_rate_vector = 0.3;
P_detect_vector=1;
ACBfactor_vector=[0.03];
 for AA = 1:max(size(Node_Number_vector))
      M_Preamble=M_Preamble_vector(1);
      Node_Number = Node_Number_vector(AA);
      Aggregate_input_rate=Input_rate_vector*Node_Number;
      P_detect=P_detect_vector(1);
      %[optiQ,optiW]=Optimal_Back( P_detect, Aggregate_input_rate, Node_Number,M_Preamble );
      ACBfactor=ACBfactor_vector(1);
      UBfactor=1;
       Simu_data = Simulation(Total_subframe,M_Preamble,Aggregate_input_rate,Node_Number,ACBfactor,UBfactor,TransRate,P_detect);
        if k == 1
           fid=fopen('data\Simulation.txt','w'); 
           k=0;
        else
           fid=fopen('data\Simulation.txt','a'); 
        end
        fprintf(fid,'%f ',Node_Number);  
        fprintf(fid,'%f ',M_Preamble); 
        fprintf(fid,'%f ',Aggregate_input_rate);
        fprintf(fid,'%f ',TransRate); 
        fprintf(fid,'%f ',ACBfactor); 
        fprintf(fid,'%f ',UBfactor); 
        for i = 1:21
            fprintf(fid,'%d ',Simu_data(i)); 
        end
    fprintf(fid,'\r\n'); 
    fclose(fid); 
 end

