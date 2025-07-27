function [ M ] = ensamb( m,d1,d2 )
%ensamblar matrices
%   Detailed explanation goes here

M=zeros(d1,d2);
d=0;
for i =1:d2
    for j=1:d1
        d=d+1;
        M(j,i)=m(d);
    end
end

end

