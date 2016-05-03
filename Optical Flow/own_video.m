clc;clear all;
close all;

vidObj = VideoReader('video_opt2.mp4');
% Determine the height and width of the frames.
vidHeight = vidObj.Height;
vidWidth = vidObj.Width;

% Create a MATLAB® movie structure array, s.
s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
    'colormap',[]);
% Read one frame at a time using readFrame until the end of the file is reached.
% Append data from each video frame to the structure array.
k = 1;
while hasFrame(vidObj)
    s(k).cdata = readFrame(vidObj);
    k = k+1;
end
%%
I1=s(3).cdata;
I2=s(15).cdata;
I3=s(30).cdata;
I4=s(45).cdata;
I5=s(60).cdata;
%% RGB to gray 
I1=double(rgb2gray(I1));
I2=double(rgb2gray(I2));
I3=double(rgb2gray(I3));
I4=double(rgb2gray(I4));
I5=double(rgb2gray(I5));
%%
% Show all the 5 image
figure,
subplot(3,2,1),imshow(I1,[]);title('Original Image 1');
subplot(3,2,2),imshow(I2,[]);title('Original Image 2');
subplot(3,2,3),imshow(I3,[]);title('Original Image 3');
subplot(3,2,4),imshow(I4,[]);title('Original Image 4');
subplot(3,2,5),imshow(I5,[]);title('Original Image 5');
%%
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
%%
%Plot optical flow
figure,
subplot(4,2,1),quiver(uv1(:,:,1),uv1(:,:,2),3,'-r');title('flow vectors 1');
subplot(4,2,2),quiver(uv1(:,:,1),uv1(:,:,2),3,'-r');title('Zoomed flow vector 1');
ylim([650 750]);xlim([800 900]);
subplot(4,2,3),quiver(uv2(:,:,1),uv2(:,:,2),3,'-r');title('flow vectors 2');
subplot(4,2,4),quiver(uv2(:,:,1),uv2(:,:,2),3,'-r');title('Zoomed flow vector 2');
ylim([650 750]);xlim([800 900]);
subplot(4,2,5),quiver(uv3(:,:,1),uv3(:,:,2),3,'-r');title('flow vectors 3');
subplot(4,2,6),quiver(uv3(:,:,1),uv3(:,:,2),3,'-r');title('Zoomed flow vector 3');
ylim([650 750]);xlim([800 900]);
subplot(4,2,7),quiver(uv4(:,:,1),uv4(:,:,2),3,'-r');title('flow vectors 4');
subplot(4,2,8),quiver(uv4(:,:,1),uv4(:,:,2),3,'-r');title('Zoomed flow vector 4');
ylim([650 750]);xlim([800 900]);
%%
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