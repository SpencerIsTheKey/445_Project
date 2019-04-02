BG = zeros(1080,1920); 
catit = zeros(1080,1920);
thresh = 0.25; 
%read in our video
videoReader = vision.VideoFileReader('skihill.mp4'); 

s = strel('disk',4);
while ~isDone(videoReader) 
    %get our frame but keep it in rgb
    frame = im2double(step(videoReader));
    %have another variable store the bw of frame for the background
    bwframe = rgb2gray(frame);
    %find difference between background and frame
    diff = imabsdiff(bwframe,BG); 
    %open to reduce noise
    diff = imopen(diff,s);
    
    %only get strong pixels, and apply that to the bw frame
    FG_mask = diff > thresh; 
    FG = bwframe .* FG_mask; 
    %reduce noise again
    FG = imopen(FG,s);
    
    %show the moving FG
    %imshow(FG);
    
    %apply a filter to only get the most recent moving objects
    FGmove = FG <0.5 & FG>0;
    %imshow(FGmove);        
    
    %find the blobs and their properties
    [a,b] = bwlabel(FGmove);
    props = regionprops(a);
    
    %add the moving to the red component and show the frame
    frame(:,:,1) = (frame(:,:,1)+FGmove);
    imshow(frame);
    
    %put bounding boxes around blobs that are greater than a certain size
    %commented out because rectangles were not drawing for some reason
    %count =0;
    %for i =1:length(props)
    %    if props(i).Area >200
    %        rectangle('Position', props(i).BoundingBox, 'EdgeColor','r');
    %        count = count+1;
    %    end
    %end
    %text('string',sprintf('There are %f skiiers',count),'position',[10,10],'color','b');
    
    %unimplemented feature would be to apply connected components as a
    %skiier/boarder in the video is typically a single color with a white
    %background we could find all neighbor pixels in that pixel value range
    %and expand it to fill the whole skiiers body even if only part of the
    %skiier moves. Obvious weaknesses of this is if part of the hill gets
    %detected, and it expands over all the snow. Skiier is wearing multiple
    %colors, and Skiier matches part of the background that part of the
    %background will become highlighted
     
    % update BG 
    BG = 0.99 * BG + 0.01 * bwframe; 
end
