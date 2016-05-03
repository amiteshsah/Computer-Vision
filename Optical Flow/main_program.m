
clc;clear all;
close all;

% Choose two consecutive images from the video sequence
I1=imread('toy-car-images-bw/toy_formatted2.png');
I2=imread('toy-car-images-bw/toy_formatted3.png');

I1=double(I1);
I2=double(I2);

% Apply this flow calculation to a) the raw images,
[uv_raw,N_raw]=optical_flow(I1,I2);
figure,
subplot(3,2,1),imshow(I1,[]);title('Original Image 1');
subplot(3,2,2),imshow(N_raw,[]),title('Normal Vector');
subplot(3,2,3),quiver(uv_raw(:,:,1),uv_raw(:,:,2),3,'-r');
                title('resulting flow vectors for raw image');
subplot(3,2,4),quiver(uv_raw(:,:,1),uv_raw(:,:,2),3,'-r');title('Zoomed flow vector');
ylim([170 180]);
xlim([375 385]);
subplot(3,2,5),imshow(I1,[]);
hold on
quiver(uv_raw(:,:,1),uv_raw(:,:,2),3,'-r');
title('vectors over the grayimage  Raw');
hold off


%%
% b) images filtered by a Gaussian smoothing of sigma=1,
gauss_filtered_image1 = gaussian_filter(I1, 1.0);
gauss_filtered_image2 = gaussian_filter(I2, 1.0);

[uv_sig1,N_sig1]=optical_flow(gauss_filtered_image1,gauss_filtered_image2);

figure,
subplot(3,2,1),imshow(I1,[]);title('Original Image 1');
subplot(3,2,2),imshow(N_sig1,[]),title('Normal Vector');
subplot(3,2,3),quiver(uv_sig1(:,:,1),uv_sig1(:,:,2),3,'-r');
                title('resulting flow vectors for smooth image with sigma =1');
subplot(3,2,4),quiver(uv_sig1(:,:,1),uv_sig1(:,:,2),3,'-r');title('Zoomed flow vector');
ylim([170 180]);
xlim([375 385]);
subplot(3,2,5),imshow(I1,[]);
hold on
quiver(uv_sig1(:,:,1),uv_sig1(:,:,2),3,'-r');
title('vectors over the grayimage with smooth, sigma=2');
hold off


%%
% c) images filtered by a Gaussian smoothing of sigma=2. 
gauss_filtered_image11 = gaussian_filter(I1, 2.0);
gauss_filtered_image12 = gaussian_filter(I2, 2.0);

[uv_sig2,N_sig2]=optical_flow(gauss_filtered_image11,gauss_filtered_image12);

figure,
subplot(3,2,1),imshow(I1,[]);title('Original Image 1');
subplot(3,2,2),imshow(N_sig2,[]),title('Normal Vector');
subplot(3,2,3),quiver(uv_sig2(:,:,1),uv_sig2(:,:,2),3,'-r');
                title('resulting flow vectors for smooth image with sigma =2');
subplot(3,2,4),quiver(uv_sig2(:,:,1),uv_sig2(:,:,2),3,'-r');title('Zoomed flow vector');
ylim([170 180]);
xlim([375 385]);
subplot(3,2,5),imshow(I1,[]);
hold on
quiver(uv_sig2(:,:,1),uv_sig2(:,:,2),3,'-r');
title('vectors over the grayimage with smooth, sigma=2');
hold off

%% For all the 5 images
I1=double(imread('toy-car-images-bw/toy_formatted2.png'));
I2=double(imread('toy-car-images-bw/toy_formatted3.png'));
I3=double(imread('toy-car-images-bw/toy_formatted4.png'));
I4=double(imread('toy-car-images-bw/toy_formatted5.png'));
I5=double(imread('toy-car-images-bw/toy_formatted6.png'));

% Show all the 5 image
figure,
subplot(3,2,1),imshow(I1,[]);title('Original Image 1');
subplot(3,2,2),imshow(I2,[]);title('Original Image 2');
subplot(3,2,3),imshow(I3,[]);title('Original Image 3');
subplot(3,2,4),imshow(I4,[]);title('Original Image 4');
subplot(3,2,5),imshow(I5,[]);title('Original Image 5');

% images filtered by a Gaussian smoothing of sigma=1,
gauss_filtered_image1 = gaussian_filter(I1, 2.0);
gauss_filtered_image2 = gaussian_filter(I2, 2.0);
gauss_filtered_image3 = gaussian_filter(I3, 2.0);
gauss_filtered_image4 = gaussian_filter(I4, 2.0);
gauss_filtered_image5 = gaussian_filter(I5, 2.0);

% Apply this flow calculation
[uv1,N1]=optical_flow(gauss_filtered_image1,gauss_filtered_image2);
[uv2,N2]=optical_flow(gauss_filtered_image2,gauss_filtered_image3);
[uv3,N3]=optical_flow(gauss_filtered_image3,gauss_filtered_image4);
[uv4,N4]=optical_flow(gauss_filtered_image4,gauss_filtered_image5);

% Plot Normal
figure,
subplot(2,2,1),imshow(N1,[]),title('Normal Vector 1and2');
subplot(2,2,2),imshow(N2,[]),title('Normal Vector 2and3');
subplot(2,2,3),imshow(N3,[]),title('Normal Vector 3and4');
subplot(2,2,4),imshow(N4,[]),title('Normal Vector 4and5');

%Plot optical flow
figure,
subplot(4,2,1),quiver(uv1(:,:,1),uv1(:,:,2),3,'-r');title('flow vectors 1');
subplot(4,2,2),quiver(uv1(:,:,1),uv1(:,:,2),3,'-r');title('Zoomed flow vector 1');
ylim([228 238]);xlim([430 448]);
subplot(4,2,3),quiver(uv2(:,:,1),uv2(:,:,2),3,'-r');title('flow vectors 2');
subplot(4,2,4),quiver(uv2(:,:,1),uv2(:,:,2),3,'-r');title('Zoomed flow vector 2');
ylim([228 238]);xlim([430 448]);
subplot(4,2,5),quiver(uv3(:,:,1),uv3(:,:,2),3,'-r');title('flow vectors 3');
subplot(4,2,6),quiver(uv3(:,:,1),uv3(:,:,2),3,'-r');title('Zoomed flow vector 3');
ylim([228 238]);xlim([430 448]);
subplot(4,2,7),quiver(uv4(:,:,1),uv4(:,:,2),3,'-r');title('flow vectors 4');
subplot(4,2,8),quiver(uv4(:,:,1),uv4(:,:,2),3,'-r');title('Zoomed flow vector 4');
ylim([228 238]);xlim([430 448]);
% Plot overlay vector
figure,
subplot(2,2,1),imshow(I1,[]);hold on 
quiver(uv1(:,:,1),uv1(:,:,2),3,'-r');
title('vectors over the grayimage 1');
hold off

subplot(2,2,2),imshow(I1,[]);hold on 
quiver(uv2(:,:,1),uv2(:,:,2),3,'-r');
title('vectors over the grayimage 2');
hold off

subplot(2,2,3),imshow(I1,[]);hold on 
quiver(uv3(:,:,1),uv3(:,:,2),3,'-r');
title('vectors over the grayimage 3');
hold off

subplot(2,2,4),imshow(I1,[]);hold on 
quiver(uv4(:,:,1),uv4(:,:,2),3,'-r');
title('vectors over the grayimage 4');
hold off

%% Horn Schunck Method
% figure,
% j=1;
% [r,c]=size(I1);
% pc=linspace(1,c,10);
% pr=linspace(1,r,100);
% [x,y] = meshgrid(1:1:534,1:1:266);
for i=1:5:40
[u,v]=horn_schunck(gauss_filtered_image1,gauss_filtered_image2,i);

subplot(4,2,j),quiver(x,y,u,v),title(['Iteration:',num2str(i)]);
%  xlim([400 410]);
%  ylim([58 64]);
j=j+1;
end

%%
% Comparing the flow fields with the ones obtained with the simplified approach
[u,v]=horn_schunck(gauss_filtered_image1,gauss_filtered_image2,10);
[uv_simple,N_simple]=optical_flow(gauss_filtered_image1,gauss_filtered_image2);
figure,
subplot(2,2,1),quiver(u,v,3),title('Horn Schunck approach Iteration:10');
subplot(2,2,2),quiver(u,v,3),title('Zoomed Horn Schunck approach Iteration:10');
ylim([228 238]);xlim([420 448]);
 subplot(2,2,3),quiver(uv_simple(:,:,1),uv_simple(:,:,2),3);title('simple approach');
subplot(2,2,4),quiver(uv_simple(:,:,1),uv_simple(:,:,2),3);title('zoomed simple approach');
ylim([228 238]);xlim([420 448]);