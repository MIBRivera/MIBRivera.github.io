%% Face Detection in a Video
% This example uses the Viola-Jones Algorithm to detect a face in the
% video. It shows how to read, write, process and display videos.
% Copyright 2018 The MathWorks, Inc.
clear all; close all;
%% Read a video into MATLAB
videoFileReader = VideoReader('pexels-ron-lach-7653591.mp4');
myVideo = VideoWriter('myFile.mp4');
depVideoPlayer = vision.DeployableVideoPlayer;
% Initialize the Detector
faceDetector = vision.CascadeObjectDetector();
open(myVideo);
%% For live video face classification
cam = webcam;
myVideo = VideoWriter('livetracker.mp4');
depVideoPlayer = vision.DeployableVideoPlayer;
% Initialize the Detector
faceDetector = vision.CascadeObjectDetector();
open(myVideo);
%% Detect faces per snapshot of the live camera
for i = 1:120 % number of snapshots; for a 60 fps camera, this takes 2 seconds
 img = cam.snapshot; %save snapshots per frame
 bbox = faceDetector(img);
    % Insert a box around the detected face
 img = insertShape(img, 'Rectangle', bbox); 
    % Display video
 depVideoPlayer(img);
    % Write frame to a video
 writeVideo(myVideo, img);
    %pause(1/videoFileReader.FrameRate);
end
close(myVideo)
%% Detect faces in each frame
while hasFrame(videoFileReader)
    videoFrame = readFrame(videoFileReader);
    % Detect the face 
    bbox = faceDetector(videoFrame);
    % Insert a box around the detected face
    videoFrame = insertShape(videoFrame, 'Rectangle', bbox); 
    % Display video
    depVideoPlayer(videoFrame);
    % Write frame to a video
    writeVideo(myVideo, videoFrame);
    %pause(1/videoFileReader.FrameRate);
end
close(myVideo)


