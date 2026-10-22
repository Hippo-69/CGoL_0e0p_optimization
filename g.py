with open('/cygdrive/c/Golly/Patterns/Hroch/Metacell/0e0p_optimization/gen.txt','r') as fin:
    with open('/cygdrive/c/Golly/Patterns/Hroch/Metacell/0e0p_optimization/gen#.txt','w') as fout:
        sum = -16621672 # nonzero shift could be helpful
        for line in fin:
            uncommented = line[:-1].split("--")[0].strip()
            tds = uncommented.split()
            for td in tds:
                if len(td)>0:
                    sum += int(td)
            fout.write(f'{line[:-1]} --#{oct(sum)} ({oct(sum//1024)} {sum%1024})\n')