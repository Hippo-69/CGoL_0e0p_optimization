--plan is to make a p1 skeleton (where the DNA s moving) with p2 SoD
--there should be light rotation symmetric shell spiral allowing fill from 4 different inputs,
--that would allow mod DNA equal phase glider to reach the construction site in S corner.
--everything is built with seed of destruction (SoD).
--building shell requires allocation of "big" empty space, to prevnt next stages to allocate again,
--we create target for future use as well.
local g = golly()
local gp = require "gplus"
local gpo = require "gplus.objects"
local gpt = require "gplus.text"
local pattern = gp.pattern
g.setrule("Life")
local startX, startY = g.getpos()
local startMag=g.getmag()
-- sizes
local DNAtimelog = 24 --27
--DNAtimelog = 17
local DNAFDlog = DNAtimelog-2
local DNAloopOctavoDist = 2^(DNAFDlog-3) // 3
local quadsize = 2^(DNAFDlog-3)--5*DNAloopOctavoDist --4096 -- to be callculated
local halfsize = 2*quadsize
local DNA_outershell_dist = 400
local innerquadsize = 2*DNAloopOctavoDist + DNA_outershell_dist -- to be choosen
local DNA_loop_shrink=6
local shell_lane0_dist = 48      -- 64 to be decided
local shell_lane_dist = 36       -- 64 to be decided
local shell_last_extra_dist = 28--28 -- 0 -- to be decided
local oriconstr_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+60
local constr_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+20
local input_lane0_dist = 123 + 0*DNA_loop_shrink +175141 -- 32 -- 64
local input_lane1_dist = 32+121 + 1*DNA_loop_shrink -- 64
local input_lane2_dist = 32+274 + 1*DNA_loop_shrink -- 64
local input_lane3_dist = 32+221 + 1*DNA_loop_shrink -- 64
local output_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+120
local shellSoD_presnarkDist = 13
local open_kernel_lane = 419+10
local snark_delay = 22 -- includes change in cordinate system
local input_time1=4*innerquadsize-8192-4*input_lane0_dist+4*shell_lane0_dist+12*shell_lane_dist+4*shell_last_extra_dist
local input_time2=12*innerquadsize-8192-8*shell_lane0_dist-20*shell_lane_dist-4*shell_last_extra_dist+1*snark_delay-4*input_lane0_dist-4*input_lane1_dist+4*shell_lane0_dist+8*shell_lane_dist -- -570*4-2
local input_time3=20*innerquadsize-8192-16*shell_lane0_dist-32*shell_lane_dist-4*shell_last_extra_dist+2*snark_delay-4*input_lane0_dist-4*input_lane1_dist-4*input_lane2_dist+4*shell_lane0_dist+4*shell_lane_dist -- -570*4-2-(570-128)*4-2
local input_time4=28*innerquadsize-8192-24*shell_lane0_dist-36*shell_lane_dist-4*shell_last_extra_dist+3*snark_delay-4*input_lane0_dist-4*input_lane1_dist-4*input_lane2_dist-4*input_lane3_dist+4*shell_lane0_dist -- -570*4-2-(570-128)*4-2-(570-256)*4-2
local SoD_lane = -57 + constr_lane_dist

-- states
local build_child_shell_state=29
local shell_state=27
local send_DNA_state=7
local receive_DNA_state=15  -- to be replaced by say 5
local DNA_loop_state=17
local clock_logic_state=19 -- to be replaced by say 5
local state_computation_state=25
local send_state_state=21
local receive_state_state=23
local SoD_state=11
local SoD_glidermark_state=10
local SoD_phase=1
local active_state=5
local comment_state=4
local glider_trail_state=127
local glider_notrail_state=129
local comment_glider_state=4
local construction_target_state=31

-- patterns
local shillelagh=pattern()
shillelagh.array=g.parse("ob2o$2o2bo$3b2o!")

local snark=pattern()
snark.array=g.parse("13bo$11b3o$10bo$10b2o3$18b2o$19bo$19bob2o$11b2o4b3o2bo$11b2o3bo3b2o$16b4o$2b2o15bo$bobo12b3o$bo13bo$2o14b5o$20bo$18bo$18b2o!")

local snark_SoDOpp=pattern()
snark_SoDOpp.array=g.parse("$22bo$21bobo$20bobo$21bo20$8b2o$9bo$9bobo$10b2o!")

local scorbiesplit=pattern()
scorbiesplit.array=g.parse("46bo$46b3o$49bo$40bo7b2o$40b3o$18bo24bo$16b3o23b2o$15bo$15b2o$2o$bo$bob2o$2bo2bo$3b2o$18b2o13b2o$18b2o13b2o7$21b2obo6b2o$21b2ob3o3bobo21b2o$27bo2bo23bobo$21b2ob3o2b2o25bo$22bobo31b2o$10b2o10bobo$10b2o11bo!")
scorbiesplit=scorbiesplit.t(-27,11)

local scorbiesplitinsertstopped_SoDOpp=pattern()
scorbiesplitinsertstopped_SoDOpp.array=g.parse("62b2o$62bobo$63b2o$29b3o33b2o$65bobo$66b2o9$2o$bo$bobo$2b2o12$38b2o$37bobo$38bo$59bo$59bo$59bo2$14b2o$14bobo$15b2o!")
scorbiesplitinsertstopped_SoDOpp=scorbiesplitinsertstopped_SoDOpp.t(-9,-1).t(-27,11)

local scorbiesplitinsert_SoDOpp=pattern()
scorbiesplitinsert_SoDOpp.array=g.parse("16b2o$17bo$14b3o3b2o$13bo6bobo$13b2o6b2o$23b2o12b2o$bo21bobo11b2o$obo21b2o$2o27$18b2o$17bobo$17b2o!")
scorbiesplitinsert_SoDOpp=scorbiesplitinsert_SoDOpp.t(14,-8).t(-27,11)

local scorbiesplitnoinsert_SoDOpp=scorbiesplitinsert_SoDOpp+gpo.blinker.t(35,17)

local scorbiesplit_SoDOpp=pattern()
scorbiesplit_SoDOpp.array=g.parse("53bo$52bobo$53bobo$54b2o$17bo$16bobo$15bo2bo$16b2o7$65b2o$65bo$b2o63b3o$o2bo65bo$b2o65b2o5$74bo$73bobo$73b2o15$26b2o$25bo2bo$26b2o!")
scorbiesplit_SoDOpp=scorbiesplit_SoDOpp.t(-8,-12).t(-27,11)

local scorbieturn=pattern()
scorbieturn.array=g.parse("2bo$2b3o$5bo$4b2o6$24b2o$24b2o4$22b2o$22bobo$24bo$24b2o6$13b2o$13b2o$5b2o$6bo$3b3o$3bo2$4bo$3bobo$3bobo$b3ob2o$o$b3ob2o$3bob2o2$13b2o$13b2o7b2o$22bo$20bobo$20b2o4$2o$2o5$16bo$15bobo$15bobo$16bo$17b3o$19bo!")
scorbieturn=scorbieturn.t(6,-17)

local scorbieturn_SoDOpp=pattern()
scorbieturn_SoDOpp.array=g.parse("10b2o$10bobo$11bo14bo$24b3o$23bo$23b2o24$9bo$8bobo$9bo9$b2o$obo$bo9$33bo$33bo$33bo9$8b2o$8b2o!")
scorbieturn_SoDOpp=scorbieturn_SoDOpp.t(-2,-26)

local scorbieturn_SoDOppEnd=pattern()
scorbieturn_SoDOppEnd.array=g.parse("12b2o$12bobo$13b2o2$23b2o$22bobo$23bo29$27bo$2bo23bobo$bobo22bobo$o2bo23bo$obo$bo8$41bo$41bo$41bo!")
scorbieturn_SoDOppEnd=scorbieturn_SoDOppEnd.t(2,-24)

local scorbieturninsert_SoD=pattern()
scorbieturninsert_SoD.array=g.parse("2o$2o17$6b2o$6b2o$32bo$32bo$32bo12$5bo$4bobo$3bo2bo$4b2o!")
scorbieturninsert_SoD=scorbieturninsert_SoD.t(0,-14)

local tubsemisnark = gpo.eater.t(2,11,gp.rcw)+ gpo.eater.t(14,14)+ gpo.tub.t(3,4)+ gpo.block.t(11,-1)+gpo.block.t(7,16)
local boatsemisnark = gpo.eater.t(2,11,gp.rcw)+ gpo.eater.t(14,14)+ gpo.boat.t(2,3)+ gpo.block.t(11,-1)+ gpo.block.t(7,16)
local boatsemisnark_SoD = gpo.block.t(-4,5)+gpo.block.t(22,22)+gpo.beehive.t(12,20)--.state(SoD_state)
local semisnarksemi = gpo.block.t(6,9).state(active_state)+gpo.block.t(8,8).state(comment_state)
local semisnarkready = gpo.block.t(8,8).state(active_state)+gpo.block.t(6,9).state(comment_state)
--local snarkNES_SoD1=pattern()
--snarkNES_SoD1.array=g.parse("21$26b2o$26b2o!")
--snarkNES_SoD1=snarkNES_SoD1[SoD_phase].state(SoD_state)
--local scorbiesplitter_withSoD = scorbiesplitter+scorbiesplitter_SoD[SoD_phase].state(SoD_state)
--local scorbiesplitter_withSoDp1 = scorbiesplitter+scorbiesplitter_SoD[1+SoD_phase].state(SoD_state)
--local scorbiesplitter_withSoD_andEater=scorbiesplitter_withSoD + gpo.eater.t(82,39).state(transfer_DNA_state).t(-27,11)
--local scorbieSplit_withSoDOpp=scorbiesplitter+scorbieSplit_SoDOpp
--local scorbieSETurn_withSoD=scorbieSE+scorbieSETurn_SoD.state(SoD_state)
--local scorbieSEInsert_withSoD=scorbieSE+scorbieSEInsert_SoD.state(SoD_state)
--local scorbieSEInsert_withSoDp1=scorbieSE+scorbieSEInsert_SoD[1].state(SoD_state)

----- glider positions ----
local scorbie_inputglider=pattern()
scorbie_inputglider.array=g.parse("2o$obo$o!")
scorbie_inputglider=scorbie_inputglider.state(comment_glider_state).t(25,53).t(6,-17)

local outputglider=pattern()
outputglider.array=g.parse("2bo$obo$b2o!")
outputglider=outputglider.state(comment_glider_state).t(-65,-70)

local openkernelglider=gpo.glider[0].state(comment_glider_state).t(-open_kernel_lane+64,-open_kernel_lane-64,gp.rccw)

------- ot ------
----- ott ... boat, longboat
local blinker2_ott90=pattern()
blinker2_ott90.array=g.parse("3ob3o!")
local block2_ott90=pattern()
block2_ott90.array=g.parse("4b2o$4b2o4$2o$2o!")
local toad_ott90=pattern()
toad_ott90.array=g.parse("b3o$3o!")
local loafblinker_ott90=pattern()
loafblinker_ott90.array=g.parse("bo8b3o$obo$o2bo$b2o!")
----- ots ------
local tubblinker_ots = gpo.tub.t(1,14)+gpo.blinker.t(2,1)
local pondblinker_ots = gpo.pond+gpo.blinker[1].t(6,6)
local boatloaf_ots = pattern()
    boatloaf_ots.array = g.parse("6bo$5bobo$5bo2bo$6b2o6$bo$obo$b2o!")
local shipblinker_ots = pattern()
shipblinker_ots.array = g.parse("o$o$o6$12b2o$12bobo$13b2o!")
local pondbeehive_ots = pattern()
pondbeehive_ots.array = g.parse("b2o$o2bo$o2bo$b2o$9bo$8bobo$8bobo$9bo!")
local shipblock_ots = pattern()
shipblock_ots.array = g.parse("2o$2o2$14b2o$14bobo$15b2o!")
local longboatblinker_ots = pattern()
longboatblinker_ots.array = g.parse("7b2o$3o4bobo$8bobo$9bo!")
local longboatloaf_ots = pattern()
longboatloaf_ots.array = g.parse("2b2o$bobo$obo$bo5$9b2o$8bo2bo$8bobo$9bo!")
--local output_oppositeSoD_splitter = pondblinker_ots

local positionmark=pattern()
positionmark.array=g.parse("o3bo$bobo$2bo$bobo$o3bo!")
positionmark=positionmark.state(comment_state).t(-2,-2)

------ txt ------

local filltxt=gpt.maketext("fill","mono").state(comment_state)
local inputtxt=gpt.maketext("input","mono").state(comment_state)
local inputtime1txt=gpt.maketext(input_time1-input_time1+1024,"mono").state(comment_state)
local inputtime2txt=gpt.maketext(input_time2-input_time1+1024,"mono").state(comment_state)
local inputtime3txt=gpt.maketext(input_time3-input_time1+1024,"mono").state(comment_state)
local inputtime4txt=gpt.maketext(input_time4-input_time1+1024,"mono").state(comment_state)

local outputtxt=gpt.maketext("output","mono").state(comment_state)
local openkerneltxt=gpt.maketext(" open kernel","mono").state(comment_state)
local info=pattern()
info.array=g.parse("bo$b2o$obo6bo2bo2bobobobo3bobobob3ob2o2b3o$8bobobo2bobobobo3bobobobo3bobobo$8bobob2obobobobo3bob3ob3ob2o2b3o$8b3obob2o2bo2bobobobobobo3bobobo$8bobobo2bo2bo3bobo2bobob3obobob3o!")

g.setrule("Life")

local function E_shell_pattern()
 --local extralanesnarkSoDsplitter=pattern()
 --extralanesnarkSoDsplitter.array=g.parse("bo$obo$bobo$2bo6$6b2o$5bobo$4bobo$5bo!")
 --extralanesnarkSoDsplitter=extralanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(17-shellSoD_presnarkDist,-3+shellSoD_presnarkDist)

 --local midlanesnarkSoDsplitter=pattern()
 --midlanesnarkSoDsplitter.array=g.parse("2o$obo$b2o2$15b2o$15b2o!")
 --midlanesnarkSoDsplitter=midlanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(23-shell_lane_dist-shellSoD_presnarkDist,8+shell_lane_dist+shellSoD_presnarkDist)

 --local firstlanesnarkSoDsplitter=(gpo.tub.t(1,14)+gpo.blinker.t(2,1))[SoD_phase].state(SoD_state).t(17-2*shell_lane_dist-shellSoD_presnarkDist,5+2*shell_lane_dist+shellSoD_presnarkDist)
 --local loopSoDsplitter=(gpo.tub.t(1,14)+gpo.blinker.t(2,1,gp.rcw))[SoD_phase].state(SoD_state).t(23-2*shell_lane_dist-shellSoD_presnarkDist,11+2*shell_lane_dist+shellSoD_presnarkDist)
 --local loopSoDturner=gpo.long_boat.state(SoD_state).t(148-2*shell_lane_dist-shellSoD_presnarkDist,-106+2*shell_lane_dist+shellSoD_presnarkDist,gp.rcw)

 local constructionstopper=pattern()
 constructionstopper.array=g.parse("2o$2o!")
 constructionstopper=constructionstopper.t(-21-constr_lane_dist,-13+constr_lane_dist).state(shell_state)

 local constructionlaneblockingeater=gpo.eater.state(shell_state).t(58+4-constr_lane_dist-shell_lane0_dist-shell_lane_dist,58+5+constr_lane_dist-shell_lane0_dist-shell_lane_dist,gp.swap_xy_flip)

 local constructionarmtarget=gpo.block.t(-72-constr_lane_dist,74-constr_lane_dist).state(construction_target_state)
 local constructionarmtargetSoD=gpo.block.t(-97-constr_lane_dist,44-constr_lane_dist).state(SoD_state)
    --local constructiontarget=gpo.block.t(-8+28-constr_lane_dist,10-52-constr_lane_dist)
 -- ^ changed

 local oriconstructionarmtarget=gpo.block.state(comment_state).t(1-oriconstr_lane_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist,0-oriconstr_lane_dist+shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist)

 local E=pattern()+positionmark
 E=E+filltxt.t(-6-2*shell_lane0_dist-5*shell_lane_dist-shell_last_extra_dist,15+0*shell_lane0_dist-shell_lane_dist-shell_last_extra_dist)
 E=E+filltxt.t(0-2*shell_lane0_dist-3*shell_lane_dist,15+0*shell_lane0_dist-shell_lane_dist,gp.rcw)
 E=E+filltxt.t(20-2*shell_lane0_dist-shell_lane_dist,20+0*shell_lane0_dist-shell_lane_dist,gp.flip)
 E=E --+constructiontarget
         +constructionarmtarget+constructionarmtargetSoD
         +constructionlaneblockingeater+constructionstopper+oriconstructionarmtarget
 E=E+openkernelglider
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64)
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64,gp.rcw)
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64,gp.flip)
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64,gp.rccw)
 -- E=E+gpo.blinker.t(-open_kernel_lane+82,-open_kernel_lane-92,gp.rcw)+gpo.blinker.t(-open_kernel_lane+86,-open_kernel_lane-92,gp.rcw)
 --        +gpo.long_boat.t(-constr_lane_dist+93,-constr_lane_dist-89,gp.rcw) -- debug timing
 --E=E+(gpo.block.t(8,-19)).state(SoD_state).t(-open_kernel_lane-shell_lane0_dist-shell_lane_dist,-open_kernel_lane+shell_lane0_dist+shell_lane_dist)
 --E=E+(gpo.pond.t(-16,-3)+gpo.beehive.t(-7,-7,gp.rcw)).state(SoD_state).t(-open_kernel_lane-shell_lane0_dist-3*shell_lane_dist,-open_kernel_lane+shell_lane0_dist+3*shell_lane_dist)
 --E=E+(gpo.pond.t(-20,12)+gpo.beehive.t(-24,21)).state(SoD_state).t(-2*shell_lane0_dist-5*shell_lane_dist,0)
 E=E+(longboatloaf_ots.t(-7-8+12,11-24+12,gp.rcw)).state(SoD_state).t(-2*shell_lane0_dist-3*shell_lane_dist,0-2*shell_lane_dist)
 E=E+(tubblinker_ots[1].t(-148+12,123+12)).state(SoD_state).t(-2*shell_lane0_dist-3*shell_lane_dist,0-2*shell_lane_dist)  -- shell eater (and maybeblock) SoD 1/2
    + shipblinker_ots[0].t(-14,5,gp.rccw).state(SoD_state).t(-constr_lane_dist-open_kernel_lane,constr_lane_dist-open_kernel_lane) -- shell eater (and maybeblock) SoD 2/2 (+/-2 shift compensates the phase)
    +(pondbeehive_ots.t(0,15,gp.rccw)+tubblinker_ots[1].t(-14,0,gp.flip)).state(SoD_state).t(-SoD_lane-open_kernel_lane,SoD_lane-open_kernel_lane) -- maybeott SoD

    E=E+(snark.state(shell_state)+snark_SoDOpp.state(SoD_state)--+firstlanesnarkSoDsplitter+loopSoDsplitter+loopSoDturner
     ).t(-2*shell_lane0_dist-shell_lane_dist,0*shell_lane0_dist-shell_lane_dist).t(-6,-13)
 E=E+(snark.state(shell_state)+snark_SoDOpp.state(SoD_state)--+midlanesnarkSoDsplitter
     ).t(-2*shell_lane0_dist-3*shell_lane_dist,0*shell_lane0_dist-shell_lane_dist).t(-6,-13)
 E=E+(snark.state(shell_state)+snark_SoDOpp.state(SoD_state)--+extralanesnarkSoDsplitter +(gpo.pond.t(-9,21)+gpo.blinker.t(-3,27))[SoD_phase].state(SoD_state) -- destroy eater after reflector to shell construction
       ).t(-2*shell_lane0_dist-5*shell_lane_dist-shell_last_extra_dist,0*shell_lane0_dist-shell_lane_dist-shell_last_extra_dist).t(-6,-13)
 return E
end

local function SE_shell_pattern()
 --local scorbie_SoD_turner = blinker2_ott90[SoD_phase].t(23,-8,gp.rcw).state(SoD_state)

 local SE_SoD_turner=gpo.boat.t(64-21,64+17).state(SoD_state)
 local SE_SoD_spitter=boatloaf_ots.t(64-3,64-55).state(SoD_state)

 local prescorbie_SoD_turner=gpo.boat.t(64-12,64-41).state(SoD_state)

 local SE=pattern()+positionmark
 SE=SE+(scorbieturn.state(shell_state)+(scorbieturninsert_SoD +gpo.blinker.t(-10,-35)).state(SoD_state)
    ).t(-input_lane0_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist,input_lane0_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-shell_lane0_dist,input_lane0_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(-2-input_lane0_dist-shell_lane0_dist,36+input_lane0_dist-shell_lane0_dist)
 SE=SE+inputtime1txt.t(-2-input_lane0_dist-shell_lane0_dist,46+input_lane0_dist-shell_lane0_dist)

 SE=SE+(scorbieturn.state(shell_state)+(scorbieturninsert_SoD+gpo.boat.t(-53,-79,gp.rcw)+longboatblinker_ots[1].t(-38,-60)+gpo.long_boat.t(-37,-54)).state(SoD_state)
       ).t(-input_lane0_dist-input_lane1_dist-shell_lane0_dist-2*shell_lane_dist,input_lane0_dist+input_lane1_dist-shell_lane0_dist-2*shell_lane_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane1_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(36-input_lane0_dist-input_lane1_dist-shell_lane0_dist,40+input_lane0_dist+input_lane1_dist-shell_lane0_dist,gp.rcw)
 SE=SE+inputtime2txt.t(26-input_lane0_dist-input_lane1_dist-shell_lane0_dist,40+input_lane0_dist+input_lane1_dist-shell_lane0_dist,gp.rcw)

 SE=SE+(scorbieturn.state(shell_state)+(scorbieturninsert_SoD+blinker2_ott90.t(-6,-32,gp.rcw)).state(SoD_state)).t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist-shell_lane_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist-shell_lane_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(28-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,40+input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,gp.flip)
 SE=SE+inputtime3txt.t(28-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,30+input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,gp.flip)

 SE=SE+(scorbieturn.state(shell_state)+(scorbieturn_SoDOppEnd+blinker2_ott90.t(-29,-9,gp.rcw)).state(SoD_state)).t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(28-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,70+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,gp.rccw)
 SE=SE+inputtime4txt.t(38-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,70+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,gp.rccw)

 SE=SE+outputglider.t(input_lane0_dist-shell_lane0_dist,-input_lane0_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-69+input_lane0_dist-shell_lane0_dist,-64-input_lane0_dist-shell_lane0_dist,gp.flip)
 SE=SE+outputglider.t(input_lane0_dist+input_lane1_dist-shell_lane0_dist,-input_lane0_dist-input_lane1_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-68+input_lane0_dist+input_lane1_dist-shell_lane0_dist,-74+-input_lane0_dist-input_lane1_dist-shell_lane0_dist,gp.rccw)
 SE=SE+outputglider.t(input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-60+input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,-72-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist)
 SE=SE+outputglider.t(input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-60+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,-64-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,gp.rcw)

 SE=SE--.t(innerquadsize-DNAloopOctavoDist,-innerquadsize+DNAloopOctavoDist)
         +positionmark
 return SE
end

local function shell_corners_E_N_W_S() -- not shifted
 local E=E_shell_pattern()
 return E,E.t(0,0,gp.rccw),E.t(0,0,gp.flip),E.t(0,0,gp.rcw)
end

local function shell_sides_SE_NE_NW_SW() -- not shifted
 local SE=SE_shell_pattern()
 return SE,SE.t(0,0,gp.rccw),SE.t(0,0,gp.flip),SE.t(0,0,gp.rcw)
end

local E,N,W,S=shell_corners_E_N_W_S()
local SE,NE,NW,SW=shell_sides_SE_NE_NW_SW()

local function E_ori()
 local S=13
 E=E + ((scorbiesplit.state(DNA_loop_state) + (scorbiesplitinsert_SoDOpp+gpo.blinker[1].t(35+12,17-12)).state(SoD_state)).t(-2*DNA_loop_shrink,0)
         + (gpo.boat.t(71-3, 45+3, gp.rccw) + gpo.boat.t(65-3, 49+3, gp.rccw) + gpo.boat.t(60-3, 44+3, gp.rccw) + gpo.eater.t(50, 44, gp.swap_xy).t(-DNA_loop_shrink,DNA_loop_shrink)).state(build_child_shell_state)
         + (scorbiesplit.state(build_child_shell_state) + scorbiesplitnoinsert_SoDOpp.state(SoD_state)
           ).t(90, 47).t(-DNA_loop_shrink,DNA_loop_shrink)
         + (snark.state(send_DNA_state) +snark_SoDOpp.state(SoD_state)).t(169,118).t(-DNA_loop_shrink,DNA_loop_shrink)
         + (scorbieturn.state(send_DNA_state) + scorbieturn_SoDOpp.state(SoD_state)
           ).t(-33+170,349-170,gp.flip_y).t(-DNA_loop_shrink,DNA_loop_shrink)
         + (snark.state(send_DNA_state) + snark_SoDOpp.state(SoD_state)
           ).t(-44+170,331-170,gp.swap_xy_flip).t(-DNA_loop_shrink,DNA_loop_shrink)
         + (gpo.eater.state(send_DNA_state)
           ).t(137,89).t(-DNA_loop_shrink,DNA_loop_shrink)  -- fill prevent and its SoD
         + (snark.state(send_DNA_state) + snark_SoDOpp.state(SoD_state)
           ).t(525-0*DNA_loop_shrink-innerquadsize+input_lane0_dist+input_lane1_dist+input_lane2_dist,-264+0*DNA_loop_shrink+innerquadsize-input_lane0_dist-input_lane1_dist-input_lane2_dist,gp.flip_x)
       ).t(-2*DNA_outershell_dist-6,-46)
         +shipblinker_ots[0].t(3-SoD_lane+input_lane0_dist+input_lane1_dist+input_lane2_dist-innerquadsize,-15-SoD_lane-input_lane0_dist-input_lane1_dist-input_lane2_dist+innerquadsize,gp.rcw).state(SoD_state)
         +( pondbeehive_ots.t(constr_lane_dist+SoD_lane,-15+constr_lane_dist-SoD_lane,gp.rcw) + blinker2_ott90[0].t(5-1+2*SoD_lane,5,gp.rcw)  -- SoD Opp tree start  entrance to SoD opp sent path
         + tubblinker_ots[0].t(5+1+SoD_lane+constr_lane_dist,5-8+SoD_lane-constr_lane_dist,gp.flip_x) -- (child construction maybeblock shell SoD branch)
          ).t(0,0,gp.flip).state(SoD_state)
     + (scorbieturn.state(build_child_shell_state) + scorbieturn_SoDOpp.state(SoD_state) -- could be K shifted diagonaly or replaced by other OTT ... access point of NE construction lane
       ).t(69-DNA_outershell_dist-constr_lane_dist,-65-constr_lane_dist+DNA_outershell_dist,gp.flip)
 E=E+(gpo.boat.t(-6,5).state(send_DNA_state)+gpo.block.t(-14,7).state(SoD_state)).t(-310-open_kernel_lane,310-open_kernel_lane)
end

local function N_ori()
 N=N+((scorbiesplit.state(DNA_loop_state) + scorbiesplitinsertstopped_SoDOpp[1].state(SoD_state)).t(-2*DNA_loop_shrink,0)
     +gpo.boat.t(50+4, -26-4,gp.rccw).state(DNA_loop_state).t(-DNA_loop_shrink,-DNA_loop_shrink)
     +(gpo.boat.t(71-3, 45-3,gp.rccw)+gpo.boat.t(76-3, 40-3,gp.rccw)+gpo.boat.t(81-3, 35-3,gp.rccw)+gpo.boat.t(91-3, 35-3,gp.rccw)+gpo.eater.t(55-3,49-3,gp.swap_xy).t(-DNA_loop_shrink,DNA_loop_shrink)).state(build_child_shell_state)
    -- ^ clocked ott paths opening build paths to neighbors
    +(scorbiesplit.state(build_child_shell_state)+scorbiesplitnoinsert_SoDOpp.state(SoD_state)).t(90,47).t(-DNA_loop_shrink,DNA_loop_shrink) -- output to NE transfer path (includes directed shell build) maybe (scorbiesplitinsert_SoDOpp with blinker)
    +(snark.state(send_DNA_state)+snark_SoDOpp.state(SoD_state)
       + (gpo.boat.t(144,56,gp.rccw) -- entrance to SoD opp sent path
       + shipblinker_ots.t(21,-66,gp.flip) + blinker2_ott90.t(168+20,-227-20,gp.rcw)  -- SoD Opp tree start -2,-1,gp.flip_x for block2_ott90
       + tubblinker_ots.t(129,-176,gp.flip_y) -- (child construction maybeblock shell SoD branch)
         ).state(SoD_state)
     ).t(145+6, 94+6).t(-DNA_loop_shrink,DNA_loop_shrink) -- NE transfer path
    +(snark.state(send_DNA_state)+snark_SoDOpp.state(SoD_state)
     ).t(6+525-innerquadsize+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist,
         6-264-1+innerquadsize-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist,gp.flip_x).t(0*DNA_loop_shrink,0*DNA_loop_shrink) -- NE transfer path leaving the cell
    +(gpo.eater.state(send_DNA_state)).t(137,89).t(-DNA_loop_shrink,DNA_loop_shrink)  -- fill prevent and its SoD (shift not needed)
      ).t(-46+1,2*DNA_outershell_dist+6,gp.rccw)
    +(loafblinker_ott90.t(-13-SoD_lane-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist+innerquadsize,-4+SoD_lane-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist+innerquadsize,gp.flip)).state(SoD_state) -- opp SoD build path entrance
    +(snark.state(build_child_shell_state) + snark_SoDOpp.state(SoD_state)).t(80+constr_lane_dist-DNA_outershell_dist,56-DNA_outershell_dist-constr_lane_dist,gp.flip_x).t(0,0,gp.flip) -- NW build path
 N=N+(gpo.boat.t(-6,5).state(send_DNA_state)+gpo.block.t(-12,5).state(SoD_state)).t(-310-open_kernel_lane,310-open_kernel_lane).t(0,0,gp.rccw)

 local N_phasedCorectingReflector=pattern() -- includes 2 bordersnatches
 N_phasedCorectingReflector.array = g.parse("169bo$167b3o$166bo$156b2o8b2o$157bo$125b2o11bo18bobo$125b2o10bobo18b2o$137bobo32b2o$136b2ob3o2b2o26b2o$142bo2bo$136b2ob3o3bobo$136b2obo6b2o$172b2o$172b2o5$133b2o13b2o$133b2o13b2o25bo$118b2o53b3o$117bo2bo51bo$116bob2o52b2o$116bo$115b2o$130b2o$130bo$131b3o$133bo4$154b2o$155bo$155bobo$156b2o3$170b2o$170bobo$172bo$163b2o7b2o$163b2o7$153b2o$154bo$154bobo$155b2o4$48bo$47bobo123b2o$47bobo7b2o114bo$45b3ob2o6b2o112bobo$44bo19b2o105b2o$45b3ob2o13b2o$47bob2o4$60bo113b2o$59bobo112bo$58bo2bo93bo16bobo$59b2o9b2o83b3o14b2o$70b2o86bo$157b2o$161bo$48b2o110bobo$48b2o110bo2bo$161b2o8$4bo$3bobo56b2o$3bobo7b2o47bo$b3ob2o6b2o48b3o96b2o$o19b2o43bo96b2o$b3ob2o13b2o$3bob2o4$16bo$15bobo$14bo2bo$15b2o9b2o$26b2o3$4b2o$4b2o10$18b2o$18bo$19b3o$21bo!")
 local N_phasedCorectingReflectorSoD=pattern() -- does not include 2 bondersnatches
 N_phasedCorectingReflectorSoD.array = g.parse("29b2ob2o$29b2obo$32bo$32bobo$33b2o4$4bob2o$4b2o2bo$7b2o22$49b2o$50bo9b2o$47b3o9bo2bo$46bo13b2o$46b2o2$bo$obo$b2o10$49b2o$48bo2bo$49bobo$50bo4$51b2o$50bo2bo$51bobo$52bo14$24b2o$23bo2bo$24bobo$25bo!")
 N_phasedCorectingReflectorSoD=N_phasedCorectingReflectorSoD.t(125,-5)
 N=N+(N_phasedCorectingReflector.state(receive_DNA_state)
     + (N_phasedCorectingReflectorSoD
     +  shillelagh.t(68,55,gp.swap_xy)+gpo.block.t(72,54)+gpo.beehive.t(59,86,gp.rcw) -- bondersnatch_SoDOpp
     + (shillelagh.t(68,55,gp.swap_xy)+gpo.block.t(72,54)+gpo.beehive.t(59,86,gp.rcw)).t(-44,27) -- bondersnatch_SoDOpp
      ).state(SoD_state)
  ).t(16-32-293-5+shell_last_extra_dist, 16+255-5+2*shell_lane0_dist+6*shell_lane_dist+shell_last_extra_dist).t(-DNA_loop_shrink,DNA_loop_shrink)
end

local function W_ori()
 W=W+((scorbiesplit.state(DNA_loop_state) + scorbiesplitnoinsert_SoDOpp.state(SoD_state)).t(-2*DNA_loop_shrink,0)
    +(gpo.boat.t(65, 49,gp.rccw)
    +(gpo.boat.t(33,73,gp.flip)+gpo.eater.t(81,109,gp.rcw)).t(-DNA_loop_shrink,DNA_loop_shrink)).state(build_child_shell_state)
    +(scorbiesplit.state(build_child_shell_state) + scorbiesplitnoinsert_SoDOpp.state(SoD_state)).t(90,47).t(-DNA_loop_shrink,DNA_loop_shrink) -- NW shell construction/NW ori construction .. length critical
    +(snark.state(state_computation_state)+snark_SoDOpp.state(SoD_state)).t(169-2,118-2).t(-DNA_loop_shrink,DNA_loop_shrink)
    +(scorbiesplit.state(state_computation_state) + scorbiesplitnoinsert_SoDOpp[1].state(SoD_state)).t(182-2,166-2,gp.rcw).t(-DNA_loop_shrink,DNA_loop_shrink)
     +(snark.state(send_DNA_state)+snark_SoDOpp.state(SoD_state)).t(-44+170-2,331-170-2,gp.swap_xy_flip).t(-DNA_loop_shrink,DNA_loop_shrink) -- ori construction/state reading
    +gpo.eater.t(107-12-2,156+12-2,gp.rcw).state(send_DNA_state).t(-DNA_loop_shrink,DNA_loop_shrink) -- NW ori construction blocker
    +gpo.boat.t(93-12,138+11,gp.flip).state(send_DNA_state).t(-DNA_loop_shrink,DNA_loop_shrink) -- NW ori construction start .. length critical
    +(snark.state(send_DNA_state)+snark_SoDOpp.state(SoD_state)--(gpo.block.t(26,21)+gpo.ship.t(-36,88)+gpo.block.t(-22,91)).state(SoD_state)
     ).t(525-2-0*DNA_loop_shrink-innerquadsize+input_lane0_dist,-264-2+0*DNA_loop_shrink+innerquadsize-input_lane0_dist,gp.flip_x)
         ).t(2*DNA_outershell_dist+6,46,gp.flip) -- NW ori construction .. length critical
    +shipblinker_ots[0].t(-3+SoD_lane-input_lane0_dist+innerquadsize,15+SoD_lane+input_lane0_dist-innerquadsize,gp.rccw).state(SoD_state)
    +(snark.state(receive_DNA_state)+snark_SoDOpp.state(SoD_state)--(gpo.block.t(26,21)+gpo.block.t(4,46)+gpo.loaf.t(1,40,gp.flip)).state(SoD_state)
         --+gpo.glider[3].t(2,4,gp.flip).state(glider_trail_state)
     ).t(16+25+116+2*shell_lane0_dist+6*shell_lane_dist+shell_last_extra_dist,16+25+1-10-shell_last_extra_dist , gp.flip) -- dna fill
    +(scorbieturn.state(build_child_shell_state) + scorbieturn_SoDOpp.state(SoD_state)).t(-69+DNA_outershell_dist+constr_lane_dist,65+constr_lane_dist-DNA_outershell_dist) -- SW shell construction
    +( pondbeehive_ots.t(constr_lane_dist+SoD_lane,-15+constr_lane_dist-SoD_lane,gp.rcw) + blinker2_ott90[0].t(5-1+2*SoD_lane,5,gp.rcw)  -- SoD Opp tree start  entrance to SoD opp sent path
     + tubblinker_ots[0].t(5+1+SoD_lane+constr_lane_dist,5-8+SoD_lane-constr_lane_dist,gp.flip_x) -- (child construction maybeblock shell SoD branch)
     ).state(SoD_state)
       +((gpo.eater.t(0,0,gp.flip_y) -- state reading stoper (construction continues in DNA_loop_snarks)
       +boatloaf_ots.t(1-10,-30-10) + toad_ott90.t(8-10,-42-10) + gpo.boat.t(11+10,-23+10,gp.rcw) -- eater building seed
       +gpo.boat.t(-41,-56)+gpo.long_boat.t(-46,-62,gp.rccw)
       +gpo.boat.t(-43-2,-38-2,gp.flip)  -- state reading stopper destroy
      ).t(2,2).state(state_computation_state) -- state reading stoper replacement
      +(gpo.boat.t(6+1,-50-1,gp.flip)  -- state reading stopper destroy
       ).state(SoD_state)
     ).t(89+DNA_outershell_dist+constr_lane_dist+DNAloopOctavoDist,1+constr_lane_dist-DNA_outershell_dist-DNAloopOctavoDist)
 W=W+((gpo.boat.t(-6,5)+gpo.block.t(-14,7)).state(SoD_state).t(-310-open_kernel_lane,310-open_kernel_lane)).t(0,0,gp.flip) -- SW ori construction start
end

local function S_ori()
    S=S+((scorbiesplit.state(DNA_loop_state) + scorbiesplitnoinsert_SoDOpp.state(SoD_state)).t(-2*DNA_loop_shrink,0)
            +(gpo.boat.t(66, 50,gp.rccw) + gpo.boat.t(59, 45,gp.rccw) + gpo.eater.t(50,44,gp.swap_xy).t(-DNA_loop_shrink,DNA_loop_shrink)).state(build_child_shell_state)
            +(scorbiesplit.state(build_child_shell_state) + scorbiesplitnoinsert_SoDOpp.state(SoD_state)).t(90,47).t(-DNA_loop_shrink,DNA_loop_shrink)
            +(snark.state(send_DNA_state)+snark_SoDOpp.state(SoD_state)).t(145, 94).t(-DNA_loop_shrink,DNA_loop_shrink)
            +(snark.state(send_DNA_state)+snark_SoDOpp.state(SoD_state)).t(525-0*DNA_loop_shrink-innerquadsize+input_lane0_dist+input_lane1_dist,-264-1+0*DNA_loop_shrink+innerquadsize-input_lane0_dist-input_lane1_dist,gp.flip_x)
            +(gpo.eater.state(send_DNA_state)).t(137,89).t(-DNA_loop_shrink,DNA_loop_shrink)  --fill prevent
    ).t(46-1,-2*DNA_outershell_dist-6,gp.rcw)
            +shipblinker_ots[0].t(15+SoD_lane+input_lane0_dist+input_lane1_dist-innerquadsize,3-SoD_lane+input_lane0_dist+input_lane1_dist-innerquadsize,gp.flip).state(SoD_state)
            +( pondbeehive_ots.t(constr_lane_dist+SoD_lane,-15+constr_lane_dist-SoD_lane,gp.rcw) + blinker2_ott90[0].t(5-1+2*SoD_lane,5,gp.rcw)  -- SoD Opp tree start  entrance to SoD opp sent path
            + tubblinker_ots[0].t(5+1+SoD_lane+constr_lane_dist,5-8+SoD_lane-constr_lane_dist,gp.flip_x) -- (child construction maybeblock shell SoD branch)
            ).t(0,0,gp.rccw).state(SoD_state)
            +(snark.state(receive_DNA_state)+snark_SoDOpp.state(SoD_state)
            --+gpo.glider[1].t(0,2,gp.flip).state(glider_notrail_state)
    ).t(102+5-shell_last_extra_dist, -95-5-2*shell_lane0_dist-6*shell_lane_dist-shell_last_extra_dist, gp.rcw)
            +(snark.state(build_child_shell_state)+snark_SoDOpp.state(SoD_state)).t(80+constr_lane_dist-DNA_outershell_dist,56-DNA_outershell_dist-constr_lane_dist,gp.flip_x)
    S=S+((gpo.boat.t(-6,5).state(send_DNA_state)+gpo.block.t(-14,7).state(SoD_state)).t(-310-open_kernel_lane,310-open_kernel_lane)).t(0,0,gp.rcw)
end

local function DNA_loop()
local shift = 82+4*(DNAtimelog%2)
local speedupshift=4*19
local L=((snark.state(DNA_loop_state)+snark_SoDOpp.state(SoD_state)).t(-14,10,gp.rccw).t(DNA_loop_shrink,DNA_loop_shrink)).t(3*DNAloopOctavoDist,DNAloopOctavoDist,gp.flip) -- 1 dna loop delay
     +gpo.boat.state(DNA_loop_state).t(-16+149+5,-16+178+5+4*DNAloopOctavoDist,gp.flip).t(DNA_loop_shrink,-DNA_loop_shrink) -- destroy fill reflector
     +((snark.state(DNA_loop_state)+snark_SoDOpp.state(SoD_state)).t(-14,10,gp.rccw).t(-DNA_loop_shrink,DNA_loop_shrink)--+(gpo.blinker.t(-14,-19,gp.rcw)+gpo.boat.t(-14,-12,gp.flip))[1].state(SoD_state) -- 6 dna loop delay
     +(gpo.boat.t(16, -56, gp.flip) -- start NE construction
      +gpo.boat.t(21, -61, gp.flip) -- start SE construction
      +gpo.boat.t(26, -66, gp.flip) -- start SW construction
      +gpo.boat.t(31, -71, gp.flip)).state(build_child_shell_state) -- start NW construction
     +(gpo.block.t(34, -77) -- delay to fill the DNA in NW as well
      +gpo.block.t(37, -80) -- delay to fill the DNA in NW as well
      +gpo.block.t(40, -83)
      +gpo.boat.t(73, -131, gp.flip) -- destroy the eater at the end of 0 speedup
      +gpo.eater.t(76, -117, gp.flip_y) -- catching late "speedup" gliders
      ).state(clock_logic_state) -- delay to fill the DNA in NW as well
     +gpo.boat.t(45, -85, gp.flip).state(DNA_loop_state) -- remove DNA
     +(gpo.block.t(56, -101)+gpo.loaf.t(50, -97, gp.rcw)).state(clock_logic_state) -- send state + start SoD splitter
     +(gpo.block.t(85, -130)+gpo.block.t(89, -124)).state(SoD_state)
     ).t(2+2*DNAloopOctavoDist,2*DNAloopOctavoDist,gp.rcw)                                                                                                                           -- 6 dna loop delay neighborhood
     +gpo.boat.state(DNA_loop_state).t(-16+2-DNA_loop_shrink+2*DNAloopOctavoDist,-16+32-DNA_loop_shrink+2*DNAloopOctavoDist,gp.flip) -- first glider redirect to switch fill to clocks construction
     +tubblinker_ots.state(101).t(-16+30+2*DNAloopOctavoDist,-16+41+2*DNAloopOctavoDist)  -- mimicks moment in construction starting to work on clocks
     +blinker2_ott90.state(DNA_loop_state).t(-16+157+5+2*DNAloopOctavoDist,-16+174+5+2*DNAloopOctavoDist,gp.rcw) -- part1 turn to destroy fill reflector
     +((snark.state(DNA_loop_state)+snark_SoDOpp.state(SoD_state)).t(-14-22,10-22,gp.rccw).t(-3*DNA_loop_shrink,-3*DNA_loop_shrink)
      --+(gpo.block.t(7,-17)+gpo.block.t(23,-4)+gpo.loaf.t(17,0,gp.rcw)).state(SoD_state)
      +(boatsemisnark.state(clock_logic_state)+boatsemisnark_SoD.state(SoD_state) + semisnarkready).t(-129+1,-157-1) -- to make children and die
      +(gpo.tub.t(245,186)+gpo.tub.t(236,177)+gpo.tub.t(227,168)+gpo.tub.t(218,159)+gpo.tub.t(209,150)+gpo.tub.t(200,141)
      +gpo.boat.t(225,195,gp.flip)+gpo.boat.t(216,186,gp.flip)+gpo.boat.t(207,177,gp.flip)+gpo.boat.t(198,168,gp.flip)+gpo.boat.t(189,159,gp.flip)+gpo.boat.t(180,150,gp.flip)
      +gpo.blinker.t(232,187)+gpo.blinker.t(223,178,gp.rcw)+gpo.blinker.t(214,169)+gpo.blinker.t(205,160,gp.rcw)+gpo.blinker.t(196,151)+gpo.blinker.t(187,142,gp.rcw)
      +gpo.boat.t(183,135,gp.flip)  -- 0 speedup
     +(gpo.block.t(232,194)+gpo.block.t(223,185)+gpo.block.t(214,176)+gpo.block.t(205,167)+gpo.block.t(196,158)+gpo.block.t(187,149)
       +gpo.boat.t(242,186,gp.rccw)+gpo.tub.t(236,177)+gpo.tub.t(227,168)+gpo.tub.t(218,159)+gpo.tub.t(209,150)+gpo.tub.t(200,141)
       +gpo.boat.t(225,195,gp.flip)+gpo.boat.t(216,186,gp.flip)+gpo.boat.t(207,177,gp.flip)+gpo.boat.t(198,168,gp.flip)+gpo.boat.t(189,159,gp.flip)+gpo.boat.t(180,150,gp.flip)
       +gpo.blinker.t(223,178)+gpo.blinker.t(214,169,gp.rcw)+gpo.blinker.t(205,160)+gpo.blinker.t(196,151,gp.rcw)+gpo.blinker.t(187,142)
       +gpo.boat.t(183,135,gp.flip)).t(-speedupshift,-speedupshift)
     -- <7 speedup
      ).state(clock_logic_state)
      ).t(4+DNAloopOctavoDist,DNAloopOctavoDist,gp.identity)                                                                                   -- 5 dna loop delay neighborhood
     +((snark.state(DNA_loop_state)+snark_SoDOpp.state(SoD_state)).t(-14-22,10+22,gp.rccw)).t(-4*DNA_loop_shrink,2*DNA_loop_shrink).t(3,2*DNAloopOctavoDist,gp.flip_y)                       -- 4 dna loop delay
     +((snark.state(DNA_loop_state)+snark_SoDOpp.state(SoD_state)).t(-14,10,gp.rccw)).t(-3*DNA_loop_shrink,-5*DNA_loop_shrink).t(shift+1-2*DNAloopOctavoDist,shift,gp.swap_xy)          -- 3 dna loop delay
     +((snark.state(DNA_loop_state)+snark_SoDOpp.state(SoD_state)).t(-14,10,gp.rccw)).t(4*DNA_loop_shrink,-4*DNA_loop_shrink).t(shift-1,shift-2*DNAloopOctavoDist,gp.flip_x)           -- 2 dna loop delay
     +((scorbiesplit.state(receive_DNA_state)+(scorbiesplitinsert_SoDOpp+gpo.blinker.t(35+12,17-12)).state(SoD_state)).t(5,-5)
             --+boatloaf_ots.t(47,30,gp.rccw).state(SoD_state)
             +(gpo.boat.t(55+5+3,19+5-3) -- turn to open state fill
             +gpo.boat.t(130-16,45+16)).state(state_computation_state) -- turn to close state fill
             +snark.state(state_computation_state).t(123-2,169+2) -- state fill
             +gpo.block.t(149,190).state(SoD_state) -- snarkSoD
             +(gpo.loaf.t(69,266)+gpo.eater.t(64,268,gp.swap_xy)).state(state_computation_state) -- send state snark SoD spitter
     ).t(4+3*DNAloopOctavoDist,346+DNAloopOctavoDist,gp.rcw) --dna fill/clocks construction
     +gpo.eater.t(-16-160+3*DNAloopOctavoDist,-16+236+DNAloopOctavoDist,gp.swap_xy_flip).state(receive_DNA_state) -- clocks construction blocker (temporary ... depends on the method of ori construction)
     --debug stuff
--     +gpo.eater.t(-16-225+3*DNAloopOctavoDist,-16+170+DNAloopOctavoDist,gp.flip) -- debug stop clock recipe
--     +gpo.block.t(-16-220+3*DNAloopOctavoDist,-16+183+DNAloopOctavoDist) -- debug stop clock recipe
--     +gpo.block.t(-16-189+3*DNAloopOctavoDist,-16+203+DNAloopOctavoDist) -- debug stop clock recipe
return L.t(0,0,gp.flip)
end

local function ReadClock()
 local readclock=pattern()
 readclock.array=g.parse([[
332bo$332b3o$335bo$334bobo$334bobo$335bo5$350b2o$350b2o4$330b2o$329bob
o$329bo$328b2o7b2o$337b2o2$345b2obo$345b2ob3o$351bo$238bo106b2ob3o$
238b3o105bobo$241bo104bobo$240b2o6b2o97bo$247bobo$248bo99bo$346b3o$
345bo$235b2o108b2o$235b2o6b2o92b2o$243b2o92b2o2$252b2o$252b2o2$237b2o$
236bobo87b2o$236bo90bo$235b2o90bobo$328b2o3$323b2o$324bo$324bobo$325b
2o2$265bo8b2o$265b3o6b2o$268bo$220b2o45b2o13b2o62b2o$220b2o60bo63bo$
280bobo64b3o$280b2o67bo$211b2o$211bobo59b2o$212bo60b2o3$217b2o60bo$
217b2o59bobo$279b2o$210b2o$85b2o11bo110bobo$85b2o10bobo109bo60b2o$97bo
bo31b2o75b2o13b2o45b2o$96b2ob3o2b2o25bo91bo$102bo2bo23bobo84b2o6b3o$
96b2ob3o3bobo21b2o85b2o8bo$96b2obo6b2o4$191bo$191b3o$194bo$93b2o13b2o
83bobo$93b2o13b2o83bobo$78b2o114bo$77bo2bo$76bob2o$76bo$75b2o$90b2o
117b2o$90bo118b2o$91b3o23b2o$93bo24bo$115b3o4b2o$115bo6b2o65b2o$188bob
o$188bo86b2o6bo$187b2o7b2o77b2o4b3o$196b2o82bo24bo$280b2o23b3o$204b2ob
o100bo$204b2ob3o97b2o$210bo17b2o92b2o$204b2ob3o18b2o92bo$205bobo111b2o
bo$205bobo17b2o91bo2bo$206bo6b2o10b2o92b2o$213b2o74b2o13b2o$207bo14b2o
65b2o13b2o$205b3o14b2o$204bo$204b2o13b2o$196b2o21b2o$196b2o$216b2o$
216b2o73b2o6bob2o$268b2o21bobo3b3ob2o$147bo119bobo23bo2bo$147b3o62b2o
53bo25b2o2b3ob2o$150bo34b2o25b2o52b2o31bobo$149b2o6b2o27bo93b2o17bobo
10b2o$156bobo27bobo20b2o69b2o18bo11b2o$157bo29b2o20b2o$283b2o$283b2o
10b2o$144b2o149b2o$144b2o6b2o31b2o99b2o$152b2o31b2o99b2o2$161b2o126b2o
$161b2o126b2o2$146b2o144b2o$145bobo57b2o85b2o$145bo59bo$144b2o60b3o86b
2o$208bo52b2o32b2o$261bo$240b2o17bobo36b2o$233b2o5b2o17b2o37b2o$233b2o
$326b2o$326bobo$235b2o27b2o61bo$235b2o27b2o$229b2o$229b2o$270b2o$222bo
47b2o$222b3o41b2o$225bo40b2o$224b2o3$271b2o$271b2o$3b2o363bo$4bo363b3o
$2bo368bo$2b5o14b2o347b2o6b2o$7bo13bo355bobo$4b3o12bobo356bo$3bo15b2o$
3b4o106b2o145b2o$b2o3bo3b2o101b2o145b2o103b2o$o2b3o4b2o353b2o6b2o$2obo
369b2o$3bo100b2o149b2o$3b2o99bobo148b2o125b2o$105bo118b2o156b2o$224b2o
$11b2o180b2o172b2o$12bo97b2o81b2o171bobo$9b3o98b2o134b2o4b3o111bo$9bo
186b2o31b2o14bobo117b2o$103b2o91b2o31b2o15bo$102bobo120b2o$102bo96b2o
24b2o$101b2o13b2o81b2o65b2o$116bo149b2o$109b2o6b3o82b2o27b2o27b2o$109b
2o8bo82b2o27b2o27b2o$475bo$395bo8b2o67b3o$206b2o54b2o131b3o6b2o66bo$
206b2o47b2o5b2o134bo73b2o$255b2o38b2o100b2o13b2o$209b2o62b2o20b2o115bo
$209b2o62bobo134bobo67b2o$274bo135b2o69bo$148b2o62b2o90b2o175bob2o$
148bo63b2o89bobo97b2o68b2o4b3o2bo$146bobo155bo5b2o91b2o68b2o3bo3b2o$
146b2o35b2o11bo113b2o166b4o$183b2o10bobo266b2o15bo$131b2o62bobo31b2o
178bo53bobo12b3o$131b2o61b2ob3o2b2o25bo70b2o106bobo52bo13bo$200bo2bo
23bobo70b2o107b2o51b2o14b5o$140b2o52b2ob3o3bobo21b2o76b2o175bo$140b2o
6b2o44b2obo6b2o99bobo172bo$148b2o157bo92b2o78b2o$292b2o13b2o91b2o$293b
o$136bo153b3o6b2o$135bobo152bo8b2o$135b2o6b2o$143bo47b2o13b2o$144b3o
44b2o13b2o$146bo29b2o$175bo2bo$174bob2o$174bo$173b2o$188b2o195b2o$188b
o196bo$189b3o23b2o166bobo$191bo24bo166b2o$213b3o4b2o109b2o$213bo6b2o
109b2o35b2o$368b2o$328b2o$328b2o47b2o$377b2o6b2o$325b2o58b2o$325b2o2$
322b2o49bo$322b2o48bobo$372b2o6b2o$319b2o59bo$243b2o74b2o60b3o$244bo
138bo$244bobo69b2o$245b2o69b2o2$260b2o51b2o$260b2o51b2o3$243b2o$243b2o
5b2o$250b2o2$256bo$255bobo$248b2o6b2o$249bo$246b3o42b2o$246bo45bo81bo$
290bo81b3o$254b2o34b5o14b2o60bo$254b2o39bo13bo61b2o7bo$292b3o12bobo68b
3o$291bo15b2o68bo24bo$291b4o82b2o23b3o$289b2o3bo3b2o105bo$288bo2b3o4b
2o104b2o$288b2obo127b2o$291bo127bo$291b2o123b2obo$415bo2bo$416b2o$299b
2o85b2o13b2o$300bo85b2o13b2o$297b3o$297bo5$388b2o6bob2o$365b2o21bobo3b
3ob2o$364bobo23bo2bo$364bo25b2o2b3ob2o$363b2o31bobo$396bobo10b2o$397bo
11b2o6$120bo$120b3o$123bo$122b2o5$143b2o$143bobo$145bo$145b2o3$140b2o$
140bobo$142bo$142b2o6$131b2o$131b2o$123b2o$124bo$121b3o$121bo2$122bo$
121bobo$121bobo$119b3ob2o$118bo$119b3ob2o$121bob2o2$131b2o$131b2o7b2o$
140bo$138bobo$138b2o4$118b2o$118b2o5$134bo$133bobo$133bobo$134bo$135b
3o$137bo59$214bo$214b3o$217bo$216b2o7$226b2o$219b2o5bobo$219b2o7bo$
228b2o2$215bo$214bobob2o$214bobobobo$211b2obobobobo2bo$211bo2bo2b2ob4o
$213b2o4bo$219bobo$220b2o!
]])
 local readclockSoD=pattern()
 readclockSoD.array=g.parse([[
72b2o$72b2o2$315b3o3$68b2o$68b2o4$347bo$346bobo$346bobo$347bo3$241b2o$
90b2o149b2o$83b3o4bobo$91bobo$92bo7$84b2o$84bobo$86bo$86b2o2$227bo$
226bobo86b3o$226bobo51b2o$227bo52b2o2$97b3o3$254b2o28b2o$254b2o28b2o$
103b3o118b2o37b2o$224b2o36bo2bo$263b2o9$92bo$92bo17b3o$92bo107b2o$200b
2o$280b2o$280b2o11$217b2o$216bo2bo$217b2o$226b2o$226b2o$202bo$201bobo$
201b2o7$273b2o5b3o$273b2o7$233bo6b2o$232bobo4bobo$233b2o5bo4$124b2o$
124b2o5$120b2o$120b2o8bo$129bobo$129b2o$150b2o$150b2o$173b3o$314b2o$
314bobo$315bo4$174b2o$174b2o4$216bo$215bobo$136bo79b2o$135bobo$135bobo
$136bo7$133b2o$133b2o$126bo$125bobo$125bobo$126bo4$125bo$124bobo$124bo
bo$125bo$201b2o168b2o$200bobo168b2o$201bo68b2o$270b2o3$285b3o$274bo$
274bo$274bo$193b2o$193bobo$194bo4$93b2o262bo$93b2o99b2o160bobo$193bobo
160bobo$194bo162bo4$b2o$o2bo380b2o$o2bo380b2o$b2o351b2o37b2o$354b2o36b
o2bo$155b2o52bo72b2o109b2o$66bo87bobo52bo71bo2bo$65bobo42b2o43bo53bo
72b2o$66b2o41bo2bo36b2o$110b2o37b2o$89b2o28b2o$7b2o80b2o28b2o98b2o$7bo
bo209b2o26b2o$8bo176b2o59bo2bo$184bo2bo58bo2bo$185b2o60b2o$93b2o52bo$
93b2o51bobo102b2o$146bobo101bo2bo156b2o$147bo103b2o5b3o149b2o4$455bo$
455bo$455bo5$288b2o$287bo2bo95b2o$288b2o96b2o$279b2o$132b2o29bo115b2o$
132b2o29bo$163bo3$384bo$383bobo$221b2o160bobo$220bobo161bo$221bo5$232b
2o$232b2o4$225b2o$224bo$227bo72bo$225b2o8bo63bobo$234bobo62bo2bo66b2o$
234bobo63bobo66b2o$235bo65bo3$299b2o$299bobo$300b2o3$278b2o$278b2o2$
376b3o28b3o13$276b2o$276b2o5$280b2o$157b2o121b2o$156bobo$157bo8$398b2o
$397bo2bo$398b2o13$356bo$355bobo$342b3o11bo8$142b3o20$112bo$111bobo$
111bobo$112bo8$142b3o80$227b2o$226bo2bo$226bo2bo$227b2o!
]])
 readclockSoD=readclockSoD.t(0,-3)
 local send_state_salvo_seed=pattern()
 send_state_salvo_seed.array=g.parse([[
2o$2o6$2b3o72$92b2o$91bo2bo$91bo2bo$92b2o3$87b3o8$93b2o$93b2o5$96bo$
96bo$96bo57$171b2o$170bo2bo$170bo2bo$171b2o2$167bo$167bo$167bo7$172b2o
$172b2o6$174b3o44$236b2o$235bo2bo$235bo2bo$236b2o3$231b3o8$237b2o$237b
2o5$240bo$240bo$240bo29$287b2o$286bo2bo$286bo2bo$287b2o2$283bo$283bo$
283bo7$288b2o$288b2o6$290b3o16$324b2o$323bo2bo$323bo2bo$324b2o3$319b3o
8$325b2o$325b2o5$328bo$328bo$328bo$347b2o$346bo2bo$346bo2bo$347b2o2$
343bo$343bo$343bo6$359bo$358bobo$357bobo$357b2o3$352b2o$351bo2bo$352b
2o!
]])
 local S=2 -- SW shift of SoD incomming glider
 local C=3 -- SW shift for clock semi lane
 local D=1 -- SW shift of after a while destroyal
 local X=23
 return (readclock.state(clock_logic_state)+readclockSoD.t(5,7).state(SoD_state) --+gpo.boat.t(225,115).state(state_computation_state)
         +gpo.glider[1].t(324,134,gp.flip_y).state(comment_glider_state) -- clock starting glider
         +gpo.glider[1].t(55,116,gp.rcw).state(comment_glider_state) -- state sending circuit destroying glider
         +((gpo.block.t(30,30)+gpo.block.t(-12,-12)+gpo.block.t(-16,-16)+gpo.block.t(-20,-20)+gpo.block.t(-24,-24)+gpo.block.t(-28,-28)+gpo.block.t(-34,-34)).state(state_computation_state) -- state blocks
          +(gpo.block.t(-44,-27)+gpo.blinker.t(-37,-29, gp.rcw) -- nonzero antispeedup
           +gpo.blinker.t(20,35)+gpo.tub.t(28,37)+gpo.eater.t(50,32,gp.swap_xy)+gpo.boat.t(55,46,gp.flip) -- state 7 antispeedup
           ).state(clock_logic_state)
         +(gpo.long_boat.t(-272-S,-555+S, gp.rcw) -- SoD source
          +gpo.pond.t(88-S,-179+S)+gpo.beehive.t(97-S,-183+S,gp.rcw) -- repeat test zero and <7 split after state zeroed
          +gpo.block.t(-60,-19) -- catch zero destroyal for nonzero case
          +gpo.boat.t(179-S,-98+S,gp.flip)+gpo.loaf.t(171-S,-95+S,gp.rcw) -- repeat test 7 and continue to reflectors after a while split
          +gpo.block.t(13,58) -- catch 7 destroyal for <7 case
          +gpo.boat.t(338-S,72+S,gp.rcw)+gpo.boat.t(358-2-D,43+2+D) -- turnback after a while
          +gpo.block.t(202-D,-110+D)+gpo.block.t(207-D,-107+D)+gpo.boat.t(205-D,-115+D,gp.rcw) -- reflector for 7 case with catcher (<7 destroys the boat) but we need a pseudocatalyst and destroy it
          +gpo.pond.t(178+1-D,-123+1+D)+gpo.blinker.t(184+1-D,-126+1+D) -- split back to destroy the pseudocatalyst
          +gpo.loaf.t(165+3-D,-131+3+D)+gpo.block.t(161+3-D,-138+3+D) -- split to destroy 0,<7 catchers and half turn to conditional reflector for 7
          +gpo.loaf.t(-29+X+3,7+X+3,gp.rccw)+gpo.block.t(-33+X+3,13+X+3) -- targeting the catchers
          +gpo.loaf.t(166+3-D,-146+3+D,gp.rcw)+gpo.block.t(172+3-D,-150+3+D) -- split to 0 and second half turn to conditional reflector for 7
          +gpo.pond.t(155-D,-167+D)+gpo.block.t(148-D,-164+D) -- turn back to destroy catcher
          +gpo.blinker.t(47-D,-264+D)+gpo.tub.t(56-D,-265+D) -- turn back to hit the nonzero reflector
          +gpo.block.t(142-D,-197+D)+gpo.boat.t(139-D,-201+D,gp.rcw) -- reflector for nonzero case ... vanishing in both cases (zero destroys the boat)
         -- 7 antispeedup SoD stop
          ).state(clock_logic_state)
           ).t(220,-100)
         +(gpo.tub+gpo.blinker.t(1,-13,gp.rcw)).state(SoD_state).t(-176,-515)
         +send_state_salvo_seed.state(send_DNA_state).t(-173,-504)+gpo.glider.t(-86,-428,gp.flip).state(comment_glider_state)
         +(gpo.boat.t(541,-128,gp.flip)+gpo.long_boat.t(544,-126,gp.rccw)                                                     -- allow readclock start from NE
         +gpo.boat.t(372,322,gp.rccw)+gpo.long_boat.t(370,325)+gpo.boat.t(683,19)+gpo.loaf.t(516,-142)+gpo.boat.t(515,-150)   -- allow readclock start from SE
         +gpo.boat.t(151,241,gp.flip)+gpo.long_boat.t(153,244,gp.rcw)+gpo.boat.t(16,114,gp.rcw)+gpo.boat.t(412,-274)          -- allow readclock start from SW
         +gpo.boat.t(177,72,gp.rccw)+gpo.long_boat.t(174,74,gp.flip)+gpo.boat.t(463,-223)                                     -- allow readclock start from NW
         +gpo.boat.t(335-C,-277+C,gp.rcw)+gpo.blinker.t(331-C,-282+C,gp.rcw)+gpo.blinker.t(332-C,-281+C,gp.rcw)               -- conditional state 0 turn (0 speedup)
         +gpo.long_boat.t(405-C,-211+C,gp.flip)+gpo.boat.t(411-C,-201+C,gp.rccw)+gpo.long_boat.t(408-C,-199+C,gp.flip)        -- conditional state <7 split (<7 speedup)
         ).state(send_DNA_state)
         + (gpo.block.t(276,136)+gpo.block.t(279,229)+gpo.block.t(217,175)+gpo.block.t(231,127)                               -- to allow optional 0 neighbour
         + gpo.boat.t(581,-176,gp.rccw) + gpo.blinker.t(743,-24) + gpo.blinker.t(743,-20) -- to replace 0 from NE
         + gpo.pond.t(486,222)+gpo.beehive.t(495,226,gp.rcw) -- to destroy snark
         + gpo.loaf.t(387,325,gp.flip)+gpo.block.t(393,328) -- split to replace 0 from SE and NE
         + gpo.boat.t(378,337) -- to replace 0 from SE
         + gpo.pond.t(170,275)+gpo.beehive.t(174,284)+ gpo.boat.t(132,252,gp.rcw)  -- to replace 0 from SW
         + gpo.ship.t(128,33,gp.rcw)+gpo.blinker.t(141,25,gp.rcw)+gpo.blinker.t(158,5,gp.rcw)+gpo.blinker.t(162,5,gp.rcw) -- to replace 0 from NW
         + gpo.boat.t(17,146,gp.rcw) + gpo.boat.t(296,434) -- SoD starting path
         ).state(SoD_state)
       ).t(384-innerquadsize,-355)
end

local function mainClock()
 local SE_part=pattern()
 SE_part.array=g.parse("20bo$19bobo$19bobo$2b2ob2o13bo$o2bob2o$2obo$3bo$3b2o$b2o2bobo7bo$o2bo2b2o6bobo$b2o12bo4$12b2o3b2o$13bo3bo$10b3o5b3o$10bo9bo!")
 local SE_partSoD=pattern()
 SE_partSoD.array=g.parse([[
6bo$6bo$6bo2$b2o$o2bo$o2bo$b2o25$44b2o$43bobo$42bobo$43bo9$56b2o$55bob
o$54bobo$55bo8$67b2o$66bobo$65bobo$66bo8$78b2o$77bobo$76bobo$77bo8$89b
2o$88bobo$87bobo$88bo7$99b2o$98bobo$97bobo$98bo159$415b2o$415b2o30$
414b2o$414b2o4$418b2o$418b2o70$353b2o$352bobo$353bo!
]])
 local NW_part=pattern()
 NW_part.array=g.parse([[
39b2o$39bo$18b2o17bobo$11b2o5b2o17b2o$11b2o3$13b2o27b2o$13b2o27b2o$7b
2o$7b2o$48b2o$o47b2o$3o25bo15b2o$3bo23bobo14b2o$2b2o16b3o4b2o3$49b2o$
49b2o6$13b2o$13b2o3$8b2o$8b2o3$2b2o$2b2o4$7b2o$7b2o$3b2o$3b2o$44b2o$
44b2o$9b2o27b2o$9b2o27b2o3$40b2o$15b2o16b2o5b2o$16bo16b2o$13b3o$13bo
40b2o$54bobo$56bo$56b2o$58bo$56b3o$55bo$43b2o10b2o$43b2o2$46b2o$46b2o
2$49b2o$49b2o$54b2o$55bo$52b3o$52bo!
]])
 local NW_partSoD=pattern()
 NW_partSoD.array=g.parse([[
75bo$75bo$75bo$92b3o27$107b2o$107b2o6$106bo$106bo$34b2o70bo$33bobo$34b
o60bo$94bobo$94bo2bo$95b2o$99bo$99bo$99bo6$97bo$97bo$97bo6$48b2o$48bob
o$49bo26$6b3o4$b2o$o2bo$b2o$9bo$8bobo$7bobo$7b2o4$25b2o$24bobo$23bobo$
24bo4$32b2o$24bo6bobo$23bobo4bobo$22bobo6bo$22b2o4$31bo$30bobo$29bobo$
29b2o4$47b2o$46bobo$45bobo$46bo4$32bo$31bobo$32b2o!
]])

 return
 (SE_part.state(send_DNA_state)+SE_partSoD.t(-396,-260).state(SoD_state)
  + (boatsemisnark.state(clock_logic_state)+boatsemisnark_SoD.state(SoD_state)+semisnarkready).t(24-1,130+1,gp.rccw)
  + (gpo.boat.t(18-1,109+1,gp.flip)+gpo.block.t(86-1,177+1)+gpo.block.t(92-1,173+1)+gpo.boat.t(84-1,169+1,gp.rccw)).state(SoD_state) --stop and start semisnark SoD (to wait for correct first semisnark state)
  + (gpo.boat.t(-31-1,12+1,gp.rccw)).state(send_DNA_state) -- starting read clock
         --  + (gpo.loaf.t(-29,16,gp.rcw)+gpo.blinker.t(-32,27,gp.rcw)).state(transfer_DNA_state) -- starting read clock
 ).t(973-innerquadsize,-458)
 +
 (NW_part.state(send_DNA_state)+NW_partSoD.t(-46,1).state(SoD_state)+gpo.glider[1+2].t(-6-75115,13-75115,gp.swap_xy_flip).state(active_state)
  +(boatsemisnark.state(clock_logic_state)+boatsemisnark_SoD.state(SoD_state)+semisnarksemi).t(3-1,97+1)
  +(gpo.boat.t(35-1, 87+1, gp.flip) -- read state alarm clock gun start (we can use other barel of this gun instead)
   +gpo.block.t(25, 96) --
   ).state(send_DNA_state)
  +gpo.boat.t(24, 91, gp.rccw).state(SoD_state) -- stops semisnark series destroyal
 ).t(-5069-innerquadsize,-6501)
end

local function NE_ori()
end

local function SE_ori()
    SE = SE
            + (gpo.glider.t(6,-640,gp.flip) + gpo.glider.t(-7,-651,gp.flip) + gpo.glider.t(-11,-663,gp.flip)).state(send_DNA_state).t(-input_lane0_dist-input_lane1_dist-input_lane2_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist) -- turning SoD ott to an absorber
end

local function SW_ori()
end

local function NW_ori()
end

local function cell(mark)
    local ret
    ret = E.t(2*innerquadsize,0)+N.t(0,-2*innerquadsize)+W.t(-2*innerquadsize,0)+S.t(0,2*innerquadsize)
            +SE.t(innerquadsize,innerquadsize)+NE.t(innerquadsize,-innerquadsize)+NW.t(-innerquadsize,-innerquadsize)+SW.t(-innerquadsize,innerquadsize)
    if mark then
        return ret + positionmark
    end
    return ret
end

local function long_blockF(x,y,d1,d2)
    return gpo.glider[1].state(5).t(x+d1+d2+9,y+d1-d2+8,gp.identity)+
        gpo.loaf.t(x+d1+d2,y+d1-d2+1,gp.flip_x)+gpo.beehive.t(x+d1+d2,y+d1-d2-8,gp.rcw)+gpo.boat.t(x+d1-2,y+d1+6,gp.identity)+gpo.boat.t(x+d2+3,y-d2-8,gp.flip_y)
     +gpo.block.state(4).t(x,y)
end

local function long_blockB(x,y,d1,d2)
    return gpo.glider[1].state(5).t(x+d2-1,y-d2-12,gp.flip)+
            gpo.ship.t(x+d1+d2+13,y+d1-d2-4)+gpo.blinker.t(x+d1+d2+9,y+d1-d2-1)+gpo.boat.t(x+d1-4,y+d1+4,gp.identity)+gpo.boat.t(x+d2+15,y-d2-9,gp.flip)+gpo.blinker.t(x+d2+9,y-d2-10,gp.rcw)
            +gpo.block.state(4).t(x,y)
end

local block_build_dist = 86+innerquadsize//2
local _0e0p_cellS = cell(true)
        + long_blockB((innerquadsize-475),0,block_build_dist-86,block_build_dist).t(0,0,gp.identity)
        + long_blockB((innerquadsize-475),0,block_build_dist-86,block_build_dist).t(0,0,gp.rcw)
        + long_blockF((innerquadsize-475),0,block_build_dist,block_build_dist-44).t(0,0,gp.flip)
        + long_blockB((innerquadsize-475),0,block_build_dist,block_build_dist).t(0,0,gp.rccw)
        --+ gpo.block.t() --AGJF Ori targets
        --+ gpo.block.t((innerquadsize-475),0,gp.identity) --+ gpo.block.t(0, (innerquadsize-475),gp.rcw)
        --+ gpo.block.t(-(innerquadsize-475),0,gp.flip) + gpo.block.t(0, -(innerquadsize-475),gp.rccw)
onlyshell = false
if not onlyshell then
	E_ori()
	N_ori()
	W_ori()
	S_ori()
    NE_ori()
    SE_ori()
    SW_ori()
    NW_ori()
end
local _0e0p_cellF = cell(true)
        +DNA_loop()
        +ReadClock()+mainClock()
g.setrule("LifeHistory64")
--local _0e0p_cells = _0e0p_cellF+_0e0p_cellF.t(-halfsize,-halfsize)+_0e0p_cellF.t(halfsize,-halfsize)+_0e0p_cellS.t(halfsize,halfsize)+_0e0p_cellF.t(-halfsize,halfsize)
local _0e0p_cells = _0e0p_cellF+_0e0p_cellF.t(-halfsize,-halfsize)+_0e0p_cellF.t(halfsize,-halfsize)+_0e0p_cellF.t(halfsize,halfsize)+_0e0p_cellF.t(-halfsize,halfsize)
--_0e0p_cells.display("0e0pcells")
_0e0p_cellF.display("0e0pcellWithoutDNA")
--cell(true).display("0e0pshell")
g.setbase(2)
g.setstep(16)
g.setpos(startX,startY)
g.setmag(startMag)