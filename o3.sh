#!/bin/bash

python o3.py > o3.txt
./salvo2mc.exe salvos/timedelta/oggca3.txt salvos/mc/oggca3

./salvo2mc.exe /cygdrive/c/Golly/Patterns/Hroch/Metacell/0e0p_optimization/gen.txt /cygdrive/c/Golly/Patterns/Hroch/Metacell/0e0p_optimization/gen
#./salvo2mc.exe salvos/timedelta/test.txt salvos/mc/test