function [ f ] = TACD(k,M)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
dis = 1000;
fun1 = @(r,k,M) r.*(1-(2000.^2-(r-dis).^2)/(M.*2000.^2)).^k;
fun2 = @(r,k,M) r.*(1-((r+dis).^2)/(M.*2000.^2)).^k;
fun3 = @(r,k,M) r.*(1-(4*dis*r)/(M.*2000.^2)).^k;
f = 2/2000.^2.*(integral(@(r) fun1(r,k,M),2000-dis,2000)+integral(@(r)fun2(r,k,M),0,dis)+integral(@(r)fun3(r,k,M),dis,2000-dis));

end

