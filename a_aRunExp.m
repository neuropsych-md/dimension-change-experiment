%% Dimension-change-experiment, sets necessary variables and runs practice and full experiment

%% Trigger-settings

try 
config_io
address = hex2dec('D010'); %for LTP3

% test and set to zero
outp(address,255);outp(address,0);
inp(address);
catch 
    display('No Triggers will be sent')
end

%% Sound

InitializePsychSound(1)

%% Practice Block

a_framework_practice 

%% Main Block   

a_framework    