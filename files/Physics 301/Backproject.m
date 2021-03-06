function [HBImage] = Backproject(J,rect)
% Uses histogram backprojection to segment the input image according 
% to the ROI considered
% MSoriano 2022
% Open an image and crop a region of interest

%clear all ; close all;
BINS = 32;
% Get the r g of the whole image
    J = double(J);
    R = J(:,:,1); G = J(:,:,2); B = J(:,:,3);
    Int= R + G + B;
    Int(Int==0)=100000; %to prevent NaNs
    rJ = R./ Int; gJ = G./Int;

% Crop the region of interest in the rg space
     
    r = imcrop(rJ, rect);
    g = imcrop(gJ, rect);
    rint = round( r*(BINS-1) + 1);
    gint = round (g*(BINS-1) + 1);
    colors = gint(:) + (rint(:)-1)*BINS;
    
% Compute rg-histogram
% This is the 1-d version of a 2-d histogram
    hist = zeros(BINS*BINS,1);
    for row = 1:BINS
    for col = 1:(BINS-row+1)
    hist(col+(row-1)*BINS) = length( find(colors==( ((col + (row-1)*BINS)))));
    end
    end

% Backproject histogram
    rJint = round( rJ*(BINS-1) + 1);
    gJint = round (gJ*(BINS-1) + 1);
    colorsJ = gJint(:) + (rJint(:)-1)*BINS;
    HB = hist(colorsJ);
    HBImage = reshape(HB,size(J,[1,2]));
    %HBImage = bwareaopen(HBImage,300);
    %Bppic = imagesc(HBImage); 
    colormap (gray);
