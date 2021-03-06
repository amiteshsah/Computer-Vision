clc;clear all;close all;

% Read stereo pair of images
left_image=imread('left.jpg');
right_image=imread('right.jpg');
figure,subplot(1,2,1),imshow(left_image);title('Left image');
 subplot(1,2,2),imshow(right_image);title('Right image');

% cpselect(left_image,right_image)
load left_points;
load right_points;

% Intrinsic Parameters
 alpha=2424.3;
 beta=2459.6;
 teta=89.771;
 x0=1775.7;
 y0=1065.1;
 
% Landmark coordinate with respect to image center
 for i=1:size(left_points,1)
 left_center(i,1)=left_points(i,1)-x0;
 left_center(i,2)=left_points(i,2)-y0;
 right_center(i,1)=right_points(i,1)-x0;
 right_center(i,2)=right_points(i,2)-y0;
 end
 
%  Calculation of horizontal and vertical disparity in pixel width
 dis_x=left_center(:,1)-right_center(:,1);
 dis_y=left_center(:,2)-right_center(:,2);
 figure,
 plot(dis_x,dis_y,'r*'),title('Disparity of corners');
 xlabel('Horizontal disparity in pixel unit');
 ylabel('Vertical Disparity in pixel unit');

%  Horizontal Disparity in mm
f=3.1;      % in mm 
pdx=alpha/f;
dis_xmm=dis_x/pdx;

% vertical disparity in mm
pdy=beta/f;
dis_ymm=dis_y/beta;

% x and y coordinates of left image landmark points in mm
xmm=left_points(:,1)./pdx;
ymm=left_points(:,2)./pdy;


% Using triangulation
B=705-148;
Z=(B*f)./dis_xmm;

% Using Perspective projection
X=(Z.*xmm)/f;
Y=(Z.*ymm)/f;

% Making a semi-cuboid  by arranging the coordinates
 X1=[X(1),X(2),X(4),X(3),X(6),X(7),X(5),X(2),X(1),X(3),X(4),X(7)];
 Y1=[Y(1),Y(2),Y(4),Y(3),Y(6),Y(7),Y(5),Y(2),Y(1),Y(3),Y(4),Y(7)];
 Z1=[Z(1),Z(2),Z(4),Z(3),Z(6),Z(7),Z(5),Z(2),Z(1),Z(3),Z(4),Z(7)];

 %Plotting the cuboid and the corner point  
figure,plot3(X1,Y1,Z1), title('3D Reconstruction Image of cuboid'),
xlabel('x-axis in mm');
ylabel('y-axis in mm');
zlabel('z-axis in mm');
hold on
scatter3(X,Y,Z);


