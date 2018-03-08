#import modules
from __future__ import division
import numpy as np
from psychopy import visual, core, event
from psychopy.visual import filters
from random import randint
import copy as cp

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

t = randint(1,4)

for trial in range(120):
    
    gabor_m = targettypes[t]
    if t !=0:
        prev_t=cp.copy(t)
    a=1 #randint(1,2)+2
    feature_change_stim = dict([(1,2),(2,1),(3,4),(4,3)])
    dimension_change_stim = dict([(1,a+2),(2,a+2),(3,a),(4,a)])
    
    #display stimuli 
    clock = core.Clock()
    for frameN in range(120):#for exactly 120 frames (2 seconds)
        if 1 <= frameN < 48:  # present fixation for 48 frames (800ms)
            fixation.draw()
        if 48 <= frameN < 60: # present stimulus for 12 frames (200ms)
            gabor_m.draw()
            gabor_l.draw()
            gabor_r.draw()
        if 60 <= frameN < 120:  # present blank for 60 frames (1000ms)
            blank.draw()
        win.flip()
        
        #quit on escape
        if 'escape' in event.getKeys():
            core.quit()
            
        #decide next stimulus
        if trial<119:
            if randmat[trial+1]==0:
                t=0
            elif randmat[trial+1]==1:
                t=prev_t
            elif randmat[trial+1]==2:
                t=feature_change_stim[prev_t]
            elif randmat[trial+1]==3:
                t=dimension_change_stim[prev_t]