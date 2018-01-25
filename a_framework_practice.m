%% Dimension-change-experiment, framework for practice block

%% Clear the workspace and the screen 
sca;
close all;          
clearvars;
rng ('shuffle')
framed = 1; 

%% Name Subject and Make Outputfile

subjectname=input('Subjectcode: ','s');

del = filesep;
subjectnumber='0';
if str2double(subjectnumber)~=0
parameters.subject=datestr(now,30);
filename=['zz_data',del, parameters.subject,'_',subjectname(1:4),'_dat.txt'];
datafile = fopen(filename, 'wt');
parameters.datafile=datafile;     
end

try
    
%% Psychtoolbox Settings

PsychDefaultSetup(2);
screens = Screen('Screens');screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber); 

%% Open window

% Open an on screen window 
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black,[],32,2,...
    [],[],kPsychNeed32BPCFloat);

HideCursor(0,0);

% Get the size of the on screen window in pixels and center coordinates
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect) %#ok<NOPTS>

% Measure the vertical refresh rate of the monitor
ifi = Screen('GetFlipInterval', window);

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window);

% Length of time and number of frames we will use 
numSecs = 1;
numFrames = round(numSecs / ifi);

% Numer of frames to wait 
waitframes = 1;

% Enable alpha blending for anti-aliasing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Keypresses
keylist = zeros(1,256);keylist(KbName('RightArrow'))=1;keylist(KbName('LeftArrow'))=1; 
keylist_break = zeros(1,256);keylist_break(KbName('Space'))=1; 

%% Instructions
% ae = char(228/196); oe = char (246/214); ue = char(252/220); ss = char(223) 
Intro = double(['Vielen Dank, dass Sie sich f',num2str(char(252)),'r die Teilnahme an dieser Studie bereit erkl',num2str(char(228)),'rt haben! \n\n\nSie werden im Folgenden eine Reihe von Anordnungen aus jeweils drei  Kreisen sehen. \n\nDie ',num2str(char(228)),'u',num2str(char(223)),'eren sind immer identisch.', ...  
    '\n\nBitte geben Sie f',num2str(char(252)),'r jede Anordnung an, ob der mittlere Kreis sich von den anderen unterscheidet. \n\n\nDr',num2str(char(252)),'cken Sie die Leertaste f',num2str(char(252)),'r ein Beispiel.']); 

Examples = double(['Alles klar? Dann startet nun der ',num2str(char(220)),'bungsblock.',...
    '\n\n\nGeben Sie an, ob sich der mittlere Kreis von den anderen unterscheidet. \n\nLinke Taste: kein Unterschied       Rechte Taste: Unterschied', ...
    '\n\nBitte antworten Sie so schnell als m',char(246),'glich, ohne Fehler zu machen. \n\n\nBeginnen Sie mit der Leertaste.']);

KbQueueRelease;KbQueueCreate(-1,keylist_break);  
DrawFormattedText(window, Intro, 'center','center', white);
Screen('Flip',window) 
KbQueueFlush;KbQueueWait_mod;

c_present3_examples

KbQueueRelease;KbQueueCreate(-1,keylist_break);  
DrawFormattedText(window, Examples, 'center','center', white);
Screen('Flip',window) 
KbQueueFlush;KbQueueWait_mod;

%% Task

block = 1;
practice = 1;
trialnum = 30;
Correct = 0;

while mean(Correct) < 0.8
 
b_present3_withframe

Correct(isnan(Correct)) = 0; %#ok<SAGROW>
 
end

%Break text

KbQueueRelease;KbQueueCreate(-1,keylist_break);
Break = double(['Geschafft! Der ',num2str(char(220)), 'bungsblock ist zu Ende.']); 
DrawFormattedText(window, Break, 'center','center', white);
Screen('Flip',window)
KbQueueFlush;KbQueueWait_mod;

catch me
    
sca 

end

%% Clear the screen.
sca;
Priority(0)

%% Total Time: few minutes

% ListenChar(0)