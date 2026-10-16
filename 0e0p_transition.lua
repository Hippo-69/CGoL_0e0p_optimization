local g = golly()
local startX,startY = tonumber('10000',8),tonumber('10000',8)

local function process_gap_lane(lane,type)
  g.show(lane.."("..string.len(lane).."|"..string.sub(lane,6,6)..")")
  local shift = tonumber(string.sub(lane,1,4),8)*256
  local val = tonumber(string.sub(lane,6,6))
  for i=shift,shift+140 do
    g.setcell(startX-i+8,startY-i,1)
    g.setcell(startX-i+10+val,startY-i,1)
    if type>0 then
      g.setcell(startX-i+20,startY-i,1)
    end
  end
end

local function process_gap_file(filename,type)
  gapfile=io.open(filename,"r")
  local gaplane
  repeat
    gaplane=gapfile:read()
    if not gaplane then
      gapfile:close()
      return
    end
    process_gap_lane(gaplane,type)
  until false
end

process_gap_file("TLife2Mid.txt",0)
process_gap_file("TMid2Life.txt",1)

