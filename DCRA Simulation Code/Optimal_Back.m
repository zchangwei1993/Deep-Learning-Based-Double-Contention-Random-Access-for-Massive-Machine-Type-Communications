function [ q, W ] = Optimal_Back( p_dect, lambda_all, n, M )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
p_opti = exp((1-p_dect-(1+p_dect^2)^0.5)/p_dect)*(1+p_dect+(1+p_dect^2)^0.5)/2;
q=fzero(@(x) q_func(x, p_dect, lambda_all, n, p_opti,M ),0.5);
W=round(fzero(@(x) W_func(x, p_dect, lambda_all, n, p_opti,M ),100));


end

