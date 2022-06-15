video = VideoReader("pexels-ron-lach-7653591.mp4");
figure(1); imshow(rgb2gray(readFrame(video)));