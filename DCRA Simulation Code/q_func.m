function [ f ] = q_func(x, p_dect, lambda_all, n, p_opti,M)
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
f=exp(-lambda_all/(M*(lambda_all/(n*x)+p_opti)))*(1+0.5*p_dect*lambda_all/(M*(lambda_all/(n*x)+p_opti)))-p_opti;

end

