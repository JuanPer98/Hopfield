function [ M ] = ensamb( m,d1,d2 )
%Assemble columnized matrix on the desired dimensions
%   Takes the columnized matrix m (vector) and turns it into a matrix of
%   d1 x d2

M=zeros(d1,d2);
d=0;
for i =1:d2
    for j=1:d1
        d=d+1;
        M(j,i)=m(d);
    end
end

end

