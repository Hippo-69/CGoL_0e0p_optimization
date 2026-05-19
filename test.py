from SimkinECCA import *

simkinecca = SimkinECCAp2compiler()
with open('crab90full.txt') as f:
    td = simkinecca.compile(f.read().strip())
print (f"{td}")