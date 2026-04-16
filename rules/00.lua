-- Fast LifeHistory* to Life converter by Michael Simkin(states extended to 256 bz Hippo.69),
--   intended to be mapped to a keyboard shortcut, e.g., Alt+J
-- Sanity checks and Lua translation by Dave Greene, May 2017
-- Creates special rule and runs it for one generation, then switches to Life 
-- Replace 2k + 1-> 1 and 2k -> 0
-- Preserves step and generation count

local g = golly()

local rule = g.getrule()
-- No effect if already in B3/S23 rule
if rule=="Life" or rule=="B3/S23" or string.sub(g.getrule(),1,7)=="B3/S23:" then do return end end

-- If not in LifeHistory, assume that it's a similar rule with even-numbered OFF states
-- (Edit > Undo will be available to return to the original rule if needed)
if string.sub(rule,1,11)~="LifeHistory" then
   g.warn("Convert a LifeHistory version first (odd/even states) or use direct convertor from "..rule)
   do return end
end

ruletext = [[@RULE LifeHistoriesToLife
@TABLE
n_states:256
neighborhood:oneDimensional
symmetries:none
var even={0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,182,184,186,188,190,192,194,196,198,200,202,204,206,208,210,212,214,216,218,220,222,224,226,228,230,232,234,236,238,240,242,244,246,248,250,252,254}
var odd={1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115,117,119,121,123,125,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,255}
var all={even,odd}
var all_1={all}
even,all,all_1,0
odd,all,all_1,1]]
   
local function CreateRule()
    local fname = g.getdir("rules").."LifeHistoriesToLife.rule"
    local f=io.open(fname,"r")
    if f~=nil then
        io.close(f)  -- rule already exists
    else 
        local f = io.open(fname, "w")
        if f then
            f:write(ruletext)
            f:close()
        else
            g.warn("Can't save LifeHistoriesToLife rule in filename:\n"..fname)
        end
    end
end
      
CreateRule()
g.setrule("LifeHistoriesToLife")
g.run(1)
step = g.getstep()
g.setrule("Life")
g.setalgo("HashLife")
g.setstep(step)
g.setgen("-1")