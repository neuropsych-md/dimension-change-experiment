#import modules
from __future__ import division
import numpy as np
from psychopy import visual, core
from psychopy.visual import filters

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

texture_tar = np.zeros([256,256,3])
texture_tar[:,:,0] = grating#r
texture_tar[:,:,1] = -1#g
texture_tar[:,:,2] = -1#b

texture_dis = np.zeros([256,256,3])
texture_dis[:,:,0] = -1#r
texture_dis[:,:,1] = -1#g
texture_dis[:,:,2] = grating#b

#draw stimuli
fixation = visual.ShapeStim(win, 
    vertices=((0, -0.2), (0, 0.2), (0,0), (-0.1,0), (0.1, 0)),lineWidth=5,
    closeShape=False,lineColor='white')
gabor_m = visual.PatchStim(win,tex=texture_tar,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_m', ori = orientstim[0], autoLog=False)
gabor_r = visual.PatchStim(win,tex=texture_dis,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_r', ori = orientstim[2], autoLog=False)
gabor_l = visual.PatchStim(win,tex=texture_dis,mask='gauss',sf=freq,phase=0,contrast=1,units='pix',size=stimsize,
    name='gabor_l', ori = orientstim[2], autoLog=False)
blank = visual.GratingStim(win, tex=None, mask='gauss', sf=freq, units = '', size=0,
    name='blank', autoLog=False)

#position stimuli
gabor_m.pos = (0,0)
gabor_r.pos = (600,0)
gabor_l.pos = (-600,0)

#display stimuli with accurate timing
clock = core.Clock()
for frameN in range(120):#for exactly 120 frames
    if 1 <= frameN < 48:  # present fixation for 48 frames (800ms)
        fixation.draw()
    if 48 <= frameN < 60: # present stimulus for 12 frames (200ms)
        gabor_m.draw()
        gabor_l.draw()
        gabor_r.draw()
    if 60 <= frameN < 120:  # present blank for 60 frames (1000ms)
        blank.draw()
    win.flip()