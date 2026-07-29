#!/bin/bash

python o4.py > o4.txt
./salvo2mc.exe salvos/timedelta/oggca4.txt salvos/mc/oggca4

./salvo2mc.exe /cygdrive/c/Golly/Patterns/Hroch/Metacell/0e0p_optimization/gen.txt /cygdrive/c/Golly/Patterns/Hroch/Metacell/0e0p_optimization/gen
#./salvo2mc.exe salvos/timedelta/test.txt salvos/mc/test