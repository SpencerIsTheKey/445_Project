BG = zeros(1080,1920); 
catit = zeros(1080,1920);
% black background (my webcam is 480x640) 
% Segment FG and update background every frame 
thresh = 0.06; 
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
    % Uncomment ONLY ONE of the imshow 
    %imshow(BG);        
    % show background being slowly updated 
    
    frame(:,:,1) = (frame(:,:,1)+FG_mask);
    imshow(frame);   
    % show mask with moving object only 
    %imshow(FG);  
    % show moving objects 
    % update BG 
    BG = 0.95 * BG + 0.05 * bwframe; 
end
