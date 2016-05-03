clc;
clear all;
close all;

img1=imread('dog1.png');
img1=rgb2gray(img1);
img1=im2double(img1);
l1=[16 19 30];
l1=l1/norm(l1);

img2=imread('dog2.png');
img2=rgb2gray(img2);
img2=im2double(img2);
l2=[13 16 30];
l2=l2/norm(l2);

img3=imread('dog3.png');
img3=rgb2gray(img3);
img3=im2double(img3);
l3=[-17 10.5 26.5];
l3=l3/norm(l3);

S= [l1;l2;l3];
[h,w]=size(img1);

b=ones(h,w,3);
b=double(b);
g=zeros(h,w,3);

p=ones(h,w);
p=double(p);
q=p;

for i=1:h
    for j=1:w
        E=[img1(i,j);img2(i,j);img3(i,j)];
        E=double(E);
        tb=(inv(S'*S))*S'*E;
        g(i,j,:)=tb;
        nbm=norm(tb);
        if(nbm==0)
            b(i,j,:)=0; 
        else
            b(i,j,:)=tb/nbm;
        end
        tM=[b(i,j,1) b(i,j,2) b(i,j,3)];
        nbm=norm(tM);
        if(nbm==0)
            tM=[0 0 0];
        else
            tM=tM/nbm; 
        end        
        p(i,j)=tM(1,1);
        q(i,j)=tM(1,2);
    end
end

albedo=sqrt(g(:,:,1).^2+ g(:,:,2).^2+g(:,:,3).^2);
figure,imshow(albedo,[]);title('Albedo')

x1=linspace(0,1,h);
y1=linspace(0,1,w);
[x,y] = meshgrid(x1,y1);
figure
quiver(x,y,p,q),title('Normal Field');
%%
% Integration using simple algorith used in forsyth
depth=zeros(h,w);
for i=2:h
    depth(i,1)=depth(i-1,1)+q(i,1); 
end
for i=2:h
    for j=2:w
    depth(i,j)=depth(i-1,j)+p(i,j);
    end
end
depthc=zeros(h,w);

%%
%compute depth using SHAH'S Method
depths=zeros(h,w);
for i = 2:h
for j = 2:w
depths(i,j) = depths(i-1,j-1)+q(i,j)+p(i,j);
end
end
%%
% Depthmap reconstruction using Frankotchellapa
d2=frankotchellappa(p,q);
 DepthMap=d2;
figure,imshow(DepthMap,[]);title('Depthmap');
[ X, Y ] = meshgrid( 1:w, 1:h );

figure;
surf( X, Y, depth, 'EdgeColor', 'none' ); title('3D reconstruction using simple integration');
camlight left;
lighting phong


figure;
surf( X, Y, depths, 'EdgeColor', 'none' ); title('3D reconstruction using SHAH Method');
camlight left;
lighting phong


figure;
surf( X, Y, DepthMap, 'EdgeColor', 'none' ); title('3D reconstruction using frankotchellappa integration');
camlight left;
lighting phong

figure
surfnorm(X(1:5:100,1:5:100),Y(1:5:100,1:5:100),DepthMap(1:5:100,1:5:100)),title('Surface Normals');

%%
l4=[9,-25,4];
l4=l4/norm(l4);

I4=zeros(h,w);
nor=zeros(1,3);
for i=1:h
    for j=1:w
        nor(1,:)=[p(i,j),q(i,j),1];
I4(i,j)=albedo(i,j)*(dot(nor(1,:),l4(1,:),2));
    end
end
figure,
imshow(I4,[]);title('Image reconstruction from albedo and light l4=[9,-25,4];');

