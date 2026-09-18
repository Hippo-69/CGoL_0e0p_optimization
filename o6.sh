#!/bin/bash

python o6.py > o6.txt
grep finally o6.txt
./salvo2mc.exe salvos/timedelta/oggca6.txt salvos/mc/oggca6
