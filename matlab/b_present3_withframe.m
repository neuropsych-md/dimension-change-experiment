%% Dimension-change-experiment, Stimulus presentation

global cogent
address = hex2dec('D010');

%to signify a new block
if str2double(subjectnumber) ~= 0; blocktrig = 192 + block; else blocktrig = 192;end
io64(cogent.io.ioObj,address,blocktrig);WaitSecs(0.005); %or use outp(address,trialtrig(j)), but this is quicker
io64(cogent.io.ioObj,address,0);WaitSecs(0.005);

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
    gratcolours = [0.7468 0.3797 0.2810;0.2610 0.4354 0.1693; 0.1312 0.1113 0.8445]; %red, green, blue
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

locationMat = [leftmiddle;rightmiddle];

% Fixation Cross
fixCrossDimPix = 40;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];allCoords = [xCoords; yCoords];
lineWidthPix = 4;

% Keypresses
keylist = zeros(1,256);keylist(KbName('RightArrow'))=1;keylist(KbName('LeftArrow'))=1; % 79 = right arrow, 80 = left arrow, see KbName
keylist_break = zeros(1,256);keylist_break(KbName('Space'))=1;

% Properties matrix
propertiesMat = [phase, freq, sigma, contrast, aspectRatio, 0, 0, 0];

% Sound
[pahandle,buffer_complete,ending] = z_beepiteg([300,300],[0 0],.05,[1 1],0.05,44100,.01);

%% Make Randomization

a = [1;2;3]; randmat_target = repmat(a,(trialnum*0.7)/3,1); % 1 - repeat, 2 - within-dimension-change, 3 - between-dimension-change 
randmat = [zeros(trialnum * 0.3,1); randmat_target];
rr = randperm(length(randmat));

%% Make Presentation Matrix
    
clear colour_choice
clear orient_choice
clear whatchanged
clear dualorint

KbQueueCreate(-1,keylist); % negative device number will use default device 
        
for i = 1:length(randmat) 
    
    whatchanged(i) = randmat(rr(i)); %#ok<SAGROW>
    nn = find(randmat(rr(1:i-1)),1,'last');

    if randmat(rr(i)) == 0  %no target
        trialtrig(i) = 64;
        colour_choice(i) = 3;orient_choice(i) = 3; %#ok<SAGROW> 

    elseif randmat(rr(i)) == 1 %repeat
        trialtrig(i) = 8;
        if isempty(nn);
            f=round(rand); if f==1;colour_choice(i) = round(1+rand);orient_choice(i) = 3;elseif f==0;colour_choice(i) = 3;orient_choice(i) = round(1+rand);end %#ok<SAGROW>
        else
            colour_choice(i) = colour_choice(nn);orient_choice(i) = orient_choice(nn);  %#ok<SAGROW>
        end

    elseif randmat(rr(i)) == 2 %within-dimension
        trialtrig(i) = 16;
        if isempty(nn);
             f=round(rand); if f==1;colour_choice(i) = round(1+rand);orient_choice(i) = 3;elseif f==0;colour_choice(i) = 3;orient_choice(i) = round(1+rand);end %#ok<SAGROW>
        else
             intdim = find([colour_choice(nn) orient_choice(nn)] ~= 3);
             if intdim == 1;
                if colour_choice(nn)==1;colour_choice(i) = 2; elseif colour_choice(nn)==2;colour_choice(i) =1;end %#ok<SAGROW>
                orient_choice(i) = 3; %#ok<SAGROW>
             elseif intdim == 2; 
                if orient_choice(nn)==1;orient_choice(i) = 2; elseif orient_choice(nn)==2;orient_choice(i) =1;end %#ok<SAGROW>
                colour_choice(i) = 3; %#ok<SAGROW>
             end
        end

    elseif randmat(rr(i)) == 3 %between-dimension
        trialtrig(i) = 32;
        if isempty(nn);
             f=round(rand); if f==1;colour_choice(i) = round(1+rand);orient_choice(i) = 3;elseif f==0;colour_choice(i) = 3;orient_choice(i) = round(1+rand);end %#ok<SAGROW>
        else
             intdim = find([colour_choice(nn) orient_choice(nn)] ~= 3);
             if intdim == 1;
                colour_choice(i) = 3; orient_choice(i) = round(1+rand); %#ok<SAGROW>
             elseif intdim == 2; 
                 orient_choice(i) = 3; colour_choice(i) = round(1+rand); %#ok<SAGROW>  
             end

        end

    end
      
    if orient_choice(i) == 3 && colour_choice(i) == 3; stimtrig(i) = 0;
    elseif colour_choice(i) == 1; stimtrig(i) = 1; elseif colour_choice(i) == 2; stimtrig(i) = 2; ...
    elseif orient_choice(i) == 1; stimtrig(i) = 4; elseif orient_choice(i) == 2; stimtrig(i) = 6; 
    else display('trigger problem !!'); here_is_an_error;
    end

end   

%% Start loop and set triggers

starttime = GetSecs; 
vbl_blank = Screen('Flip', window, starttime + 1 - 0.5*ifi);

for j = 1:length(randmat)
    
    finaltrig = trialtrig(j) + stimtrig(j);

    io64(cogent.io.ioObj,address,finaltrig);WaitSecs(0.005); %or use outp(address,trialtrig(j)), but this is quicker
    io64(cogent.io.ioObj,address,0);WaitSecs(0.005);

    KbQueueFlush;

    clear press
    clear ttpress
    clear RTcall

    colour = gratcolours(colour_choice(j),:); 
    orientation = gratorient(orient_choice(j));

%% Fixation Cross

    % Draw Fixation Cross
    Screen('DrawLines', window, allCoords,...
    lineWidthPix, [0.3, 0.3, 0.3], [xCenter yCenter], 2);

    % Flip Fixation Cross
    [vbl_fix, stimonset_fix, flip_fix, missed_fix, beampos_fix] = Screen('Flip', window, vbl_blank + 1.0020 - 0.5*ifi); 
    io64(cogent.io.ioObj,address,1); WaitSecs(0.005); 
    io64(cogent.io.ioObj,address,0); WaitSecs(0.005)
    time_blank = vbl_fix-vbl_blank;

%% Stimulus 

    % Draw Distractor Stimuli, location = [Rect left, Rect top, Rect right,Rect bottom]
    Screen('DrawTextures', window, gabortex, [], locationMat', gratorient(3), [], [], gratcolours(3,:), [],...
        kPsychDontDoRotation, propertiesMat');

    % Draw Target Stimulus
    Screen('DrawTextures', window, gabortex, [], CenterCoords, orientation, [], [], colour, [],...
         kPsychDontDoRotation, propertiesMat');
             
    % Flip Target Stimulus
    [vbl_stim, stimonset_stim, flip_stim, missed_stim, beampos_stim] = Screen('Flip', window, vbl_fix + 0.8016 - 0.5*ifi);
    io64(cogent.io.ioObj,address,2); WaitSecs(0.005); 
    io64(cogent.io.ioObj,address,0); WaitSecs(0.005)
    time_fixcross = vbl_stim-vbl_fix;

    ttbase = vbl_stim;
    KbQueueStart; %79 = right, 80 = left

%% Response

    % Flip to Black Screen
    [vbl_blank, stimonset_blank, flip_blank, missed_blank, beampos_blank] = Screen('Flip', window, vbl_stim + 0.2004 - 0.5*ifi);
    io64(cogent.io.ioObj,address,4);WaitSecs(0.005); %or use outp(address,trialtrig(j)), but this is quicker
    io64(cogent.io.ioObj,address,0); WaitSecs(0.005)
    time_stimpress = vbl_blank-vbl_stim;
    
    WaitSecs(0.7);[press,ttpress] = KbQueueCheck;KbQueueStop;
    if press == 0; 
        PsychPortAudio('Start', pahandle,1,0,0)
        if practice == 1; DrawFormattedText(window, 'Zu Langsam', 'center','center', white);Screen('Flip', window,vbl_blank + 0.85 - 0.5*ifi);end
    end
    
%% Record Response

    if press == 0;Response(j,block) = nan;RT(j,block)=999; %#ok<SAGROW>
        responsetrig = 128;  
    elseif ttpress(KbName('RightArrow')) ~= 0 && ttpress(KbName('LeftArrow')) ~= 0; Response(j,block) = 159;RT(j,block)=999; %#ok<SAGROW>
        responsetrig = 6;
    else
        if ttpress(KbName('RightArrow')) ~= 0; Response(j,block) = 2; RTcall = KbName('RightArrow'); %#ok<SAGROW>
            responsetrig = 129;
        elseif ttpress(KbName('LeftArrow')) ~= 0; Response(j,block) = 1;RTcall = KbName('LeftArrow'); %#ok<SAGROW>
            responsetrig = 130;
        end
        RT(j, block) = ttpress(RTcall)-ttbase; %#ok<SAGROW>
    end

    io64(cogent.io.ioObj,address,0);WaitSecs(0.005); %or use outp(address,trialtrig(j)), but this is quicker
    io64(cogent.io.ioObj,address,responsetrig);WaitSecs(0.005); 
    io64(cogent.io.ioObj,address,0);WaitSecs(0.005);

    if Response(j,block) == 2 %right = change

        if whatchanged(j) == 0 
            Correct(j,block) = 0; %#ok<SAGROW>
        elseif whatchanged(j) > 0
            Correct(j,block) = 1; %#ok<SAGROW>
        end

    elseif Response(j,block) == 1 %left = no change

        if whatchanged(j) == 0
            Correct(j,block) = 1; %#ok<SAGROW>
        elseif whatchanged(j) > 0
            Correct(j,block) = 0; %#ok<SAGROW>
        end

    else

        Correct(j,block) = nan; %#ok<SAGROW>

    end

    if practice == 1; if Correct(j,block) == 1;DrawFormattedText(window, 'Richtig', 'center','center', white);Screen('Flip', window);end
                      if Correct(j,block) == 0;DrawFormattedText(window, 'Falsch', 'center','center', white);Screen('Flip', window);end;
                      if Response(j,block) == 159;DrawFormattedText(window, 'Falsch', 'center','center', white);Screen('Flip', window);end;
    end

    if str2double(subjectnumber) ~= 0 
    bytes = fprintf (parameters.datafile,...
                    ['%5.0f                      %5.0f  %5.0f  %5.0f           %5.0f             %5.0f             %5.0f              %5.3f        %5.3f             %5.3f       %5.3f          %5.3f\n'],...
                      str2double(subjectnumber), block, j,     whatchanged(j), colour_choice(j), orient_choice(j), Response(j,block), RT(j,block), Correct(j,block), time_blank, time_fixcross, time_stimpress) ; %#ok<NBRAK
    end

end
