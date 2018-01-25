%% Dimension-change-experiment, framework for presentation

%% Clear the workspace and the screen 

sca;
close all;          
clearvars;
rng ('shuffle')
framed = 1; 

%% Name Subject and Make Outputfile

del = filesep;
subjectname=input('Subjectcode: ','s');
subjectnumber=input('Subjectnumber: ','s');
if str2double(subjectnumber)~=0
parameters.subject=datestr(now,30);
filename=['zz_data',del, parameters.subject,'_',subjectname(1:4),'_dat.txt'];
datafile = fopen(filename, 'wt');
parameters.datafile=datafile;
end

try
    
%% Psychtoolbox Setting

PsychDefaultSetup(2)
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
waitframes = 1;

% Retreive the maximum priority number
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% Length of time and number of frames to use
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
% ae = char(228); oe = char (246); ue = char(252); ss = char(223) 
Start = double(['\n\nHaben Sie die Aufgabe verstanden und und den ',num2str(char(220)),'bungsblock beendet? \n\nDann kann es losgehen!' ...
    '\n\n\nIm Folgenden werden Sie keine R',num2str(char(252)),'ckmeldung ',char(252),'ber die Richtigkeit Ihrer Antworten erhalten. \n\nAntworten Sie zu langsam, ert',char(246),'nt der aus dem ', num2str(char(220)),'bungsblock bekannte Warnton.' ...
    '\n\n\nBitte dr',num2str(char(252)),'cken Sie die Leertaste.']); 

Detect = double(['Geben Sie an, ob sich der mittlere Kreis von den anderen unterscheidet. \n\nLinke Taste: kein Unterschied       Rechte Taste: Unterschied \n\nAntworten Sie so schnell als m',num2str(char(246)),'glich, ohne Fehler zu machen.']);

KbQueueRelease;KbQueueCreate(1,keylist_break);  
DrawFormattedText(window, Start, 'center','center', white);
Screen('Flip',window) 
KbQueueFlush;KbQueueWait_mod;

%% Task

practice = 0;
trialnum = 150;

for block = 1:8
    
KbQueueRelease;KbQueueCreate(-1,keylist_break);  
DrawFormattedText(window, Detect, 'center','center', white);
Screen('Flip',window) 

KbQueueFlush;KbQueueWait_mod;    
b_present3_withframe

%Break text

KbQueueRelease;KbQueueCreate(-1,keylist_break);
Break1 = double(['Geschafft! Block ' ,num2str(block), ' von 8 ist zu Ende.']); 
if block < 8; Break2 = double([' Bitte machen Sie eine Pause.\n\nSobald Sie bereit f',num2str(char(252)),'r den n',num2str(char(228)) ,'chsten Block sind, dr',num2str(char(252)),'cken Sie die Leertaste.']);   
elseif block == 8; Break2 = double(['\n\nVielen Dank f',num2str(char(252)),'r Ihre Teilnahme!']);
end
DrawFormattedText(window, [Break1 Break2], 'center','center', white);
Screen('Flip',window)
KbQueueFlush;KbQueueWait_mod;

end

catch me
    
sca 

end

%% Clear the screen.
sca;
Priority(0)

%% Total Time: 40 min (5 min per block)