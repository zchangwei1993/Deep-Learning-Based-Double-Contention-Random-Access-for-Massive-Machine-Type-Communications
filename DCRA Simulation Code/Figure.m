clear;
clc;


lambert=0.3;
q1=0.03;
w1=1;
N=1;
p_dect=1;



x_solve=zeros(200,3);

for n1=50:5:100
    x=fzero(@(x) myfun(x,n1/N,q1,w1,lambert*n1,p_dect),0);
    lambda_out=fzero(@(y) lambda(y,x,p_dect),1);
    lambda_max=0.415*(-1+p_dect+(1+p_dect^2)^0.5)/p_dect;
        x_solve(n1,1)=x;
        x_solve(n1,2)=abs(lambda_out);
        x_solve(n1,3)=lambda_max;
end

load data\Simulation.txt;

figure(1)
q=1:11;
plot(50+5*(q-1),x_solve(50+5*(q-1),1),'-r',Simulation(q,1),Simulation(q,7),'or');
hold on;
xlabel('$n$','Interpreter','latex');
ylabel('$p$','Interpreter','latex');
h=legend('Analysis, $p_{\rm dect}=1$','Simulation, $p_{\rm dect}=1$');
set(h,'Interpreter','latex');

figure(2)
q=1:11;
plot(50+5*(q-1),x_solve(50+5*(q-1),2),'-b',Simulation(q,1),Simulation(q,9),'*b');
xlabel('$n$','Interpreter','latex');
ylabel('$\hat\lambda_{\rm out}$','Interpreter','latex');
h=legend('Analysis, $p_{\rm dect}=1$','Simulation, $p_{\rm dect}=1$');
set(h,'Interpreter','latex');
set(gca,'YLim',[0.1 0.8]);

