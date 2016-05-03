function [uv,N]=optical_flow(Image1,Image2)
% Calculate the temporal gradient image ?E/?t via the difference of the blurred versions of the
% two consecutive frames.
Et=double(Image2-Image1);

% Calculate the spatial derivatives Ex =?E/?x and Ey =?E/?y , simply by
% subtracting the two frames as I(x,t+1)-I(x,t).
    Ex=conv2(Image1,0.5*[-1,1],'same');
    Ey=conv2(Image1,0.5*[-1;1],'same');
    
% Display the original image and the spatial and time gradients
%  figure,
% subplot(2,2,1),imshow(Image1,[]),title('Original Image');
% subplot(2,2,2),imshow(Et,[]),title('Time gradient');
% subplot(2,2,3),imshow(Ex,[]),title('Horizontal spatial gradient');
% subplot(2,2,4),imshow(Ey,[]),title('Vertical spatial gradient');

% Calculate the normal flow at each pixel N=-Et/|grad E|
[r,c]=size(Image1);
N=zeros(r,c);
for i=1:r
    for j=1:c
        N(i,j)=-Et(i,j)/sqrt(Ex(i,j)^2+Ey(i,j)^2);
    end
end

% Display the resulting flow vectors as a 2D image. Overlay these vectors and the gray level image.
uv=zeros(r,c,2);
for i=1:r-1
    for j=1:c-1;
        A=[Ex(i,j),Ex(i,j+1),Ex(i+1,j),Ex(i+1,j+1);Ey(i,j),Ey(i,j+1),Ey(i+1,j),Ey(i+1,j+1)];
        A=A';
        Ax = A(:,1);
        Ay = A(:,2);
        b=-[Et(i,j);Et(i,j+1);Et(i+1,j);Et(i+1,j+1)];
%         uv(i,j,:)=-pinv(A'*A)*A'*b;
%         %uv(i,j,:) = - pinv(A)*b;
        uv(i,j,1) = (Ax'*Ax)\(Ax'*b);
        uv(i,j,2) = (Ay'*Ay)\(Ay'*b);
        
    end
end

