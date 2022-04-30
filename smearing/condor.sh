#!/bin/bash

source /afs/cern.ch/user/e/eyuksel/Tools/fedra.sh
echo Source

mkdir DsTauSmearing
cd DsTauSmearing

#cp -r /afs/cern.ch/user/e/eyuksel/Tools/DsTauSoft .
#echo DsTauSoft folder copied.

#echo DsTauSmearing dir
#ls

#echo prg dir
#ls DsTauSoft/DataProcessing/prg

#echo convertMC2CP dir
#ls DsTauSoft/DataProcessing/prg/convertMC2CP

#echo tracking dir
#ls DsTauSoft/DataProcessing/prg/tracking

#echo basic_files dir
#ls DsTauSoft/DataProcessing/basic_files

mkdir reco
cd reco
echo Reco directory created.

#cp /afs/cern.ch/user/e/eyuksel/public/reco/processMC.pl .
#cp /afs/cern.ch/user/e/eyuksel/public/reco/recoList.lst .
#cp /afs/cern.ch/user/e/eyuksel/public/reco/rootlogon.C .
cp /afs/cern.ch/user/e/eyuksel/Condor/smearing/reco/processMC.pl .
cp /afs/cern.ch/user/e/eyuksel/Condor/smearing/reco/recoList.lst .
echo Executable and List copied.

#ls -d -1 /eos/project-d/dstau/public/MC/Geant4/hadrons-r86/*.root > recoList.lst
#cp ../DsTauSoft/DataProcessing/prg/convertMC2CP/processMC_example.pl processMC.pl 

./processMC.pl
echo Reconstruction and Tracking finished.

echo Main Folder: reco
ls

echo subfolder: pl001_030
ls pl001_030/

echo subfolder: pl051_080
ls pl051_080/

cp -r . /eos/user/e/eyuksel/out/smearing
echo Files copied to eos directory
