#!/bin/bash

python crab2.py > crab2.txt
./salvo2mc.exe salvos/timedelta/crab2.txt salvos/mc/crab2
