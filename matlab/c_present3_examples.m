%% Dimension-change-experiment, static Stimulus presentation for instructions

%% Define Stimuli

% Dimension
gaborDimPix = windowRect(4)/2;
CenterCoords = [xCenter - gaborDimPix/2,yCenter - gaborDimPix/2, xCenter + gaborDimPix/2, yCenter + gaborDimPix/2]; %[x left, y up, x right, y down]

% Sigma of Gaussian
sigma = gaborDimPix/5;

% Color and orientation
cd zz_data
if exist(['colours_',subjectname,'.mat'],'file') == 2;
load(['colours_',subjectname])
gratcolours = [col.red;col.green;col.blue];
cd ../
else
cd ../
gratcolours = [0.7468 0.3797 0.2810;0.2610 0.4354 0.1693; 0.1312 0.1113 0.8445]; %red, green, blue; %red, green, blue
gratcolours = z_makeiso3(gratcolours);
end

gratorient = [45,135,90]; %left diagonal, right diagonal, straight

% Other Parameters 
contrast = 1;                
aspectRatio = 1.0;
phase = 0; 

% Spatial Frequency                 
numCycles = 15;
freq = numCycles/gaborDimPix;

% Procedural Texture
backgroundOffset = [0 0 0 1];
disableNorm = 1;
preContrastMultiplier = 0.5;

gabortex = CreateProceduralGabor(window, gaborDimPix, gaborDimPix, [],...
    backgroundOffset, disableNorm, preContrastMultiplier);

% Positions
distance = 600;
leftmiddle = [CenterCoords(1)-distance,CenterCoords(2), CenterCoords(3)-distance, CenterCoords(4)];
centermiddle = [CenterCoords(1),CenterCoords(2), CenterCoords(3), CenterCoords(4)];
rightmiddle = [CenterCoords(1)+distance,CenterCoords(2), CenterCoords(3)+distance, CenterCoords(4)];
leftup = [CenterCoords(1)-distance,CenterCoords(2)-distance, CenterCoords(3)-distance, CenterCoords(4)-distance];

locationMat = [leftmiddle;rightmiddle];

% Properties matrix
propertiesMat = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];

colour = gratcolours(round(rand)+1,:); 
orientation = gratorient(round(rand)+1);

%% No Change

% Draw Distractor Stimuli, location = [Rect left, Rect top, Rect right,Rect bottom]
Screen('DrawTextures', window, gabortex, [], locationMat', gratorient(3), [], [], gratcolours(3,:), [],...
    kPsychDontDoRotation, propertiesMat');

% Draw Target Stimulus
Screen('DrawTextures', window, gabortex, [], CenterCoords, gratorient(3), [], [], gratcolours(3,:), [],...
     kPsychDontDoRotation, propertiesMat');
 
% Draw Text
sol1 = ('Der mittlere Kreis unterscheidet sich nicht: Linke Taste');
DrawFormattedText(window, sol1, leftup(1)+70,leftup(3)-450, white);
             
% Flip Target Stimulus
Screen('Flip', window);

KbStrokeWait

%% Stimulus Orientation Change

% Draw Distractor Stimuli, location = [Rect left, Rect top, Rect right,Rect bottom]
Screen('DrawTextures', window, gabortex, [], locationMat', gratorient(3), [], [], gratcolours(3,:), [],...
    kPsychDontDoRotation, propertiesMat');

% Draw Target Stimulus
Screen('DrawTextures', window, gabortex, [], CenterCoords, orientation, [], [], gratcolours(3,:), [],...
     kPsychDontDoRotation, propertiesMat');
 
% Draw Text
sol2 = ('Der mittlere Kreis unterscheidet sich: Rechte Taste');
DrawFormattedText(window, sol2, leftup(1)+70,leftup(3)-450, white);
             
% Flip Target Stimulus
Screen('Flip', window);

KbStrokeWait

%% Stimulus Colour Change

% Draw Distractor Stimuli, location = [Rect left, Rect top, Rect right,Rect bottom]
Screen('DrawTextures', window, gabortex, [], locationMat', gratorient(3), [], [], gratcolours(3,:), [],...
    kPsychDontDoRotation, propertiesMat');

% Draw Target Stimulus
Screen('DrawTextures', window, gabortex, [], CenterCoords, gratorient(3), [], [], colour, [],...
     kPsychDontDoRotation, propertiesMat');
 
% Draw Text
sol2 = ('Der mittlere Kreis unterscheidet sich: Rechte Taste');
DrawFormattedText(window, sol2, leftup(1)+70,leftup(3)-450, white);
             
% Flip Target Stimulus
Screen('Flip', window);

KbStrokeWait

