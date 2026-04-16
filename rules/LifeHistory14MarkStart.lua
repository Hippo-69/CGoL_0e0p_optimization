local g = golly()

local rule = g.getrule()
if rule~="LifeHistory14" then
   g.warn("Convert to LifeHistory14 first")
   g.exit()
end

ruletext = [[@RULE LifeHistory14MarkStart
@TABLE
n_states:255
neighborhood:oneDimensional
symmetries:none
var all={0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,182,184,186,188,190,192,194,196,198,200,202,204,206,208,210,212,214,216,218,220,222,224,226,228,230,232,234,236,238,240,242,244,246,248,250,252,254}
var all_1={all}
#converting old boundary to new boundary
8,all,all_1,0
#converting old start to new stable
1,all,all_1,9
]]
   
local function CreateRule()
    local fname = g.getdir("rules").."LifeHistory14MarkStart.rule"
    local f=io.open(fname,"r")
    if f~=nil then
        io.close(f)  -- rule already exists
    else 
        local f = io.open(fname, "w")
        if f then
            f:write(ruletext)
            f:close()
        else
            g.warn("Can't save LifeHistory14MarkStart rule in fname:\n"..fname)
        end
    end
end
      
CreateRule()
g.setrule("LifeHistory14MarkStart")
g.run(1)
step = g.getstep()
g.setrule("LifeHistory14")
g.setstep(step)
g.setgen("-1")