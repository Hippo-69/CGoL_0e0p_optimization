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
local DNAFDlog = DNAtimelog-2
local DNAloopOctavoDist = 2^(DNAFDlog-3) // 3
local quadsize = 2^(DNAFDlog-3)--5*DNAloopOctavoDist --4096 -- to be callculated
local halfsize = 2*quadsize
local DNA_outershell_dist = 400
local innerquadsize = 2*DNAloopOctavoDist + DNA_outershell_dist -- to be choosen
local shell_lane0_dist = 48      -- 64 to be decided
local shell_lane_dist = 36       -- 64 to be decided
local shell_last_extra_dist = 28--28 -- 0 -- to be decided
local oriconstr_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+60
local constr_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+20
local input_lane0_dist = 123 -- 32 -- 64
local input_lane1_dist = 32+121 -- 64
local input_lane2_dist = 32+274 -- 64
local input_lane3_dist = 32+221 -- 64
local output_lane_dist = shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist+120
local shellSoD_presnarkDist = 13
local shell_SoD_lane = input_lane0_dist + input_lane1_dist + input_lane2_dist + input_lane3_dist + 40
local shell_SoD_lane_add = 16 
local open_kernel_lane = 419
local snark_delay = 22 -- includes change in cordinate system
local input_time1=4*innerquadsize-8192-4*input_lane0_dist+4*shell_lane0_dist+12*shell_lane_dist+4*shell_last_extra_dist
local input_time2=12*innerquadsize-8192-8*shell_lane0_dist-20*shell_lane_dist-4*shell_last_extra_dist+1*snark_delay-4*input_lane0_dist-4*input_lane1_dist+4*shell_lane0_dist+8*shell_lane_dist -- -570*4-2
local input_time3=20*innerquadsize-8192-16*shell_lane0_dist-32*shell_lane_dist-4*shell_last_extra_dist+2*snark_delay-4*input_lane0_dist-4*input_lane1_dist-4*input_lane2_dist+4*shell_lane0_dist+4*shell_lane_dist -- -570*4-2-(570-128)*4-2
local input_time4=28*innerquadsize-8192-24*shell_lane0_dist-36*shell_lane_dist-4*shell_last_extra_dist+3*snark_delay-4*input_lane0_dist-4*input_lane1_dist-4*input_lane2_dist-4*input_lane3_dist+4*shell_lane0_dist -- -570*4-2-(570-128)*4-2-(570-256)*4-2

-- states
local shell_state=9
local output_layer_state=9
local seed_state=13
local SoD_state=11
local SoD_glidermark_state=12
local SoD_phase=1
local active_state=5
local comment_state=4
local comment_glider_state=4

-- patterns
local snarkNES=pattern()
snarkNES.array=g.parse("13bo$11b3o$10bo$10b2o3$18b2o$19bo$19bob2o$11b2o4b3o2bo$11b2o3bo3b2o$16b4o$2b2o15bo$bobo12b3o$bo13bo$2o14b5o$20bo$18bo$18b2o!")
snarkNES=snarkNES.state(shell_state)

local tubsemisnark = gpo.eater.t(2,11,gp.rcw)+ gpo.eater.t(14,14)+ gpo.tub.t(3,4)+ gpo.block.t(11,-1)+gpo.block.t(7,16)
local boatsemisnarkwithSoD = (gpo.eater.t(2,11,gp.rcw)+ gpo.eater.t(14,14)+ gpo.boat.t(2,3)+ gpo.block.t(11,-1)+ gpo.block.t(7,16)).state(output_layer_state)
        +(gpo.block.t(-4,5)+gpo.block.t(22,22)+gpo.beehive.t(12,20)).state(SoD_state)
local semisnarksemi = gpo.block.t(6,9).state(active_state)+gpo.block.t(8,8).state(comment_state)
local semisnarkready = gpo.block.t(8,8).state(active_state)+gpo.block.t(6,9).state(comment_state)
local snarkNES_SoD1=pattern()
snarkNES_SoD1.array=g.parse("21$26b2o$26b2o!")
snarkNES_SoD1=snarkNES_SoD1[SoD_phase].state(SoD_state)

local snarkNES_withSoD1=(snarkNES+snarkNES_SoD1).t(-6,-13)

local output_snarkturn_withGsoDs=(snarkNES.t(-86,0,gp.flip_x)+snarkNES.t(-90,22,gp.swap_xy)
        +gpo.eater.t(-114,31,gp.flip_x)).state(output_layer_state)
        +gpo.glider[1].t(-123,-24,gp.flip).state(comment_glider_state)
        +(gpo.blinker[1].t(-90,51)+gpo.blinker.t(-115,0)+gpo.boat.t(-37,119)+gpo.blinker.t(-95,41)+gpo.tub.t(-108,42))[SoD_phase].state(SoD_state)

local scorbiesplitter=pattern()
scorbiesplitter.array=g.parse("46bo$46b3o$49bo$40bo7b2o$40b3o$18bo24bo$16b3o23b2o$15bo$15b2o$2o$bo$bob2o$2bo2bo$3b2o$18b2o13b2o$18b2o13b2o7$21b2obo6b2o$21b2ob3o3bobo21b2o$27bo2bo23bobo$21b2ob3o2b2o25bo$22bobo31b2o$10b2o10bobo$10b2o11bo!")
scorbiesplitter=scorbiesplitter.state(output_layer_state).t(-27,11)

local scorbiesplitter_SoD=pattern()
scorbiesplitter_SoD.array=g.parse("3o28b3o30$10b2o$9bo2bo$10b2o!")
scorbiesplitter_SoD=scorbiesplitter_SoD.t(6,-2).t(-27,11)

local scorbiesplitter_SoD=pattern()
scorbiesplitter_SoD.array=g.parse("3o28b3o30$10b2o$9bo2bo$10b2o!")
scorbiesplitter_SoD=scorbiesplitter_SoD.t(6,-2).t(-27,11)

local output_oppositeSoD_splitter=(gpo.pond+gpo.blinker[1].t(6,6))

local scorbiesplitter_withSoD = scorbiesplitter+scorbiesplitter_SoD[SoD_phase].state(SoD_state)
local scorbiesplitter_withSoDp1 = scorbiesplitter+scorbiesplitter_SoD[1+SoD_phase].state(SoD_state)

local scorbiesplitter_withSoD_andEater=scorbiesplitter_withSoD +
        gpo.eater.t(82,39).state(output_layer_state).t(-27,11)

local scorbieSE=pattern()
scorbieSE.array=g.parse("2bo$2b3o$5bo$4b2o6$24b2o$24b2o4$22b2o$22bobo$24bo$24b2o6$13b2o$13b2o$5b2o$6bo$3b3o$3bo2$4bo$3bobo$3bobo$b3ob2o$o$b3ob2o$3bob2o2$13b2o$13b2o7b2o$22bo$20bobo$20b2o4$2o$2o5$16bo$15bobo$15bobo$16bo$17b3o$19bo!")
scorbieSE=scorbieSE.state(shell_state)

local scorbieSE_SoD=pattern()
scorbieSE_SoD.array=g.parse("5$6b2o$6b2o10$3o22$9bo$8bobo$8bobo$9bo21$29b3o!")
scorbieSE_SoD=scorbieSE_SoD.t(-12,0)

local scorbieSE_SoD2=pattern()
scorbieSE_SoD2.array=g.parse("34b2o$34b2o7$34b3o9$2o$2o23$7b2o$6bobo$7bo!")
scorbieSE_SoD2=scorbieSE_SoD2.t(-4,12)

local scorbieSE_withSoD=(scorbieSE+scorbieSE_SoD[SoD_phase].state(SoD_state)).t(6,-17)
local scorbieSE_withSoD2=(scorbieSE+scorbieSE_SoD2[SoD_phase].state(SoD_state)).t(6,-17)

local scorbie_inputglider=pattern()
scorbie_inputglider.array=g.parse("2o$obo$o!")
scorbie_inputglider=scorbie_inputglider.state(comment_glider_state).t(25,53).t(6,-17)

local outputglider=pattern()
outputglider.array=g.parse("2bo$obo$b2o!")
outputglider=outputglider.state(comment_glider_state).t(-65,-70)

local glider_SoD=pattern()
glider_SoD.array=g.parse("bo$2bo$3o!")
glider_SoD=glider_SoD[SoD_phase].state(SoD_glidermark_state).t(-7,7)

local openkernelglider=gpo.glider[1].state(comment_glider_state).t(-open_kernel_lane+64,-open_kernel_lane-64,gp.rccw)

local positionmark=pattern()
positionmark.array=g.parse("o3bo$bobo$2bo$bobo$o3bo!")
positionmark=positionmark.state(comment_state).t(-2,-2)

local filltxt=gpt.maketext("fill","mono").state(comment_state)

local inputtxt=gpt.maketext("input","mono").state(comment_state)
local inputtime1txt=gpt.maketext(input_time1-input_time1+1024,"mono").state(comment_state)
local inputtime2txt=gpt.maketext(input_time2-input_time1+1024,"mono").state(comment_state)
local inputtime3txt=gpt.maketext(input_time3-input_time1+1024,"mono").state(comment_state)
local inputtime4txt=gpt.maketext(input_time4-input_time1+1024,"mono").state(comment_state)

local outputtxt=gpt.maketext("output","mono").state(comment_state)

local openkerneltxt=gpt.maketext(" open kernel","mono").state(comment_state)

g.setrule("Life")

local function E_shell_pattern()
 local extralanesnarkSoDsplitter=pattern()
 extralanesnarkSoDsplitter.array=g.parse("bo$obo$bobo$2bo6$6b2o$5bobo$4bobo$5bo!")
 extralanesnarkSoDsplitter=extralanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(17-shellSoD_presnarkDist,-3+shellSoD_presnarkDist)

 local midlanesnarkSoDsplitter=pattern()
 midlanesnarkSoDsplitter.array=g.parse("2o$obo$b2o2$15b2o$15b2o!")
 midlanesnarkSoDsplitter=midlanesnarkSoDsplitter[SoD_phase].state(SoD_state).t(23-shell_lane_dist-shellSoD_presnarkDist,8+shell_lane_dist+shellSoD_presnarkDist)

 local firstlanesnarkSoDsplitter=(gpo.tub.t(1,14)+gpo.blinker.t(2,1))[SoD_phase].state(SoD_state).t(17-2*shell_lane_dist-shellSoD_presnarkDist,5+2*shell_lane_dist+shellSoD_presnarkDist)
 local loopSoDsplitter=(gpo.tub.t(1,14)+gpo.blinker.t(2,1,gp.rcw))[SoD_phase].state(SoD_state).t(23-2*shell_lane_dist-shellSoD_presnarkDist,11+2*shell_lane_dist+shellSoD_presnarkDist)
 local loopSoDturner=gpo.long_boat.state(SoD_state).t(148-2*shell_lane_dist-shellSoD_presnarkDist,-106+2*shell_lane_dist+shellSoD_presnarkDist,gp.rcw)

 local constructionlaneblockingeaterSoDsplitter=(gpo.tub.t(13,1)+gpo.blinker.t(0,2,gp.rcw))[SoD_phase].state(SoD_state).t(51-2*shell_lane0_dist-3*shell_lane_dist-shellSoD_presnarkDist,59+shell_lane_dist+shellSoD_presnarkDist)

 local constructionstopperSoDtuner=pattern()
 constructionstopperSoDtuner.array=g.parse("bo$obo$2o!")
 constructionstopperSoDtuner=constructionstopperSoDtuner[SoD_phase].state(SoD_state).t(-16-shell_lane0_dist-2*shell_lane_dist-shellSoD_presnarkDist,-19+shell_lane0_dist+2*shell_lane_dist+shellSoD_presnarkDist)

 local constructionstopper=pattern()
 constructionstopper.array=g.parse("2o$2o!")
 constructionstopper=constructionstopper.state(shell_state)

 local constructionprestopper=gpo.block

 local constructionstopperSoD=pattern()
 constructionstopperSoD.array=g.parse("2o$2o!")
 constructionstopperSoD=constructionstopperSoD[SoD_phase].state(SoD_state).t(-7,-4)

 local constructionstopperwithSoD=(constructionstopper+constructionstopperSoD+constructionprestopper.t(31,20)).t(-21-constr_lane_dist,-13+constr_lane_dist)

 local constructionlaneblockingeater=gpo.eater.state(shell_state).t(58-constr_lane_dist-shell_lane0_dist-shell_lane_dist,58+constr_lane_dist-shell_lane0_dist-shell_lane_dist,gp.flip)

 local constructiontarget=gpo.block.state(comment_state).t(-8-constr_lane_dist,10-constr_lane_dist)

 local oriconstructiontarget=gpo.block.state(comment_state).t(1-oriconstr_lane_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist,0-oriconstr_lane_dist+shell_lane0_dist+3*shell_lane_dist+shell_last_extra_dist)

 local E=pattern()+positionmark
 E=E+filltxt.t(-6-2*shell_lane0_dist-5*shell_lane_dist-shell_last_extra_dist,15+0*shell_lane0_dist-shell_lane_dist-shell_last_extra_dist)
 E=E+filltxt.t(0-2*shell_lane0_dist-3*shell_lane_dist,15+0*shell_lane0_dist-shell_lane_dist,gp.rcw)
 E=E+filltxt.t(20-2*shell_lane0_dist-shell_lane_dist,20+0*shell_lane0_dist-shell_lane_dist,gp.flip)
 E=E+constructiontarget+constructionlaneblockingeater+constructionstopperwithSoD+oriconstructiontarget+constructionlaneblockingeaterSoDsplitter+constructionstopperSoDtuner
 E=E+openkernelglider
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64)
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64,gp.rcw)
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64,gp.flip)
 E=E+openkerneltxt.t(-open_kernel_lane+64,-open_kernel_lane-64,gp.rccw)
 E=E+gpo.blinker.t(-open_kernel_lane+82,-open_kernel_lane-92,gp.rcw)+gpo.blinker.t(-open_kernel_lane+86,-open_kernel_lane-92,gp.rcw)
         +gpo.long_boat.t(-constr_lane_dist+93,-constr_lane_dist-89,gp.rcw) -- debug timing
 E=E+(gpo.pond.t(-8,20)+gpo.beehive.t(-4,14)+gpo.ship.t(-18,6)+gpo.block.t(-33,2)).state(SoD_state).t(-open_kernel_lane,-open_kernel_lane)
 E=E+(snarkNES_withSoD1+firstlanesnarkSoDsplitter+loopSoDsplitter+loopSoDturner).t(-2*shell_lane0_dist-shell_lane_dist,0*shell_lane0_dist-shell_lane_dist)
 E=E+(snarkNES_withSoD1+midlanesnarkSoDsplitter).t(-2*shell_lane0_dist-3*shell_lane_dist,0*shell_lane0_dist-shell_lane_dist)
 E=E+(snarkNES_withSoD1+extralanesnarkSoDsplitter
         +(gpo.pond.t(-9,21)+gpo.blinker.t(-3,27))[SoD_phase].state(SoD_state) -- destroy eater after reflector to shell construction
       ).t(-2*shell_lane0_dist-5*shell_lane_dist-shell_last_extra_dist,0*shell_lane0_dist-shell_lane_dist-shell_last_extra_dist)
 return E
end

local function SE_shell_pattern()
 local scorbie_SoD_turner=pattern()
 scorbie_SoD_turner.array=g.parse("o$o$o2$o$o$o!")
 scorbie_SoD_turner=scorbie_SoD_turner[SoD_phase].state(SoD_state).t(23,-8)

 --local SE_SoD_turner=pattern()
 --SE_SoD_turner.array=g.parse("b2o$obo$bo!")
 --SE_SoD_turner=SE_SoD_turner[SoD_phase].state(SoD_state).t(64-21,64+17)
 --local SE_SoD_spitter=pattern()
 --SE_SoD_spitter.array=g.parse("2bo$bobo$o2bo$b2o3$10b2o$9bobo$10bo!")
 --SE_SoD_spitter=SE_SoD_spitter[SoD_phase].state(SoD_state).t(64-3,64-55)

 local prescorbie_SoD_turner=pattern()
 prescorbie_SoD_turner.array=g.parse("2o$obo$bo!")
 prescorbie_SoD_turner=prescorbie_SoD_turner[SoD_phase].state(SoD_state).t(64-12,64-41)

 local SE=pattern()+positionmark
 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist,input_lane0_dist-shell_lane0_dist-3*shell_lane_dist-shell_last_extra_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-shell_lane0_dist,input_lane0_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(-2-input_lane0_dist-shell_lane0_dist,36+input_lane0_dist-shell_lane0_dist)
 SE=SE+inputtime1txt.t(-2-input_lane0_dist-shell_lane0_dist,46+input_lane0_dist-shell_lane0_dist)

 SE=SE+scorbie_SoD_turner.t(-input_lane0_dist-shell_lane0_dist-2*shell_lane_dist,input_lane0_dist-shell_lane0_dist-2*shell_lane_dist)

 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-input_lane1_dist-shell_lane0_dist-2*shell_lane_dist,input_lane0_dist+input_lane1_dist-shell_lane0_dist-2*shell_lane_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane1_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(36-input_lane0_dist-input_lane1_dist-shell_lane0_dist,40+input_lane0_dist+input_lane1_dist-shell_lane0_dist,gp.rcw)
 SE=SE+inputtime2txt.t(26-input_lane0_dist-input_lane1_dist-shell_lane0_dist,40+input_lane0_dist+input_lane1_dist-shell_lane0_dist,gp.rcw)

 SE=SE+scorbie_SoD_turner.t(-input_lane0_dist-input_lane1_dist-shell_lane0_dist-shell_lane_dist,input_lane0_dist+input_lane1_dist-shell_lane0_dist-shell_lane_dist)

 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist-shell_lane_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist-shell_lane_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(28-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,40+input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,gp.flip)
 SE=SE+inputtime3txt.t(28-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,30+input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,gp.flip)

 SE=SE+scorbie_SoD_turner.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist)

 SE=SE+scorbieSE_withSoD.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist)
 SE=SE+scorbie_inputglider.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist)
 SE=SE+inputtxt.t(28-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,70+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,gp.rccw)
 SE=SE+inputtime4txt.t(38-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,70+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,gp.rccw)
 SE=SE+(gpo.loaf.t(24,52,gp.flip)+gpo.block.t(16,52)+gpo.boat.t(32,55,gp.rcw)).state(SoD_state).t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist)
 SE=SE+prescorbie_SoD_turner.t(-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist)


 SE=SE.t(-2*innerquadsize+2*DNAloopOctavoDist,2*innerquadsize-2*DNAloopOctavoDist)+positionmark

 SE=SE+outputglider.t(input_lane0_dist-shell_lane0_dist,-input_lane0_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-69+input_lane0_dist-shell_lane0_dist,-64-input_lane0_dist-shell_lane0_dist,gp.flip)
 SE=SE+outputglider.t(input_lane0_dist+input_lane1_dist-shell_lane0_dist,-input_lane0_dist-input_lane1_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-68+input_lane0_dist+input_lane1_dist-shell_lane0_dist,-74+-input_lane0_dist-input_lane1_dist-shell_lane0_dist,gp.rccw)
 SE=SE+outputglider.t(input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-60+input_lane0_dist+input_lane1_dist+input_lane2_dist-shell_lane0_dist,-72-input_lane0_dist-input_lane1_dist-input_lane2_dist-shell_lane0_dist)
 SE=SE+outputglider.t(input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist)
 SE=SE+outputtxt.t(-60+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist-shell_lane0_dist,-64-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist-shell_lane0_dist,gp.rcw)

 SE=SE.t(innerquadsize-DNAloopOctavoDist,-innerquadsize+DNAloopOctavoDist)+positionmark

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

local function E_output()
 E=E+(scorbiesplitter_withSoD
    +(gpo.boat.t(70, 44,gp.rccw)+gpo.boat.t(65, 49,gp.rccw)+gpo.boat.t(60, 44,gp.rccw) + gpo.eater.t(50,44,gp.swap_xy)).state(output_layer_state)
    +scorbiesplitter_withSoD.t(90,47)
    +snarkNES.state(output_layer_state).t(169,118)+scorbieSE_withSoD.t(-33+170,349-170,gp.flip_y)+snarkNES.state(output_layer_state).t(-44+170,331-170,gp.swap_xy_flip)
    +snarkNES.state(output_layer_state).t(525-DNAloopOctavoDist+input_lane0_dist+input_lane1_dist+input_lane2_dist,-264+DNAloopOctavoDist-input_lane0_dist-input_lane1_dist-input_lane2_dist,gp.flip_x)
         +(gpo.eater.state(output_layer_state)+(gpo.pond.t(-16,15)+gpo.blinker.t(-10,21,gp.rcw))[SoD_phase].state(SoD_state)).t(137,89)).t(-2*DNA_outershell_dist-6,-46) --+gpo.blinker.t(-36,9)[SoD_phase].state(SoD_state)
    +(scorbieSE_withSoD2+
       (gpo.loaf.t(22,-20,gp.flip)+gpo.beehive.t(19,-39)+gpo.boat.t(-42,9,gp.rcw))[SoD_phase].state(SoD_state) -- destroyal path
         +gpo.eater.t(-32,-26,gp.swap_xy_flip).state(output_layer_state) -- to block the lane not going to shell construction
     ).t(69-DNA_outershell_dist-constr_lane_dist,-65-constr_lane_dist+DNA_outershell_dist,gp.flip)
 E=E+(gpo.boat.t(-6,5)+gpo.block.t(-14,7)).state(SoD_state).t(-310-open_kernel_lane,310-open_kernel_lane)
 -- E=E+(snarkNES.t(0,0,gp.swap_xy).state(output_layer_state)
--  +scorbiesplitter_withSoD.t(-185,-144)
--  +gpo.eater.t(28,-4,gp.rccw).state(output_layer_state)
--  +gpo.glider[1].state(comment_glider_state).t(-142,-161,gp.flip_y)
--  +(gpo.block.t(21,26)+gpo.eater.t(27,25)+gpo.boat.t(37,16,gp.rccw))[SoD_phase].state(SoD_state)).t(135,41).t(-2*output_lane_dist,0)
end

local function N_output()
 --local info=pattern()
 --info.array=g.parse("bo$b2o$obo6bo2bo2bobobobo3bobobob3ob2o2b3o$8bobobo2bobobobo3bobobobo3bobobo$8bobob2obobobobo3bob3ob3ob2o2b3o$8b3obob2o2bo2bobobobobobo3bobobo$8bobobo2bo2bo3bobo2bobob3obobob3o!")
 N=N+(scorbiesplitter
    + (gpo.boat.t(50, -26,gp.rccw) +gpo.boat.t(71, 45,gp.rccw)+gpo.boat.t(76, 40,gp.rccw)+gpo.boat.t(81, 35,gp.rccw)+gpo.boat.t(91, 35,gp.rccw) + gpo.eater.t(55,49,gp.swap_xy)).state(output_layer_state)
    +scorbiesplitter_withSoD.t(90,47)
    +snarkNES.state(output_layer_state).t(145, 94)
    +snarkNES.state(output_layer_state).t(525-DNAloopOctavoDist+input_lane0_dist+input_lane1_dist+input_lane2_dist+input_lane3_dist,
         -264+DNAloopOctavoDist-1-input_lane0_dist-input_lane1_dist-input_lane2_dist-input_lane3_dist,gp.flip_x)
         +(gpo.eater.state(output_layer_state)+(gpo.pond.t(-16-97,14+97)+gpo.blinker.t(-10-97,20+97,gp.rcw))[SoD_phase].state(SoD_state)).t(137,89)).t(-46+1,2*DNA_outershell_dist+6,gp.rccw)
    +snarkNES.state(output_layer_state).t(80+constr_lane_dist-DNA_outershell_dist,56-DNA_outershell_dist-constr_lane_dist,gp.flip_x).t(0,0,gp.flip)
    +((gpo.block+gpo.blinker.t(19,25,gp.rcw)+gpo.blinker.t(23,25,gp.rcw))[SoD_state].state(SoD_state) -- destroyal path+SoD
         +gpo.eater.t(-15,24,gp.flip_x).state(output_layer_state)                                        -- eater blocking lane to shell construction
     ).t(53+constr_lane_dist-DNA_outershell_dist,77-DNA_outershell_dist-constr_lane_dist).t(0,0,gp.flip)
    +((gpo.boat.t(12,-2,gp.rcw)+gpo.block).state(SoD_state)).t(3+149,149-444+2*DNA_outershell_dist,gp.rccw)
 N=N+((gpo.boat.t(-6,5)+gpo.block.t(-12,5)).state(SoD_state).t(-310-open_kernel_lane,310-open_kernel_lane)).t(0,0,gp.rccw)

 local N_phasedCorectingReflector=pattern()
 N_phasedCorectingReflector.array = g.parse("169bo$167b3o$166bo$156b2o8b2o$157bo$125b2o11bo18bobo$125b2o10bobo18b2o$137bobo32b2o$136b2ob3o2b2o26b2o$142bo2bo$136b2ob3o3bobo$136b2obo6b2o$172b2o$172b2o5$133b2o13b2o$133b2o13b2o25bo$118b2o53b3o$117bo2bo51bo$116bob2o52b2o$116bo$115b2o$130b2o$130bo$131b3o$133bo4$154b2o$155bo$155bobo$156b2o3$170b2o$170bobo$172bo$163b2o7b2o$163b2o7$153b2o$154bo$154bobo$155b2o4$48bo$47bobo123b2o$47bobo7b2o114bo$45b3ob2o6b2o112bobo$44bo19b2o105b2o$45b3ob2o13b2o$47bob2o4$60bo113b2o$59bobo112bo$58bo2bo93bo16bobo$59b2o9b2o83b3o14b2o$70b2o86bo$157b2o$161bo$48b2o110bobo$48b2o110bo2bo$161b2o8$4bo$3bobo56b2o$3bobo7b2o47bo$b3ob2o6b2o48b3o96b2o$o19b2o43bo96b2o$b3ob2o13b2o$3bob2o4$16bo$15bobo$14bo2bo$15b2o9b2o$26b2o3$4b2o$4b2o10$18b2o$18bo$19b3o$21bo!")
  N=N+(N_phasedCorectingReflector.state(output_layer_state)
   + (gpo.beehive.t(-1,97)+gpo.blinker.t(14,76,gp.rcw)+gpo.beehive.t(43,70)+gpo.blinker.t(58,49)  -- bondersnatches destroyal
      +gpo.blinker.t(122,0)+gpo.blinker.t(179,18)+gpo.blinker.t(173,46)+gpo.blinker.t(137,56)+gpo.blinker.t(154,60,gp.rcw)
      +gpo.blinker.t(177,61,gp.rcw)+gpo.blinker.t(156,84,gp.rcw)+gpo.loaf.t(139,2,gp.flip)+gpo.block.t(152,45)    -- reflector destroyal
      ).state(SoD_state)
  ).t(16-32-293+shell_last_extra_dist, 16+255+2*shell_lane0_dist+6*shell_lane_dist+shell_last_extra_dist)
-- N=N+((scorbieSE+scorbieSE_SoD[1+SoD_phase].state(SoD_state)).t(95,-120,gp.rcw)
-- +gpo.eater.state(output_layer_state).t(81,-134,gp.rccw)
-- +(gpo.blinker.t(91,-97)+gpo.boat.t(8,-123,gp.flip)+gpo.boat.t(52,-71,gp.rcw))[SoD_phase].state(SoD_state)).t(0,2*output_lane_dist)
end

local function W_output()
 W=W+(scorbiesplitter_withSoD
    +(gpo.boat.t(39,67,gp.flip)+gpo.boat.t(64, 50,gp.rccw)).state(output_layer_state)
    +gpo.eater.t(87,103,gp.rcw).state(output_layer_state) -- loop/construction
    +scorbiesplitter_withSoD.t(90,47) -- NW shell construction/NW ori construction .. length critical
    +snarkNES.state(output_layer_state).t(169,118)+scorbiesplitter_withSoD.t(182,166,gp.rcw)+snarkNES.state(output_layer_state).t(-44+170,331-170,gp.swap_xy_flip) -- ori construction/state reading
    +gpo.eater.t(107-12,156+12,gp.rcw).state(output_layer_state) -- NW ori construction blocker
    +(gpo.loaf.t(93-24,138,gp.flip)+gpo.blinker.t(89-24,132,gp.rcw))[SoD_phase].state(SoD_state) -- NW ori construction start .. length critical

    +snarkNES.state(output_layer_state).t(525-DNAloopOctavoDist+input_lane0_dist,-264+DNAloopOctavoDist-input_lane0_dist,gp.flip_x)
         ).t(2*DNA_outershell_dist+6,46,gp.flip) -- NW ori construction .. length critical
    +snarkNES.state(output_layer_state).t(16+25+116+2*shell_lane0_dist+6*shell_lane_dist+shell_last_extra_dist,16+25+1-shell_last_extra_dist , gp.flip) -- dna fill
    +(scorbieSE_withSoD2+
         (gpo.loaf.t(22,-20,gp.flip)+gpo.beehive.t(19,-39)+gpo.boat.t(-42,9,gp.rcw))[SoD_phase].state(SoD_state) -- destroyal path
         +gpo.eater.t(-32,-26,gp.swap_xy_flip).state(output_layer_state) -- to block the lane not going to shell construction
         ).t(-69+DNA_outershell_dist+constr_lane_dist,65+constr_lane_dist-DNA_outershell_dist) -- SW shell construction
    +(gpo.eater.t(0,0,gp.flip_y).state(output_layer_state) -- state reading stoper (construction continues in DNA_loop_snarks)
      +(gpo.boat.t(-40,-35,gp.flip)  -- state reading stopper destroy
         +gpo.tub.t(-35,-92)+gpo.blinker.t(-22,-91)  -- split to 2nd bondersnatch destroy
         +gpo.blinker.t(20,-45,gp.rcw)+gpo.blinker.t(24,-45,gp.rcw) -- turn to destroy 2nd bondersnatch
         ).state(SoD_state)
         +(gpo.boat.t(3,-19,gp.flip)+gpo.boat.t(21,-13,gp.rcw)+gpo.loaf.t(6,-27,gp.rccw)+(gpo.blinker.t(9,-41)+gpo.blinker.t(10,-42))[1]
         +gpo.boat.t(-55,-70)+gpo.long_boat.t(-62,-78,gp.rccw)
         ).state(seed_state) -- state reading stoper replacement
         ).t(89+DNA_outershell_dist+constr_lane_dist+DNAloopOctavoDist,1+constr_lane_dist-DNA_outershell_dist-DNAloopOctavoDist)
 W=W+((gpo.boat.t(-6,5)+gpo.block.t(-14,7)).state(SoD_state).t(-310-open_kernel_lane,310-open_kernel_lane)).t(0,0,gp.flip) -- SW ori construction start

 -- W=W+(snarkNES.t(0,0,gp.swap_xy).state(output_layer_state)
--  +scorbiesplitter_withSoD.t(-185,-144)
--  +gpo.eater.t(28,-4,gp.rccw).state(output_layer_state)
--  +gpo.glider[1].state(comment_glider_state).t(-142,-161,gp.flip_y)
--  +(gpo.block.t(21,26)+gpo.eater.t(27,25)+gpo.boat.t(37,16,gp.rccw))[SoD_phase].state(SoD_state)).t(135,41).t(2*output_lane_dist,0,gp.flip)
end

local function S_output()
 S=S+(scorbiesplitter_withSoD
    +(gpo.boat.t(64, 50,gp.rccw) + gpo.boat.t(59, 45,gp.rccw) + gpo.eater.t(50,44,gp.swap_xy)).state(output_layer_state)
    +scorbiesplitter_withSoD.t(90,47)
    +snarkNES.state(output_layer_state).t(145, 94)
    +snarkNES.state(output_layer_state).t(525-DNAloopOctavoDist+input_lane0_dist+input_lane1_dist,-264+DNAloopOctavoDist-1-input_lane0_dist-input_lane1_dist,gp.flip_x)
    +(gpo.eater.state(output_layer_state)+(gpo.pond.t(-16-97,14+97)+gpo.blinker.t(-10-97,20+97,gp.rcw))[SoD_phase].state(SoD_state)).t(137,89)).t(46-1,-2*DNA_outershell_dist-6,gp.rcw)
    +snarkNES.state(output_layer_state).t(102-shell_last_extra_dist, -95-2*shell_lane0_dist-6*shell_lane_dist-shell_last_extra_dist, gp.rcw)
    +snarkNES.state(output_layer_state).t(80+constr_lane_dist-DNA_outershell_dist,56-DNA_outershell_dist-constr_lane_dist,gp.flip_x)
    +((gpo.block+gpo.boat.t(25,30))[SoD_state].state(SoD_state) -- destroyal path + SoD
         +gpo.eater.t(-15,24,gp.flip_x).state(output_layer_state)) -- to block the lane not going to shell construction
         .t(53+constr_lane_dist-DNA_outershell_dist,77-DNA_outershell_dist-constr_lane_dist)
 S=S+((gpo.boat.t(-6,5)+gpo.block.t(-14,7)).state(SoD_state).t(-310-open_kernel_lane,310-open_kernel_lane)).t(0,0,gp.rcw)
 --S=S+(snarkNES.t(0,0,gp.swap_xy).state(output_layer_state)
 -- +scorbiesplitter_withSoD.t(-185,-144)
 -- +gpo.eater.t(28,-4,gp.rccw).state(output_layer_state)
 -- +gpo.glider[1].state(comment_glider_state).t(-142,-161,gp.flip_y)
 -- +(gpo.block.t(21,26)+gpo.eater.t(27,25)+gpo.boat.t(37,16,gp.rccw))[SoD_phase].state(SoD_state)).t(135,41).t(0,-2*output_lane_dist,gp.rcw)
end

local function DNA_loop_snarks()
 local shift = 82+4*(DNAtimelog%2)
 local speedupshift=4*19
 local L=(snarkNES.state(output_layer_state).t(-14,10,gp.rccw)+gpo.blinker.t(4,12)[SoD_phase].state(SoD_state)).t(3*DNAloopOctavoDist,DNAloopOctavoDist,gp.flip)     -- 1 dna loop delay
         +gpo.boat.state(output_layer_state).t(-16+149,-16+178+4*DNAloopOctavoDist,gp.flip) -- destroy fill reflector
         +(snarkNES.state(output_layer_state).t(-14,10,gp.rccw)+gpo.blinker.t(4,12)[SoD_phase].state(SoD_state)
         +(gpo.boat.t(17, -55, gp.flip) -- start NE construction
          +gpo.boat.t(22, -60, gp.flip) -- start SE construction
          +gpo.boat.t(27, -65, gp.flip) -- start SW construction
          +gpo.boat.t(32, -70, gp.flip) -- start NW construction
          +gpo.block.t(36, -76) -- delay to fill the DNA in NW as well
          +gpo.boat.t(42, -80, gp.flip) -- remove DNA
          +gpo.eater.t(77, -116, gp.flip_y) -- catching late "speedup" gliders
          +gpo.boat.t(74, -130, gp.flip) -- destroy the eater at the end of 0 speedup
          +gpo.block.t(57, -100)+gpo.loaf.t(51, -96, gp.rcw) -- send state + start SoD splitter
          ).state(output_layer_state)
          +(gpo.block.t(86, -129)+gpo.block.t(90, -123)).state(SoD_state)
         ).t(2+2*DNAloopOctavoDist,2*DNAloopOctavoDist,gp.rcw)  -- 6 dna loop delay
         +gpo.boat.state(output_layer_state).t(-16+2+2*DNAloopOctavoDist,-16+32+2*DNAloopOctavoDist,gp.flip) -- first glider redirect to switch fill to clocks construction
         +gpo.tub.state(output_layer_state).t(-16+31+2*DNAloopOctavoDist,-16+55+2*DNAloopOctavoDist)  -- part1 turn to start clocks construction
         +gpo.blinker.state(output_layer_state).t(-16+32+2*DNAloopOctavoDist,-16+42+2*DNAloopOctavoDist) -- part2 turn to start clocks construction
         +gpo.blinker.state(output_layer_state).t(-16+157+2*DNAloopOctavoDist,-16+179+2*DNAloopOctavoDist,gp.rcw) -- part1 turn to destroy fill reflector
         +gpo.blinker.state(output_layer_state).t(-16+157+2*DNAloopOctavoDist,-16+175+2*DNAloopOctavoDist,gp.rcw) -- part2 turn to destroy fill reflector
         +(snarkNES.state(output_layer_state).t(-14,10,gp.rccw)+gpo.blinker.t(4,12)[SoD_phase].state(SoD_state)
          +(boatsemisnarkwithSoD + semisnarkready).t(-129,-157) -- to make children and die
          +(gpo.tub.t(244,187)+gpo.tub.t(235,178)+gpo.tub.t(226,169)+gpo.tub.t(217,160)+gpo.tub.t(208,151)+gpo.tub.t(199,142)
          +gpo.boat.t(224,196,gp.flip)+gpo.boat.t(215,187,gp.flip)+gpo.boat.t(206,178,gp.flip)+gpo.boat.t(197,169,gp.flip)+gpo.boat.t(188,160,gp.flip)+gpo.boat.t(179,151,gp.flip)
          +gpo.blinker.t(231,188)+gpo.blinker.t(222,179,gp.rcw)+gpo.blinker.t(213,170)+gpo.blinker.t(204,161,gp.rcw)+gpo.blinker.t(195,152)+gpo.blinker.t(186,143,gp.rcw)
          +gpo.boat.t(182,136,gp.flip)  -- 0 speedup
         +(gpo.block.t(231,195)+gpo.block.t(222,186)+gpo.block.t(213,177)+gpo.block.t(204,168)+gpo.block.t(195,159)+gpo.block.t(186,150)
           +gpo.boat.t(241,187,gp.rccw)+gpo.tub.t(235,178)+gpo.tub.t(226,169)+gpo.tub.t(217,160)+gpo.tub.t(208,151)+gpo.tub.t(199,142)
           +gpo.boat.t(224,196,gp.flip)+gpo.boat.t(215,187,gp.flip)+gpo.boat.t(206,178,gp.flip)+gpo.boat.t(197,169,gp.flip)+gpo.boat.t(188,160,gp.flip)+gpo.boat.t(179,151,gp.flip)
           +gpo.blinker.t(222,179)+gpo.blinker.t(213,170,gp.rcw)+gpo.blinker.t(204,161)+gpo.blinker.t(195,152,gp.rcw)+gpo.blinker.t(186,143)
           +gpo.boat.t(182,136,gp.flip)).t(-speedupshift,-speedupshift)
         -- <7 speedup
          ).state(output_layer_state)
          ).t(4+DNAloopOctavoDist,DNAloopOctavoDist,gp.identity) -- 5 dna loop delay
         +(snarkNES.state(output_layer_state).t(-14,10,gp.rccw)+gpo.blinker.t(4,12)[SoD_phase].state(SoD_state)).t(3,2*DNAloopOctavoDist,gp.flip_y)                   -- 4 dna loop delay
         +(snarkNES.state(output_layer_state).t(-14,10,gp.rccw)+gpo.blinker.t(4,12)[SoD_phase].state(SoD_state)).t(shift+1-2*DNAloopOctavoDist,shift,gp.swap_xy)            -- 3 dna loop delay
         +(snarkNES.state(output_layer_state).t(-14,10,gp.rccw)+gpo.blinker.t(4,12)[SoD_phase].state(SoD_state)).t(shift-1,shift-2*DNAloopOctavoDist,gp.flip_x)              -- 2 dna loop delay
         +(scorbiesplitter_withSoD
                 +(gpo.boat.t(60,24) -- turn to open state fill
                 +gpo.pond.t(21,2)+gpo.beehive.t(25,-4) -- fill/clock build scorbiesplitter destroy
                 +gpo.pond.t(37,53)+gpo.beehive.t(33,47)).state(SoD_state) -- fill bondersnatch destroy
                 +gpo.boat.t(130,45).state(seed_state) -- turn to close state fill
                 +snarkNES.state(output_layer_state).t(31+92,77+92) -- state fill
                 +gpo.boat.t(66,264,gp.rccw).state(output_layer_state) -- send state turner
         ).t(4+3*DNAloopOctavoDist,346+DNAloopOctavoDist,gp.rcw) --dna fill/clocks construction
    --     +gpo.eater.t(-16-160+3*DNAloopOctavoDist,-16+236+DNAloopOctavoDist,gp.swap_xy_flip) -- clocks construction blocker
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
315b3o$69bo$68bobo$67bobo$67b2o4$347bo$346bobo$346bobo$347bo3$241b2o$
241b2o15$227bo$226bobo86b3o$226bobo51b2o$227bo52b2o2$97b3o3$254b2o28b
2o$254b2o28b2o$103b3o118b2o37b2o$224b2o36bo2bo$263b2o9$92bo$92bo17b3o$
92bo107b2o$200b2o$280b2o$280b2o11$217b2o$216bo2bo$217b2o$226b2o$226b2o
$202bo$201bobo$201b2o7$273b2o5b3o$273b2o7$233bo6b2o$232bobo4bobo$233b
2o5bo4$124b2o$124b2o5$120b2o$120b2o8bo$129bobo$129b2o$150b2o$150b2o$
173b3o$314b2o$314bobo$315bo4$174b2o$174b2o4$216bo$215bobo$136bo79b2o$
135bobo$135bobo$136bo7$133b2o$133b2o$126bo$125bobo$125bobo$126bo4$125b
o$124bobo$124bobo$125bo$201b2o168b2o$200bobo168b2o$201bo68b2o$270b2o3$
285b3o$274bo$274bo$274bo$193b2o$193bobo$194bo4$93b2o262bo$93b2o99b2o
160bobo$193bobo160bobo$194bo162bo4$b2o$o2bo380b2o$o2bo380b2o$b2o351b2o
37b2o$354b2o36bo2bo$155b2o52bo72b2o109b2o$66bo87bobo52bo71bo2bo$65bobo
42b2o43bo53bo72b2o$66b2o41bo2bo36b2o$110b2o37b2o$89b2o28b2o$7b2o80b2o
28b2o98b2o$7bobo209b2o26b2o$8bo176b2o59bo2bo$184bo2bo58bo2bo$185b2o60b
2o$93b2o52bo$93b2o51bobo102b2o$146bobo101bo2bo156b2o$147bo103b2o5b3o
149b2o4$455bo$455bo$455bo5$288b2o$287bo2bo95b2o$288b2o96b2o$279b2o$
132b2o29bo115b2o$132b2o29bo$163bo3$384bo$383bobo$221b2o160bobo$220bobo
161bo$221bo5$232b2o$232b2o4$225b2o$224bo$227bo72bo$225b2o8bo63bobo$
234bobo62bo2bo66b2o$234bobo63bobo66b2o$235bo65bo3$299b2o$299bobo$300b
2o3$278b2o$278b2o2$376b3o28b3o13$276b2o$276b2o5$280b2o$157b2o121b2o$
156bobo$157bo8$398b2o$397bo2bo$398b2o13$356bo$355bobo$342b3o11bo8$142b
3o20$112bo$111bobo$111bobo$112bo8$142b3o80$227b2o$226bo2bo$226bo2bo$
227b2o!
]])
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
 local C=2 -- SW shift for clock semi lane
 local X=23
 return (readclock.state(output_layer_state)+readclockSoD.t(5,7).state(SoD_state) --+gpo.boat.t(225,115).state(seed_state)
         +gpo.glider[1].t(324,134,gp.flip_y).state(comment_glider_state) -- clock starting glider
         +gpo.glider[1].t(55,116,gp.rcw).state(comment_glider_state) -- state sending circuit destroying glider
         +((gpo.block.t(30,30)+gpo.block.t(-12,-12)+gpo.block.t(-16,-16)+gpo.block.t(-20,-20)+gpo.block.t(-24,-24)+gpo.block.t(-28,-28)+gpo.block.t(-34,-34) -- state blocks
           +gpo.block.t(-44,-27)+gpo.blinker.t(-37,-29, gp.rcw) -- nonzero antispeedup
           +gpo.blinker.t(20,35)+gpo.tub.t(28,37)+gpo.eater.t(50,32,gp.swap_xy)+gpo.boat.t(55,46,gp.flip) -- state 7 antispeedup
           ).state(output_layer_state)
         +(gpo.long_boat.t(-272-S,-555+S, gp.rcw) -- SoD source
          +gpo.pond.t(88-S,-179+S)+gpo.beehive.t(97-S,-183+S,gp.rcw) -- repeat test zero and <7 split after state zeroed
          +gpo.block.t(-60,-19) -- catch zero destroyal for nonzero case
          +gpo.boat.t(179-S,-98+S,gp.flip)+gpo.loaf.t(171-S,-95+S,gp.rcw) -- repeat test 7 and continue to reflectors after a while split
          +gpo.block.t(13,58) -- catch 7 destroyal for <7 case
          +gpo.boat.t(338-S,72+S,gp.rcw)+gpo.boat.t(358-2,43+2) -- turnback after a while
          +gpo.block.t(202,-110)+gpo.block.t(207,-107)+gpo.boat.t(205,-115,gp.rcw) -- reflector for 7 case with catcher (<7 destroys the boat) but we need a pseudocatalyst and destroy it
          +gpo.pond.t(178,-123)+gpo.blinker.t(184,-126) -- split back to destroy the pseudocatalyst
          +gpo.loaf.t(165,-131)+gpo.block.t(161,-138) -- split to destroy 0,<7 catchers and half turn to conditional reflector for 7
          +gpo.loaf.t(-29+X,7+X,gp.rccw)+gpo.block.t(-33+X,13+X) -- targeting the catchers
          +gpo.loaf.t(166,-146,gp.rcw)+gpo.block.t(172,-150) -- split to 0 and second half turn to conditional reflector for 7
          +gpo.pond.t(155,-167)+gpo.block.t(148,-164) -- turn back to destroy catcher
          +gpo.blinker.t(47,-264)+gpo.tub.t(56,-265) -- turn back to hit the nonzero reflector
          +gpo.block.t(142,-197)+gpo.boat.t(139,-201,gp.rcw) -- reflector for nonzero case ... vanishing in both cases (zero destroys the boat)
         -- 7 antispeedup SoD stop
          ).state(SoD_state)
           ).t(220,-100)
         +(gpo.tub+gpo.blinker.t(1,-13,gp.rcw)).state(SoD_state).t(-176,-515)
         +send_state_salvo_seed.state(output_layer_state).t(-173,-504)+gpo.glider.t(-86,-428,gp.flip).state(comment_glider_state)
         +(gpo.boat.t(541,-128,gp.flip)+gpo.long_boat.t(544,-126,gp.rccw)                                                     -- allow readclock start from NE
         +gpo.boat.t(372,322,gp.rccw)+gpo.long_boat.t(370,325)+gpo.boat.t(683,19)+gpo.loaf.t(516,-142)+gpo.boat.t(515,-150)   -- allow readclock start from SE
         +gpo.boat.t(151,241,gp.flip)+gpo.long_boat.t(153,244,gp.rcw)+gpo.boat.t(16,114,gp.rcw)+gpo.boat.t(412,-274)          -- allow readclock start from SW
         +gpo.boat.t(177,72,gp.rccw)+gpo.long_boat.t(174,74,gp.flip)+gpo.boat.t(463,-223)                                     -- allow readclock start from NW
         +gpo.boat.t(335-C,-277+C,gp.rcw)+gpo.blinker.t(331-C,-282+C,gp.rcw)+gpo.blinker.t(332-C,-281+C,gp.rcw)               -- conditional state 0 turn (0 speedup)
         +gpo.long_boat.t(405-C,-211+C,gp.flip)+gpo.boat.t(411-C,-201+C,gp.rccw)+gpo.long_boat.t(408-C,-199+C,gp.flip)        -- conditional state <7 split (<7 speedup)
         ).state(output_layer_state)
         + (gpo.block.t(276,136)+gpo.block.t(279,229)+gpo.block.t(217,175)+gpo.block.t(231,127)                               -- to allow optional 0 neighbour
         + gpo.boat.t(581,-176,gp.rccw) + gpo.blinker.t(743,-24) + gpo.blinker.t(743,-20) -- to replace 0 from NE
         + gpo.pond.t(486,222)+gpo.beehive.t(495,226,gp.rcw) -- to destroy snark
         + gpo.loaf.t(387,325,gp.flip)+gpo.block.t(393,328) -- split to replace 0 from SE and NE
         + gpo.boat.t(378,337) -- to replace 0 from SE
         + gpo.pond.t(170,275)+gpo.beehive.t(174,284)+ gpo.boat.t(132,252,gp.rcw)  -- to replace 0 from SW
         + gpo.ship.t(128,33,gp.rcw)+gpo.blinker.t(141,25,gp.rcw)+gpo.blinker.t(158,5,gp.rcw)+gpo.blinker.t(162,5,gp.rcw) -- to replace 0 from NW
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
2o$88bobo$87bobo$88bo8$100b2o$99bobo$98bobo$99bo159$414b2o$414b2o30$
413b2o$413b2o4$417b2o$417b2o69$353b2o$352bobo$353bo!]])
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
74bo$74bo$74bo$91b3o27$106b2o$106b2o6$105bo$105bo$33b2o70bo$32bobo$33b
o60bo$93bobo$93bo2bo$94b2o$98bo$98bo$98bo6$96bo$96bo$96bo6$47b2o$47bob
o$48bo25$6b3o4$b2o$o2bo$b2o8$25b2o$17bo6bobo$16bobo4bobo$15bobo6bo$15b
2o3$32b2o$24bo6bobo$23bobo4bobo$22bobo6bo$22b2o3$39b2o$31bo6bobo$30bob
o4bobo$29bobo6bo$29b2o11$32bo$31bobo$32b2o!
]])

 return
 (SE_part.state(output_layer_state)+SE_partSoD.t(-395,-261).state(SoD_state)
  + (boatsemisnarkwithSoD+semisnarksemi).t(24,130,gp.rccw)
  + gpo.boat.t(-31,12,gp.rccw).state(output_layer_state) -- starting read clock
 ).t(973-innerquadsize,-458)
 +
 (NW_part.state(output_layer_state)+NW_partSoD.t(-45,1).state(SoD_state)+gpo.glider[1].t(-6,13,gp.swap_xy_flip).state(active_state)
  + (tubsemisnark.state(output_layer_state)+semisnarksemi).t(3,97)
  + (gpo.boat.t(35, 87, gp.flip) -- read state alarm clock gun start (we can use other barel of this gun instead)
   + gpo.block.t(25, 96) --
    ).state(output_layer_state)
 ).t(-5069-innerquadsize,-6501)
end

local function cell()
 E_output()
 N_output()
 W_output()
 S_output()
 return positionmark.t(halfsize,0)+positionmark.t(0,-halfsize)+positionmark.t(-halfsize,0)+positionmark.t(0,halfsize)
  +E.t(2*innerquadsize,0)+N.t(0,-2*innerquadsize)+W.t(-2*innerquadsize,0)+S.t(0,2*innerquadsize)
  +SE.t(innerquadsize,innerquadsize)+NE.t(innerquadsize,-innerquadsize)+NW.t(-innerquadsize,-innerquadsize)+SW.t(-innerquadsize,innerquadsize)
  +DNA_loop_snarks()+ReadClock()+mainClock()
end

local _0e0p_cell = cell()
g.setrule("LifeHistory14")
local _0e0p_cells = _0e0p_cell+_0e0p_cell.t(-halfsize,-halfsize)+_0e0p_cell.t(halfsize,-halfsize)+_0e0p_cell.t(halfsize,halfsize)+_0e0p_cell.t(-halfsize,halfsize)
_0e0p_cells.display("0e0pcells")
g.setbase(2)
g.setstep(16)
g.setpos(startX,startY)
g.setmag(startMag)