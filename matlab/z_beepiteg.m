function [pahandle,buffer_complete,ending]=z_beepiteg(varargin)

% uses sound to play a sinusoids with choosen delay
%
% Usage: zbeepiteg(signalfrequency,delay,duration,amplitude,totalduration,[Fs],[smoothingtime],[1])
%
% Example:
% 
% Fs = 44100;   
% f = [1500 1500];
% delay = [0.3 0.3;0.9 0.9;1.2 1.2];
% amp = [1 1;1 1;1 1];
% 
% beepit_trigger(f,delay,.2,amp,2,Fs,.001)

% Input:
%   1- signalfrequency    Beginning frequency of the sinusoidal signal
%   2- delay         In seconds from time=0 to beginning of sinusoid; 0 asap (only 1 signal)
%   3- duration      Of the sinusoid only
%   4- amplitude     Amplitude of the sinusoid
%   5- totalduration [opt] Of the signal in seconds (including delay)
%   6- Fs            [opt] Sampling frequency (default 44100)
%   7- smoothingTime [opt] Rising and decaying time of the sinusoid (it's in seconds, but it defaults to 1 sample, does not increase sinusoid duration)

% for windows: if used multiple times in a loop, clear functions in between!!!

%% Getting the right settings %%%%%

GetSecs

tic
channels_used=2;
ending=false;

signalfrequency=varargin{1};

delay_all=varargin{2};

numbersignals_all=size(delay_all,1);

if max(size(delay_all,2))==1;
    delay_all=repmat(delay_all,numbersignals_all,channels_used);
end

if size(signalfrequency,1)==1
    signalfrequency=repmat(signalfrequency,numbersignals_all,1);
end

duration=varargin{3};
if max(size(duration,2))==1;
    duration=repmat(duration,1,channels_used);
end
if max(size(duration,1))==1
    duration = repmat(duration,numbersignals_all,1);
end

amplitude=varargin{4};
if varargin{5}>0
    durationtotal=varargin{5}; %#ok<NASGU>
else
    durationtotal=max(max(delay_all))+.1; %#ok<NASGU>
end


if length(varargin)>=6&&varargin{6}~=1
    Fs=varargin{6};
else
    Fs=44100;
end

if length(varargin)>=7&&varargin{7}~=1
    duration_smoothing=abs(varargin{7});
else
    duration_smoothing=1/Fs;
end

%% Starting and Checking Psychportaudio %%%%%

if PsychPortAudio('GetOpenDeviceCount')==0
    
    InitializePsychSound(1);
    devices = PsychPortAudio('GetDevices'); %#ok<NASGU>
   
end
  
    reqlatencyclass = 2;
    
    buffersize = 64;
 
    pahandle = PsychPortAudio('Open',[],[],reqlatencyclass,Fs,2,buffersize); 

%% Creating the Signal %%%%%

beep = 1;

noesc=[];

lenghtbuffer=floor(max(duration(beep,:))*Fs);
buffer_complete=zeros(lenghtbuffer,channels_used);

initkeys=0; %#ok<NASGU>

try
    noesc=keyinteraction({'Escape'},[],-1);%checks whether esc has been pressed
    initkeys=1;
catch
    initkeys=-1;
end


for channel=1:channels_used
    
    buffer_one_beep=zeros(lenghtbuffer,1);
    buffer_one_channel=zeros(lenghtbuffer,1);
    
    buffer_one_channel=buffer_one_channel*0;
    
        if amplitude(beep,channel)>0
            
            buffer_one_beep=buffer_one_beep*0; %#ok<NASGU>
            
            time_vector=(1/Fs:1/Fs:(duration(beep,channel)));
            
            lenght_smoothing=floor(Fs*duration_smoothing);
            
            if lenght_smoothing>0 
                modulation=time_vector*0+1;
                modulation(1:lenght_smoothing+1)=0:1/lenght_smoothing:1;
                modulation(end:-1:end-lenght_smoothing)=0:1/lenght_smoothing:1;
            else
                modulation=time_vector*0+1;
            end
            
            buffersignal = modulation .* - min(1,max(-1,1 * sin (signalfrequency(beep,channel)* (2 * pi * time_vector) ))) * amplitude(beep,channel) ;
            buffer_one_beep = buffersignal;
            
            buffer_one_channel=buffer_one_channel'+buffer_one_beep;
        end
        
        if initkeys==1
            noesc=keyinteraction({'Escape'},[],-1);%checks whether esc has been pressed
        end
        
        if ~isempty(noesc)
            buffer_one_channel=[]; %#ok<NASGU>
            buffer_complete=[];
            ending=true;
            break
        end
 
    if  ending~=true
        buffer_complete(:,channel)=buffer_one_channel;
    end
end


%% Storing the Beep %%%%%

PsychPortAudio('FillBuffer', pahandle, buffer_complete');

end


