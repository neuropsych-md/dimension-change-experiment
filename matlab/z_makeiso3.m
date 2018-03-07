function[gratcolours]= z_makeiso3(gratcolours_input)

gratcolours = gratcolours_input; 
gratcoloursntsc = rgb2ntsc(gratcolours);
gratcoloursntsc2 = [0 0 0;0 0 0;0 0 0];

while ~all(all(round(gratcoloursntsc*10000)/10000 == round(gratcoloursntsc2*10000)/10000))
    
gratcoloursntsc = rgb2ntsc(gratcolours);gratcoloursntsc(:,1) = mean(gratcoloursntsc(:,1));
gratcolours = ntsc2rgb(gratcoloursntsc); %red, green, light blue, purple -> isoluminant
gratcoloursntsc2 = rgb2ntsc(gratcolours);

end