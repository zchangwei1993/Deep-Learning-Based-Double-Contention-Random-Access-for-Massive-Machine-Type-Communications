function f = lambda(y,p,p_dect)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明

f=exp(-y/p)*(1+p_dect*y/(2*p))-p;

end

