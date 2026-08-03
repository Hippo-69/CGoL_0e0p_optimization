from SimkinECCA import *

simkinecca = SimkinECCAp2compiler()
simkinecca.build_clean()
with open('salvos/lanephase/q4EEEEend.txt','r') as f:
    uncommented = ""
    for line in f:
        uncommented += line.split("--")[0].strip()+" "
    uncommented = uncommented[0:-2]
    print ()
    print (uncommented)
    print ()
    compiled = simkinecca.compile(uncommented)
compiled = compiled[0][4:].split("(")[0]
with open('salvos/timedelta/EEEEend.txt','w') as f:
    f.write(compiled)
#simkinecca.convert_to_speboe()

