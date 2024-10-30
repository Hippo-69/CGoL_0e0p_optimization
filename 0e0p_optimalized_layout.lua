--plan is to make a p1 skeleton (where the DNA s moving) with p2 SoD
--there should be light rotation symmetric shell spiral allowing fill from 4 different inputs,
--that would allow mod DNA equal phase glider to reach the construction site in S corner.
--everything is built with seed of destruction (SoD).
--building shell requires allocation of "big" empty space, to prevnt next stages to allocate again,
--we create target for future use as well.
local g = golly()
local gp = require "gplus"
local gpt = require "gplus.text"
local pattern = gp.pattern

-- sizes
local quadsize = 1024 --4096 -- to be callculated
local halfsize = 2*quadsize 
local shell_lane0_dist = 48      -- 64 to be decided
local shell_lane_dist = 36       -- 64 to be decided
local shell_last_extra_dist = 28 -- 0 -- to be decided
local oriconstr_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+60
local constr_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+20
local input_lane0_dist = 16 -- 32 -- 64
local input_lane_dist = 32 -- 64
local shell_SoD_lane = 340
local shell_SoD_lane_add = 16 
local open_kernel_lane = 16
local snark_delay = 22 -- includes change in cordinate system
local input_time1=4*quadsize-8192-4*input_lane0_dist+4*shell_lane0_dist+12*shell_lane_dist+4*shell_last_extra_dist
local input_time2=12*quadsize-8192-8*shell_lane0_dist-20*shell_lane_dist-4*shell_last_extra_dist+1*snark_delay-4*input_lane0_dist-4*input_lane_dist+4*shell_lane0_dist+8*shell_lane_dist -- -570*4-2
local input_time3=20*quadsize-8192-16*shell_lane0_dist-32*shell_lane_dist-4*shell_last_extra_dist+2*snark_delay-4*input_lane0_dist-8*input_lane_dist+4*shell_lane0_dist+4*shell_lane_dist -- -570*4-2-(570-128)*4-2
local input_time4=28*quadsize-8192-24*shell_lane0_dist-36*shell_lane_dist-4*shell_last_extra_dist+3*snark_delay-4*input_lane0_dist-12*input_lane_dist+4*shell_lane0_dist -- -570*4-2-(570-128)*4-2-(570-256)*4-2

-- states
local shell_state=9
local SoD_state=5--13
local SoD_glidermark_state=12
local SoD_phase=0
local comment_state=4
local comment_glider_state=4

-- patterns
local snarkNES=pattern()
snarkNES.array=g.parse("13bo$11b3o$10bo$10b2o3$18b2o$19bo$19bob2o$11b2o4b3o2bo$11b2o3bo3b2o$16b4o$2b2o15bo$bobo12b3o$bo13bo$2o14b5o$20bo$18bo$18b2o!")
snarkNES=snarkNES.state(shell_state)

local snarkNES_SoD1=pattern()
snarkNES_SoD1.array=g.parse("21$26b2o$26b2o!")
snarkNES_SoD1=snarkNES_SoD1[SoD_phase].state(SoD_state)

local snarkNES_withSoD1=(snarkNES+snarkNES_SoD1).t(-6,-13)

local scorbieSE=pattern()
scorbieSE.array=g.parse("2bo$2b3o$5bo$4b2o6$24b2o$24b2o4$22b2o$22bobo$24bo$24b2o6$13b2o$13b2o$5b2o$6bo$3b3o$3bo2$4bo$3bobo$3bobo$b3ob2o$o$b3ob2o$3bob2o2$13b2o$13b2o7b2o$22bo$20bobo$20b2o4$2o$2o5$16bo$15bobo$15bobo$16bo$17b3o$19bo!")
scorbieSE=scorbieSE.state(shell_state)

local scorbieSE_SoD=pattern()
scorbieSE_SoD.array=g.parse("5$6b2o$6b2o10$3o22$9bo$8bobo$8bobo$9bo21$29b3o!")
scorbieSE_SoD=scorbieSE_SoD[SoD_phase].state(SoD_state).t(-12,0)

local scorbieSE_withSoD=(scorbieSE+scorbieSE_SoD).t(6,-17)

local scorbie_inputglider=pattern()
scorbie_inputglider.array=g.parse("2o$obo$o!")
scorbie_inputglider=scorbie_inputglider.state(comment_glider_state).t(25,53).t(6,-17)

local outputglider=pattern()
outputglider.array=g.parse("2bo$obo$b2o!")
outputglider=outputglider.state(comment_glider_state).t(-65,-70)

local scorbie_SoD_turner=pattern()
scorbie_SoD_turner.array=g.parse("o$o$o2$o$o$o!")
scorbie_SoD_turner=scorbie_SoD_turner[SoD_phase].state(SoD_state).t(23,-8)

local kernellane_SoD_turner=pattern()
kernellane_SoD_turner.array=g.parse("2o$obo$b2o6$14bo$14bo$14bo!")
kernellane_SoD_turner=kernellane_SoD_turner[SoD_phase].state(SoD_state).t(-11,-1)

local kernellane_SoD_eater=pattern()
kernellane_SoD_eater.array=g.parse("2o$2o!")
kernellane_SoD_eater=kernellane_SoD_eater[SoD_phase].state(SoD_state).t(24,-20)

local kernellane_turner=pattern()
kernellane_turner.array=g.parse("2o$obo$bo!")
kernellane_turner=kernellane_turner.state(shell_state).t(9,-10)

local glider_SoD=pattern()
glider_SoD.array=g.parse("bo$2bo$3o!")
glider_SoD=glider_SoD[SoD_phase].state(SoD_glidermark_state).t(-7,7)

local SE_SoD_turner=pattern()
SE_SoD_turner.array=g.parse("b2o$obo$bo!")
SE_SoD_turner=SE_SoD_turner[SoD_phase].state(SoD_state).t(64-21,64+17)

local SE_SoD_spitter=pattern()
SE_SoD_spitter.array=g.parse("2bo$bobo$o2bo$b2o3$10b2o$9bobo$10bo!")
SE_SoD_spitter=SE_SoD_spitter[SoD_phase].state(SoD_state).t(64-3,64-55)

local prescorbie_SoD_turner=pattern()
prescorbie_SoD_turner.array=g.parse("2o$obo$bo!")
prescorbie_SoD_turner=prescorbie_SoD_turner[SoD_phase].state(SoD_state).t(64-12,64-41)

local extralanesnarkSoDsplitter=pattern()
extralanesnarkSoDsplitter.array=g.parse("bo$obo$bobo$2bo6$6b2o$5bobo$4bobo$5bo!")
extralanesnarkSoDsplitter=extralanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(-31,45)  --Algunger Bekerai

local midlanesnarkSoDsplitter=pattern()
midlanesnarkSoDsplitter.array=g.parse("2o$obo$b2o2$15b2o$15b2o!")
midlanesnarkSoDsplitter=midlanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(-25-shell_lane_dist,56+shell_lane_dist)

local firstlanesnarkSoDsplitter=pattern()
firstlanesnarkSoDsplitter.array=g.parse("2bo$2bo$2bo11$bo$obo$bo!")
firstlanesnarkSoDsplitter=firstlanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(-31-2*shell_lane_dist,53+2*shell_lane_dist)

local constructionlaneblockingeaterSoDsplitter=pattern()
constructionlaneblockingeaterSoDsplitter.array=g.parse("13bo$o11bobo$o12bo$o!")
constructionlaneblockingeaterSoDsplitter=constructionlaneblockingeaterSoDsplitter[SoD_phase].state(SoD_state).t(-21-2*shell_lane0_dist-3*shell_lane_dist,83+shell_lane_dist)

local constructionstopperSoDtuner=pattern()
constructionstopperSoDtuner.array=g.parse("bo$obo$2o!")
constructionstopperSoDtuner=constructionstopperSoDtuner[SoD_phase].state(SoD_state).t(-64-shell_lane0_dist-2*shell_lane_dist,29+shell_lane0_dist+2*shell_lane_dist)

local constructionstopper=pattern()
constructionstopper.array=g.parse("2o$2o!")
constructionstopper=constructionstopper.state(shell_state)

local constructionstopperSoD=pattern()
constructionstopperSoD.array=g.parse("2o$2o!")
constructionstopperSoD=constructionstopperSoD[SoD_phase].state(SoD_state).t(-7,-4)

local constructionstopperwithSoD=(constructionstopper+constructionstopperSoD).t(-21-constr_lane_dist,-13+constr_lane_dist)

local constructionlaneblockingeater=pattern()
constructionlaneblockingeater.array=g.parse("o$3o$3bo$2b2o!")
constructionlaneblockingeater=constructionlaneblockingeater.state(shell_state).t(31-constr_lane_dist-shell_lane0_dist-shell_lane_dist,31+constr_lane_dist-shell_lane0_dist-shell_lane_dist)

local constructiontarget=pattern()
constructiontarget.array=g.parse("2o$2o!")
constructiontarget=constructiontarget.state(shell_state).t(-8-constr_lane_dist,10-constr_lane_dist)

local oriconstructiontarget=pattern()
oriconstructiontarget.array=g.parse("2o$2o!")
oriconstructiontarget=oriconstructiontarget.state(shell_state).t(1-oriconstr_lane_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist,0-oriconstr_lane_dist+shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist)

local openkernelglider=pattern()
openkernelglider.array=g.parse("3o$o$bo!")
openkernelglider=openkernelglider.state(comment_glider_state).t(-constr_lane_dist-open_kernel_lane-20,-constr_lane_dist+open_kernel_lane-19)

local positionmark=pattern()
positionmark.array=g.parse("o3bo$bobo$2bo$bobo$o3bo!")
positionmark=positionmark.state(comment_state).t(-2,-2)

local filltxt=gpt.maketext("fill","mono").state(comment_state)

local inputtxt=gpt.maketext("input","mono").state(comment_state)
local inputtime1txt=gpt.maketext(input_time1-input_time1+832,"mono").state(comment_state)
local inputtime2txt=gpt.maketext(input_time2-input_time1+832,"mono").state(comment_state)
local inputtime3txt=gpt.maketext(input_time3-input_time1+832,"mono").state(comment_state)
local inputtime4txt=gpt.maketext(input_time4-input_time1+832,"mono").state(comment_state)

local outputtxt=gpt.maketext("output","mono").state(comment_state)

local openkerneltxt=gpt.maketext("open kernel","mono").state(comment_state)

g.setrule("Life")

local function E_pattern()
 local E=pattern()+positionmark
 E=E+constructiontarget+constructionlaneblockingeater+constructionstopperwithSoD+openkernelglider+oriconstructiontarget+constructionlaneblockingeaterSoDsplitter+constructionstopperSoDtuner
 E=E+openkerneltxt.t(-constr_lane_dist-open_kernel_lane-15,-constr_lane_dist+open_kernel_lane-22)
 E=E+openkerneltxt.t(-constr_lane_dist-open_kernel_lane-15,-constr_lane_dist+open_kernel_lane-14,gp.rcw)
 E=E+openkerneltxt.t(-constr_lane_dist-open_kernel_lane-23,-constr_lane_dist+open_kernel_lane-14,gp.flip)
 E=E+openkerneltxt.t(-constr_lane_dist-open_kernel_lane-23,-constr_lane_dist+open_kernel_lane-22,gp.rccw)
 E=E+(snarkNES_withSoD1+firstlanesnarkSoDsplitter).t(-2*shell_lane0_dist-shell_lane_dist,0*shell_lane0_dist-shell_lane_dist)
 E=E+(snarkNES_withSoD1+midlanesnarkSoDsplitter).t(-2*shell_lane0_dist-3*shell_lane_dist,0*shell_lane0_dist-shell_lane_dist)
 E=E+(snarkNES_withSoD1+extralanesnarkSoDsplitter).t(-2*shell_lane0_dist-5*shell_lane_dist-shell_last_extra_dist,0*shell_lane0_dist-shell_lane_dist-shell_last_extra_dist)
 E=E+filltxt.t(-6-2*shell_lane0_dist-5*shell_lane_dist-shell_last_extra_dist,15+0*shell_lane0_dist-shell_lane_dist-shell_last_extra_dist)
 E=E+filltxt.t(0-2*shell_lane0_dist-3*shell_lane_dist,15+0*shell_lane0_dist-shell_lane_dist,gp.rcw)
 E=E+filltxt.t(20-2*shell_lane0_dist-shell_lane_dist,20+0*shell_lane0_dist-shell_lane_dist,gp.flip)
 return E
end

local function SE_pattern()
 local SE=pattern()+positionmark
 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist,input_lane0_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-shell_lane0_dist,input_lane0_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(-2-input_lane0_dist-shell_lane0_dist,36+input_lane0_dist-shell_lane0_dist)
 SE=SE+inputtime1txt.t(-2-input_lane0_dist-shell_lane0_dist,46+input_lane0_dist-shell_lane0_dist)

 SE=SE+scorbie_SoD_turner.t(-input_lane0_dist-shell_lane0_dist-2*shell_lane_dist,input_lane0_dist-shell_lane0_dist-2*shell_lane_dist)

 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-input_lane_dist-shell_lane0_dist-2*shell_lane_dist,input_lane0_dist+input_lane_dist-shell_lane0_dist-2*shell_lane_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane_dist-shell_lane0_dist,input_lane0_dist+input_lane_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(36-input_lane0_dist-input_lane_dist-shell_lane0_dist,40+input_lane0_dist+input_lane_dist-shell_lane0_dist,gp.rcw)
 SE=SE+inputtime2txt.t(26-input_lane0_dist-input_lane_dist-shell_lane0_dist,40+input_lane0_dist+input_lane_dist-shell_lane0_dist,gp.rcw)

 SE=SE+scorbie_SoD_turner.t(-input_lane0_dist-input_lane_dist-shell_lane0_dist-shell_lane_dist,input_lane0_dist+input_lane_dist-shell_lane0_dist-shell_lane_dist)

 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-2*input_lane_dist-shell_lane0_dist-shell_lane_dist,input_lane0_dist+2*input_lane_dist-shell_lane0_dist-shell_lane_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-2*input_lane_dist-shell_lane0_dist,input_lane0_dist+2*input_lane_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(28-input_lane0_dist-2*input_lane_dist-shell_lane0_dist,40+input_lane0_dist+2*input_lane_dist-shell_lane0_dist,gp.flip)
 SE=SE+inputtime3txt.t(28-input_lane0_dist-2*input_lane_dist-shell_lane0_dist,30+input_lane0_dist+2*input_lane_dist-shell_lane0_dist,gp.flip)

 SE=SE+scorbie_SoD_turner.t(-input_lane0_dist-2*input_lane_dist-shell_lane0_dist,input_lane0_dist+2*input_lane_dist-shell_lane0_dist)

 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-3*input_lane_dist-shell_lane0_dist,input_lane0_dist+3*input_lane_dist-shell_lane0_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-3*input_lane_dist-shell_lane0_dist,input_lane0_dist+3*input_lane_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(28-input_lane0_dist-3*input_lane_dist-shell_lane0_dist,70+input_lane0_dist+3*input_lane_dist-shell_lane0_dist,gp.rccw)
 SE=SE+inputtime4txt.t(38-input_lane0_dist-3*input_lane_dist-shell_lane0_dist,70+input_lane0_dist+3*input_lane_dist-shell_lane0_dist,gp.rccw)

 SE=SE+prescorbie_SoD_turner.t(-input_lane0_dist-3*input_lane_dist-shell_lane0_dist,input_lane0_dist+3*input_lane_dist-shell_lane0_dist)
 SE=SE+SE_SoD_turner.t(-shell_SoD_lane-shell_SoD_lane_add-shell_lane0_dist,shell_SoD_lane+-shell_SoD_lane_add-shell_lane0_dist)
 SE=SE+SE_SoD_spitter.t(-shell_SoD_lane-shell_lane0_dist,shell_SoD_lane-shell_lane0_dist)

 SE=SE+kernellane_SoD_turner.t(-shell_SoD_lane-shell_SoD_lane_add-open_kernel_lane,shell_SoD_lane+shell_SoD_lane_add-open_kernel_lane)
 SE=SE+kernellane_turner.t(-shell_SoD_lane-open_kernel_lane,shell_SoD_lane-open_kernel_lane)
 SE=SE+kernellane_SoD_eater.t(-shell_SoD_lane-open_kernel_lane,shell_SoD_lane-open_kernel_lane)

 SE=SE+outputglider.t(input_lane0_dist-shell_lane0_dist,-input_lane0_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-69+input_lane0_dist-shell_lane0_dist,-64-input_lane0_dist-shell_lane0_dist,gp.flip)
 SE=SE+outputglider.t(input_lane0_dist+input_lane_dist-shell_lane0_dist,-input_lane0_dist-input_lane_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-68+input_lane0_dist+input_lane_dist-shell_lane0_dist,-74+-input_lane0_dist-input_lane_dist-shell_lane0_dist,gp.rccw)
 SE=SE+outputglider.t(input_lane0_dist+2*input_lane_dist-shell_lane0_dist,-input_lane0_dist-2*input_lane_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-60+input_lane0_dist+2*input_lane_dist-shell_lane0_dist,-72-input_lane0_dist-2*input_lane_dist-shell_lane0_dist)
 SE=SE+outputglider.t(input_lane0_dist+3*input_lane_dist-shell_lane0_dist,-input_lane0_dist-3*input_lane_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-60+input_lane0_dist+3*input_lane_dist-shell_lane0_dist,-64-input_lane0_dist-3*input_lane_dist-shell_lane0_dist,gp.rcw)

 SE=SE+glider_SoD.t(-shell_SoD_lane-shell_SoD_lane_add-512,shell_SoD_lane+shell_SoD_lane_add-512)

 return SE
end

local function shell_pattern()
 local E=E_pattern().t(halfsize,0)
 local SE=SE_pattern().t(quadsize,quadsize)
 local N=E.t(0,0,gp.rccw)
 local W=N.t(0,0,gp.rccw)
 local S=W.t(0,0,gp.rccw)
 local NE=SE.t(0,0,gp.rccw)
 local NW=NE.t(0,0,gp.rccw)
 local SW=NW.t(0,0,gp.rccw)
 return E+N+W+S+SE+NE+NW+SW
end

local _0e0p_cell = shell_pattern()
g.setrule("LifeHistory14")
local _0e0p_cells = _0e0p_cell+_0e0p_cell.t(-halfsize,-halfsize)+_0e0p_cell.t(halfsize,-halfsize)+_0e0p_cell.t(halfsize,halfsize)+_0e0p_cell.t(-halfsize,halfsize)
_0e0p_cell.display("0e0pcells")