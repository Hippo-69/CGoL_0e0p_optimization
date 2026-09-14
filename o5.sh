#!/bin/bash

python o5.py > o5.txt
grep finally o5.txt
./salvo2mc.exe salvos/timedelta/oggca5.txt salvos/mc/oggca5