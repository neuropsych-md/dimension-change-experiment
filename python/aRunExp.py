#import modules
from __future__ import division
import numpy as np
from psychopy import visual, core, event
from psychopy.visual import filters
from random import randint
import copy as cp

#make clock object
clock = core.Clock()

#define colours
colorstim = [0,1,2] #red,green,blue

#define orientation
orientstim = [45,135,90] #left,right,horizontal

#open window
win=visual.Window(([1920,1080]),colorSpace='rgb',color=(-1,-1,-1),fullscr='true')
winsize = [1920,1080] 
stimsize = winsize[1]/2
freq = 15/stimsize
sigma = stimsize/5

#make grating
grating = filters.makeGrating(256,cycles=1)

texture_red = np.zeros([256,256,3])
texture_red[:,:,0] = grating#r
texture_red[:,:,1] = -1#g
texture_red[:,:,2] = -1#b

texture_green = np.zeros([256,256,3])
texture_green[:,:,0] = -1#r
texture_green[:,:,1] = grating#g
texture_green[:,:,2] = -1#b

texture_blue = np.zeros([256,256,3])
texture_blue[:,:,0] = -1#r
texture_blue[:,:,1] = -1#g
texture_blue[:,:,2] = grating#b

#define button presses
RESPKEYS = ['left','right']
QUITKEYS = ['escape','q']

#define stimuli and blocks
stimnum = 15
blocknum = 8

#make stimuli
fixation = visual.ShapeStim(win, 
    vertices=((0, -0.2), (0, 0.2), (0,0), (-0.1,0), (0.1, 0)),lineWidth=5,
    closeShape=False,lineColor='white')
gabor_red = visual.PatchStim(win,tex=texture_red,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_red', ori = orientstim[2], autoLog=False)
gabor_green = visual.PatchStim(win,tex=texture_green,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_green', ori = orientstim[2], autoLog=False)
gabor_lor = visual.PatchStim(win,tex=texture_blue,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_lor', ori = orientstim[0], autoLog=False)
gabor_ror = visual.PatchStim(win,tex=texture_blue,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_ror', ori = orientstim[1], autoLog=False)
gabor_ntar = visual.PatchStim(win,tex=texture_blue,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_ntar', ori = orientstim[2], autoLog=False)
gabor_r = visual.PatchStim(win,tex=texture_blue,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_r', ori = orientstim[2], pos=(600,0),autoLog=False)
gabor_l = visual.PatchStim(win,tex=texture_blue,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_l', ori = orientstim[2], pos=(-600,0),autoLog=False)
blank = visual.GratingStim(win, tex=None, mask='gauss', sf=freq, units = '', size=0,
    name='blank', autoLog=False)

targettypes = dict([(0,gabor_ntar),(1,gabor_red),(2,gabor_green),(3,gabor_lor),(4,gabor_ror)])
tar_use = 1

# make randomization

randmatsort = np.ones(150)
randmatsort[0:45]=0
randmatsort[45:80]=1
randmatsort[80:115]=2
randmatsort[115:150]=3
randmat=np.random.permutation(randmatsort)

# present stimuli and record responses

t = randint(1,4)
response = []
RT=[]

for trial in range(12):
    
    gabor_m = targettypes[t]
    if t !=0:
        prev_t=cp.copy(t)
    a=randint(1,2)
    feature_change_stim = dict([(1,2),(2,1),(3,4),(4,3)])
    dimension_change_stim = dict([(1,a+2),(2,a+2),(3,a),(4,a)])
    
    frameN = 0
    responded = False
    event.clearEvents()
    clock.reset()

    for frameN in range(120):#for exactly 120 frames (2 seconds)
        
        pressed = event.getKeys(keyList=RESPKEYS+QUITKEYS, timeStamped=clock)
        if pressed and not responded:
            responded=True
            pressedKey, pressedTime = pressed[0]
            if pressedKey in QUITKEYS:
                core.quit()
            elif pressedKey in RESPKEYS:
                response = pressedKey
                RT = pressedTime
        if frameN==119 and not responded:
            response = np.nan
            RT = np.nan
        
        if 1 <= frameN < 48:  # present fixation for 48 frames (800ms)
            fixation.draw()
        if 48 <= frameN < 60: # present stimulus for 12 frames (200ms)
            gabor_m.draw()
            gabor_l.draw()
            gabor_r.draw()
        if 60 <= frameN < 120:  # present blank for 60 frames (1000ms)
            blank.draw()
        win.flip()
        
    print(response) #just to check
    print(RT) #just to check
            
    #decide next stimulus
    if trial<150:
        if randmat[trial+1]==0:
            t=0
        elif randmat[trial+1]==1:
            t=prev_t
        elif randmat[trial+1]==2:
            t=feature_change_stim[prev_t]
        elif randmat[trial+1]==3:
            t=dimension_change_stim[prev_t]