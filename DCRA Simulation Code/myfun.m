function f = myfun(x,n,q,w,lambert,p_dect)
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% f=exp(-(lambert/(lambert*((1/q)+(w-1)/2)/n+x*(1-lambert*(w-1)/(2*n)))))*(1+(lambert*p_dect*(n-1)/(2*n))/(lambert*((1/q)+(w-1)/2)/n+x*(1-lambert*(w-1)/(2*n))))-x;
f=exp(-(lambert/(lambert*(1/q+(w-1)/2)/n+x*(1-lambert*(w-1)/2/n))))*(1+(lambert*p_dect/2)/(lambert*(1/q+(w-1)/2)/n+x*(1-lambert*(w-1)/2/n)))-x;

end

