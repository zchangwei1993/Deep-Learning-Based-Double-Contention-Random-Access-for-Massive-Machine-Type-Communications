function [ f ] = W_func(x, p_dect, lambda_all, n, p_opti,M )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
f=exp(-lambda_all/(M*(lambda_all/n*(1+(x-1)/2)+p_opti*(1-lambda_all*(x-1)/(2*n)))))*(1+0.5*p_dect*lambda_all/(M*(lambda_all/n*(1+(x-1)/2)+p_opti*(1-lambda_all*(x-1)/(2*n)))))-p_opti;

end

