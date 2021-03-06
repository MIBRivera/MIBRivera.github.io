
obj=webcam;
%obj.ReturnedColorspace = 'rgb';
frame=obj.snapshot;


framesAcquired = 0;
while (framesAcquired <= 120) 
    
      %data_yellow = imcomplement(obj.snapshot); 
      framesAcquired = framesAcquired + 1;    
      
% Get the r g of the whole image
    roi = double(roi);
    R = roi(:,:,1); G = roi(:,:,2); B = roi(:,:,3);
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
    HBImage = reshape(HB,size(roi,[1,2]));
    figure (2); imagesc(HBImage); 
    colormap (gray);

      
  
      % Remove all those pixels less than 300px
      diff_im = bwareaopen(diff_im,300);
    
    % Label all the connected components in the image.
     bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    %imshow(imcomplement(data_yellow))
    
    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2))), '    Color: Yellow'));
        set(a, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
    end  
 
    hold off
    
end

%clear all
