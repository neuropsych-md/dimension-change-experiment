# dimension-change-experiment
simple detection task investigating the effect of changing the relevant stimulus feature and dimension

programmed in Matlab's Psychtoolbox

Files: 

- a_aRunExp.m: General Setting, Setting up Triggers to work in EEG Lab
- a_framework.m & a_framework_practice.m: Instructions and Loop through blocks
- b_present3_withframe.m: Stimulus Presentation
- c_present3_examples.m: Example Stimuli needed for Instructions
- KbQueueWait_mod: modified version of KbQueueWait to return exact timing
- y_Flicker_Photometry: manually adapting luminance of colours 
- z_makeiso3: automatically adapting luminance of colours
- z_beepiteg.m: present tone (for mistakes, too slow trials) 

Task Overview: 

Participants are presented with three gabor patches in every trial and are instructed to decide whether the 
middle patch (= target) is the same or different to the outer patches (= distractors). Distractors are always 
colored in a blue tone and have horizontally oriented stripes. The target can differ either (1) in color, that is, 
it can be green or red rather than blue or (2) in orientation, that is, it can have left or right diagonally oriented 
rather than horizontally oriented stripes. Participants have to press the left button on a response device, if the target stimulus 
is the same as the distractors (=same trials). If the target is different they have to press the right button (=difference trials), 
independent of the target stimulus dimension of interest (color or orientation) and feature (red or green, left or right diagonal). 
The stimulus display is presented for 200ms, after which participants see a black response screen for 800ms. 
If they haven't replied after 700ms a 20ms 500Hz sound indicated that their response has not been quick enough.  
Between every two trials a one second fixation cross was presented. 

Every main block consists of 70 percent difference trials (requiring a right button press) 
and 30 percent same trials (requiring a left button press), randomly intermixed. 
One third of the difference trials has the same target stimulus as shown in the previous difference trial (= repeat trials), 
one third has a target stimulus differing from the distractors in the same dimension, but another feature (= feature-change trials) 
and the last third has a target stimulus differing from the distractors in another dimension than in the last difference trial (= dimension-change trials). 
The sequence of trials is pseudo-randomized independently for every block and subject. 
