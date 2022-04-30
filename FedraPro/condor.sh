#!/bin/bash

source /afs/cern.ch/user/e/eyuksel/Tools/fedra.sh
echo Source

mkdir fedraPro
cd fedraPro

cp -r /eos/user/e/eyuksel/out/STrue/smearing/pl001_030/par .
cp /eos/user/e/eyuksel/out/STrue/smearing/pl001_030/default.par .
cp /eos/user/e/eyuksel/out/STrue/smearing/pl001_030/lnk.def .
cp /eos/user/e/eyuksel/out/STrue/smearing/pl001_030/lnk.lst .
cp /eos/user/e/eyuksel/out/STrue/smearing/pl001_030/linked_tracks.root
cp /afs/cern.ch/user/e/eyuksel/fedraPro/fwdSel .
echo Files are copied.

#ls -d -1 /eos/project-d/dstau/public/MC/Geant4/hadrons-r86/*.root > recoList.lst
#cp ../DsTauSoft/DataProcessing/prg/convertMC2CP/processMC_example.pl processMC.pl 

./fwdSel

cp -r . /eos/user/e/eyuksel/out/smCut
echo Files copied to eos directory
