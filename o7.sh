#!/bin/bash

python o7.py > o7.txt
grep finally o7.txt
./salvo2mc.exe salvos/timedelta/oggca7.txt salvos/mc/oggca7
