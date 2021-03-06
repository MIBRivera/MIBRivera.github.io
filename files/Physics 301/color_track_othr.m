close all;clear all;clc;
vid=webcam;
%set(vid,'TriggerRepeat',Inf,'ReturnedColorSpace', 'RGB');
%vid.returnedcolorspace='rgb';
%vid.FrameGrabInterval=2;

%start(vid)
FramesAcquired = 0;
while(FramesAcquired<=240)
    FramesAcquired = FramesAcquired+1;
    data1=vid.snapshot;
    data=imcomplement(data1);
    diff_im = imsubtract(data(:,:,3), rgb2gray(data));
    diff_im=medfilt2(diff_im,[3 3]);
    diff_im=im2bw(diff_im,0.1);
    diff_im=bwareaopen(diff_im,50);
    bw=bwlabel(diff_im,8);
    stats=regionprops(bw,'BoundingBox','Centroid');
    
    imshow(data1)
     hold on
     for object=1:length(stats)
         bb=stats(object).BoundingBox;
         bc=stats(object).Centroid;
         rectangle('Position',bb,'EdgeColor','Y','LineWidth',2);
         plot(bc(1),bc(2),'-m+');
         a=text(bc(1)+15,bc(2), strcat('X:', num2str(round(bc(1))), 'Y:', num2str(round(bc(2)))));
         set(a, 'FontName', 'Arial', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'Green');
     end
     
    hold off
   
    
   
end
stop(vid)