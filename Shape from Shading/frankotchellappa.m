function z = frankotchellappa(dzdx,dzdy)
    
    if ~all(size(dzdx) == size(dzdy))
      error('Gradient matrices must match');
    end

    [rows,cols] = size(dzdx);
    
%     The following sets up matrices specifying frequencies in the x and y
%     directions corresponding to the Fourier transforms of the gradient
%     data.  They range from -0.5 cycles/pixel to + 0.5 cycles/pixel. The
%     fiddly bits in the line below give the appropriate result depending on
%     whether there are an even or odd number of rows and columns
    
    [wx, wy] = meshgrid(([1:cols]-(fix(cols/2)+1))/(cols-mod(cols,2)), ...
			([1:rows]-(fix(rows/2)+1))/(rows-mod(rows,2)));
    
    % Quadrant shift to put zero frequency at the appropriate edge
    wx = ifftshift(wx); wy = ifftshift(wy);

    DZDX = fft2(dzdx);   % Fourier transforms of gradients
     DZDY = fft2(dzdy);
% 
%     Integrate in the frequency domain by phase shifting by pi/2 and
%     weighting the Fourier coefficients by their frequencies in x and y and
%     then dividing by the squared frequency.  eps is added to the
%     denominator to avoid division by 0.
%     
    Z = (-j*wx.*DZDX -j*wy.*DZDY)./(wx.^2 + wy.^2 + eps);  % Equation 21
    
    z = real(ifft2(Z));  % Reconstruction
end