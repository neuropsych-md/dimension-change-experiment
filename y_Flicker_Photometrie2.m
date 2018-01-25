%% Flicker Photometrie to adjust colours

% Let two colours flicker at highest possible rate
% Keep one colour constant and let the other be adjusted by the participant
% Instruct participant to adjust until no more flicker visible
% Use the constant and adjusted colour for presentation

%% Psychtoolbox Settings

% Clear the workspace and the screen 
sca;
close all;          
clearvars;
rng ('shuffle')

PsychJavaTrouble()

Subjectname = input('Subjectname: ','s');

% Psychtoolbox Settings
PsychDefaultSetup(2);
PsychGPUControl('SetGPUPerformance', 10);
screens =  Screen('Screens');screenNumber = max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Colours

colours = [0.7468 0.3797 0.2810;0.2610 0.4354 0.1693; 0.1312 0.1113 0.8445]; %red, green, blue;
colours_is = z_makeiso3(colours); %start with artificially adapted colours
colours_is = colours; %start with original colours

red = colours_is(1,:);redlum = rgb2ntsc(red);
green = colours_is(2,:);greenlum = rgb2ntsc(green);
blue = colours_is(3,:);bluelum = rgb2ntsc(blue);

keylist = zeros(1,256);
keylist(KbName('RightArrow'))=1;
keylist(KbName('LeftArrow'))=1; 
keylist(KbName('Space'))=1;

try

    % Open an on screen window using PsychImaging and color it red
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, black,[],32,2,...
        [],[],kPsychNeed32BPCFloat); 

    HideCursor(0,0)

    % Get the size of the on screen window in pixels and center coordinates
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect) %#ok<NOPTS>

    % Enable alpha blending for anti-aliasing
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Measure the vertical refresh rate of the monitor
    ifi = Screen('GetFlipInterval', window);

    % Instructions
    % ae = char(228/196); oe = char (246/214); ue = char(252/220); ss = char(223) -> check XML character entity reference

    Inst = double(['Vielen Dank f',num2str(char(252)), 'r Ihre Teilnahme an diesem Experiment! ' ...
        '\n\n\nBevor es losgeht, beginnen wir mit einer kurzen Kalibrierung.' ...
        '\n\n\nIm Folgenden sehen Sie einen leicht flickernden Bildschirm. \n\nDen Flicker k',num2str(char(246)),'nnen Sie mit der linken und rechten Pfeiltaste anpassen.', ...
        '\n\nWenn Sie den Punkt gefunden haben, an dem Sie den Flicker am wenigsten wahrnehmen \n\n(sowohl bei linkem als auch rechtem Tastendruck vergr',num2str(char(246)),num2str(char(223)),'ert er sich),' ... 
        '\n\ndr',num2str(char(252)),'cken Sie bitte die Leertaste. ']);

    % Run Photometry till key is pressed

    KbQueueCreate(-1,keylist);  
    Screen('FillRect', window, black);
    DrawFormattedText(window, Inst, 'center','center', white);
    Screen('Flip',window) 
    KbQueueFlush;KbQueueWait_mod;

    KbQueueCreate(-1,keylist);
    KbQueueStart;ttpress = zeros(1,256);

    for round = 1:2

        nn = 1;
        clear vbl
        Screen('FillRect', window, green);
        tt = GetSecs;
        vbl(1) = Screen('Flip', window, tt + 0.5 * ifi,2);f=1;

        switch round 
            case 1
            switchlum = redlum;
            case 2 
            switchlum = bluelum;
        end
        
        startlum = switchlum(1);

        ttpress = zeros(1,256);

        while ttpress(KbName('Space')) == 0  

            nn = nn+1;
            ttpress = zeros(1,256);
            [press,ttpress] = KbQueueCheck;

            if ttpress(KbName('RightArrow')) ~= 0
               if switchlum(1) < startlum + 8*0.025; switchlum(1) = switchlum(1) + 0.025; end
            elseif ttpress(KbName('LeftArrow')) ~= 0
               if switchlum(1) > startlum - 8*0.025; switchlum(1) = switchlum(1) - 0.025;end
            end

            switchcol = ntsc2rgb(switchlum);

                switch f
                    case 1
                    % Color the screen in alternating colours
                    Screen('FillRect', window, switchcol);f=2;
                    case 2
                    % Color the screen in alternating colours
                    Screen('FillRect', window, green);f=1;
                end

                % Flip to the screen
                vbl(nn) = Screen('Flip', window, vbl(nn-1) + 0.5*ifi,2); 

        end

        switch round;
            
        case 1
            redlum = switchlum;
            timingtest1=vbl(2:end)-vbl(1:end-1);
        case 2
            bluelum = switchlum;
            timingtest2=vbl(2:end)-vbl(1:end-1);
        end

        col.green = ntsc2rgb(greenlum);
        col.red = ntsc2rgb(redlum);
        col.blue = ntsc2rgb(bluelum);

    end

    save(['zz_data/colours_',Subjectname],'col')

    KbQueueStop

catch me

    sca
 
end                 

% Clear the screen.
sca;
Priority(0)


 