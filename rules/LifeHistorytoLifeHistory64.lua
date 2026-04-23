-- LifeHistory to LifeHistory64 converter, intended to be mapped to keyboard shortcut, e.g., Ctrl Shift H
-- used for presenting variants of stable circuits
local g = golly()

local rule = g.getrule()
-- No effect if already in LifeHistory64 rule
if rule=="LifeHistory64" then g.exit() end

if rule~="LifeHistory14" and rule~="LifeHistory" and rule~="B3/S23" and rule~="Life" then
   g.warn("Convert to Life/LifeHistory first or use direct convertor from "..rule)
   g.exit()
end

rule14text = [[@RULE LifeHistoryToLifeHistory14
@TABLE
n_states:255
neighborhood:oneDimensional
symmetries:none
var all={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254}
var all_1={all}
#converting old boundary to new boundary
6,all,all_1,2
#converting old start to new stable
5,all,all_1,9
#converting old signals to new signals (4 remains the same)
3,all,all_1,5
#marking historyenvelope to oldest history envelope
2,all,all_1,254]]

rule64text = [[@RULE LifeHistory14ToLifeHistory64
@TABLE
n_states:255
neighborhood:oneDimensional
symmetries:none
var all={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254}
var prehist={14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62}
var all_1={all}
#converting history states of only LH14 to youngest history of LH64
prehist,all,all_1,64]]
  
local function CreateRule14()
    local fname = g.getdir("rules").."LifeHistoryToLifeHistory14.rule"
    local f=io.open(fname,"r")
    if f~=nil then
        io.close(f)  -- rule already exists
    else 
        local f = io.open(fname, "w")
        if f then
            f:write(rule14text)
            f:close()
        else
            g.warn("Can't save LifeHistoryToLifeHistory14 rule in fname:\n"..fname)
        end
    end
end

local function CreateRule64()
    local fname = g.getdir("rules").."LifeHistory14ToLifeHistory64.rule"
    local f=io.open(fname,"r")
    if f~=nil then
        io.close(f)  -- rule already exists
    else 
        local f = io.open(fname, "w")
        if f then
            f:write(rule64text)
            f:close()
        else
            g.warn("Can't save LifeHistory14ToLifeHistory64 rule in fname:\n"..fname)
        end
    end
end
     
if rule~="LifeHistory14" then
 CreateRule14()
 g.setrule("LifeHistoryToLifeHistory14")
 g.run(1)
 step = g.getstep()
 g.setrule("LifeHistory14")
 g.setstep(step)
 g.setgen("-1")
end
CreateRule64()
g.setrule("LifeHistory14ToLifeHistory64")
g.run(1)
step = g.getstep()
g.setrule("LifeHistory64")
g.setstep(step)
g.setgen("-1")
g.setrule("LifeHistory64") 
