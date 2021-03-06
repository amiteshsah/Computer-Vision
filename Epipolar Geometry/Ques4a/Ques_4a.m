clc,close all
% Reading the stereo pair of scene
left=imread('Left.jpg');
right=imread('Right.jpg');

% Load the left points and right points
load left_points.mat
load right_points.mat

% Plotting the point selected
figure(1),imshow(left),title('Points on the left image'),title('Left Image and 12 points'),
hold on, plot(left_points(:,1),left_points(:,2),'r*')

figure(2),imshow(right),title('Points on the right image'),title('Right Image and 12 corresponding points'),
hold on, plot(right_points(:,1),right_points(:,2),'r*')


%% Calculate the F-matrix
% Normalize the points( Hartley preconditioning algorithm)
% The coordinates of corresponding points can have a wide range leading to numerical instabilities.
% It is better to first normalize them so they have average 0 and stddev 1 (mean distance from the center is sqrt(2)
% and denormalize F at the end

l=left_points';
r=right_points';
% Normalising left points
centl=mean(l, 2); %x_bar and y_bar
tl=bsxfun(@minus,l, centl);

% compute the scale to make mean distance from centroid sqrt(2)
meanl=mean(sqrt(sum(tl.^2)));
if meanl>0 % protect against division by 0
    sl=sqrt(2)/meanl;
else
    sl=1;
end
T=diag(ones(1,3)*sl);
T(1:end-1,end)=-sl*centl;
T(end)=1;
if size(l,1)>2
    left_normPoints=T*l;
else
    left_normPoints=tl*sl;
end
% Normalising the right points
centr=mean(r, 2); %x_bar and y_bar
tr=bsxfun(@minus,r,centr);

% compute the scale to make mean distance from centroid sqrt(2)
meanr=mean(sqrt(sum(tr.^2)));
if meanr>0 % protect against division by 0
    sr=sqrt(2)/meanr;
else
    scaler=1;
end
T_bar=diag(ones(1,3)*sr);
T_bar(1:end-1,end)=-sr*centr;
T_bar(end)=1;
if size(r,1)>2
    right_normPoints=T_bar*r ;
else
    right_normPoints=tr*sr;
end
%% Expressing the linear equation
u=left_normPoints(1,:)';
v=left_normPoints(2,:)';
ud=right_normPoints(1,:)';
vd=right_normPoints(2,:)';

% Defining the image points in one matrix
P=[u.*ud,v.*ud,ud,u.*vd,v.*vd,vd,u,v,ones(size(u,1),1)]; 
% % Perform SVD of P
[U,S,V]=svd(P);
[min_val,min_index]=min(diag(S(1:9,1:9)));
% % m is given by right singular vector of min. singular value
m=V(1:9,min_index);
% Projection matrix reshaping
F=[m(1:3,1)';m(4:6,1)';m(7:9,1)'];
% F1=F;
% To enforce rank 2 constraint:
% Find the SVD of F: F = Uf.Df.VfT
% Set smallest s.v. of F to 0 to create D?f
% Recompute F: F = Uf.D?f.VfT
[Uf,Sf,Vf]=svd(F);
Sf(end)=0;
F=Uf*Sf*Vf';
% Denormalise F and transform back to original scale
F=T_bar'*F*T;
% % Normalize the fundamental matrix.
F=F/norm(F)
if F(end)<0
  F=-F
end
%%

% Choose a point in the left image and calculate the epipolar line in the right image
% figure,imshow(left);
% cpselect(left,right)

 load el_left;
 load el_right;
 er_right=el_right;
epi_lineR=zeros(size(el_left,1),3);
el_left(:,3)=ones(size(el_left,1),1);
for i=1:size(el_left,1)
epi_lineR(i,:)=(F*el_left(i,:)')';
epi_lineR(i,:)=epi_lineR(i,:)./epi_lineR(i,3);
end

% Plotting the epipole in right image 
al=epi_lineR(:,1);
bl=epi_lineR(:,2);
cl=epi_lineR(:,3);
xl=1:1:size(right,2);
yl=zeros(size(el_left,1),size(right,2));
figure(3),imshow(left),title('Points on the left image')
hold on, plot(el_left(:,1),el_left(:,2),'r*');hold off
figure(4),imshow(right);hold on, title('Corresponding Epipolar lines on right image')
plot(el_right(:,1),el_right(:,2),'r*');hold on
for i=1:size(al)  
    yl(i,:)=-(al(i)/bl(i)).*xl-(cl(i)/bl(i));
    figure(4),
     plot(xl(1,:),yl(i,:))
   hold on  
end

%%
% Choose a point in the right image and calculate the epipolar line in the left image
epi_lineL=zeros(size(er_right,1),3);
er_right(:,3)=ones(size(er_right,1),1);
for i=1:size(er_right,1)
epi_lineL(i,:)=er_right(i,:)*F;
epi_lineL(i,:)=epi_lineL(i,:)./epi_lineL(i,3);
end

% Plotting the epipole in right image 
ar=epi_lineL(:,1);
br=epi_lineL(:,2);
cr=epi_lineL(:,3);
xr=1:1:size(left,2);
yr=zeros(size(er_right,1),size(left,2));
figure(5),imshow(right),hold on,title('Points on the right image')
plot(er_right(:,1),er_right(:,2),'r*');
figure(6),imshow(left);hold on, title('Corresponding Epipolar lines on left image')
plot(el_left(:,1),el_left(:,2),'r*');
for i=1:size(ar)  
    yr(i,:)=-(ar(i)/br(i)).*xr-(cr(i)/br(i));
    figure(6)
 hold on  
     plot(xr(1,:),yr(i,:))
end 
% % % Calculate the position of the epipole of the left camera 
[~, ~, v]=svd(F);
ep=v(:, 3)';
epipole= ep(1:3)/ep(3)
%%
% Plotting the epipole along with the epipolar line in left image

figure,
xr1=1:1:(epipole(1,1)+1000);
yr1=zeros(size(er_right,1),(floor(epipole(1,1)+1000)));

figure(7),imagesc(left);hold on,title('Epipolar lines and epipoles on left image')
 plot(epipole(1,1),epipole(1,2),'r*');
 hold on 
% plot(er_left(:,1),er_left(:,2),'r*');
for i=1:size(ar)  
    yr1(i,:)=-(ar(i)/br(i)).*xr1-(cr(i)/br(i));
    figure(7)
 hold on  
     plot(xr1(1,:),yr1(i,:))
end 
xlim([1,10000])
ylim([1,4000])
