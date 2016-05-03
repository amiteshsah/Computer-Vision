% Regularization:
% 1. Horn and Schunck 

function [u,v]=horn_schunck(I1,I2,nit)

Ix=conv2(I1,0.25*[-1,1;-1,1],'same')+conv2(I2,0.25*[-1,1;-1,1],'same');
Iy=conv2(I1,0.25*[-1,-1;1,1],'same')+conv2(I2,0.25*[-1,-1;1,1],'same');
It=conv2(I1,0.25*ones(2),'same')+conv2(I2,-0.25*ones(2),'same');

alpha=10;
[r,c]=size(I1);
u=zeros(r,c);
v=zeros(r,c);

for n=1:nit
    for i=2:r-1
        for j=2:c-1
            umean=0.25*(I1(i-1,j)+I1(i+1,j)+I1(i,j-1)+I1(i,j+1));
            vmean=0.25*(I2(i-1,j)+I2(i+1,j)+I2(i,j-1)+I2(i,j+1));
            
            p=(Ix(i,j)*umean+Iy(i,j)*vmean+It(i,j))/(alpha^2+Ix(i,j)^2+Iy(i,j)^2);
            u(i,j)=umean-Ix(i,j)*p;
            v(i,j)=vmean-Iy(i,j)*p;
        end
    end

end
end

     