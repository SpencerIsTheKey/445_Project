BG = zeros(1080,1920); 
catit = zeros(1080,1920);
% black background (my webcam is 480x640) 
% Segment FG and update background every frame 
thresh = 0.25; 
videoReader = vision.VideoFileReader('skihill.mp4'); 
% threshold for 0..1 grayscale 
s = strel('disk',4);
while ~isDone(videoReader) 
    frame = im2double(step(videoReader));
    bwframe = rgb2gray(frame);
    diff = imabsdiff(bwframe,BG); 
    diff = imopen(diff,s);
    
    FG_mask = diff > thresh; 
    FG = bwframe .* FG_mask; 
    FG = imopen(FG,s);
    % Uncomment ONLY ONE of the imshow 
    %only moving
    FGmove = FG <0.5 & FG>0;
    %imshow(FGmove);        
    % show background being slowly updated 
    [a,b] = bwlabel(FGmove);
    props = regionprops(a);
    frame(:,:,1) = (frame(:,:,1)+FGmove);
    imshow(frame);
    
    % show mask with moving object only 
    %imshow(FG);  
    % show moving objects 
    % update BG 
    BG = 0.99 * BG + 0.01 * bwframe; 
end
