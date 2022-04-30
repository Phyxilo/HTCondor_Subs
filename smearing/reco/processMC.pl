#!/usr/bin/perl
use Cwd qw(getcwd);
use File::Copy;

print "reconstruct MC\n";

$DsTauSoftPATH = "/afs/cern.ch/user/e/eyuksel/Tools/DsTauSoft"; #put your path
#$DsTauSoftPATH = "../DsTauSoft"; #put your path
$EvtList="recoList.lst"; #put your list name
$cpplatefirst=1;
$cpplatelast=131;
$createcp=1;
$first_subvol = 1; # pl001_030, pl010_040, .... If you don't need reconstruction, put $first_subvol=0 and $last_subvol = 0;
$last_subvol = 8;
$doalign = 0;

### create cp-files ###
if($createcp){
system "ln -sf $DsTauSoftPATH/DataProcessing/prg/convertMC2CP/convertMC2CPwithGhostRejection convertMC2CP";
#system "ln -sf $DsTauSoftPATH/DataProcessing/prg/convertMC2CP/convertMC2CP convertMC2CP";
print "create cp-files  \n";
#system "./convertMC2CP --help";
system "./convertMC2CP --list $EvtList --recreate --plmin $cpplatefirst --plmax $cpplatelast";
#system "./convertMC2CP --list $EvtList --recreate --nosmear --plmin $cpplatefirst --plmax $cpplatelast";
}

### create subvolumes ###
my $workdir=getcwd;
print "Create subvolumes $first_subvol - $last_subvol \n";
for(my $isubvol = $first_subvol; $isubvol <= $last_subvol; $isubvol++){
  print "process subvolume $isubvolume\n";
  my $plfirst=1+($isubvol-1)*10;
  my $pllast=$isubvol*10+20;
  if($isubvol==8){$pllast=5+$pllast;}

  my $dirname = "pl0$plfirst\_0$pllast";
  if($isubvol==1){$dirname="pl00$plfirst\_0$pllast";}
  if($isubvol==8){$dirname="pl0$plfirst\_$pllast";}
  print "create folder $dirname\n";
  unless(-e $dirname or mkdir $dirname) {
        die "Unable to create $dirname\n";
    }
  chdir "$dirname";
  my $datadir="data";
  unless(-e $datadir or mkdir $datadir) {
        die "Unable to create $datadir\n";
    }

  for(my $ipl=$plfirst; $ipl<=$pllast; $ipl++){
    if($ipl<10){symlink ("$workdir/cp\_data\_pl001\_105/0$ipl\_001.cp.root", "data/0$ipl\_001.cp.root");}
    else{symlink ("$workdir/cp\_data\_pl001\_105/$ipl\_001.cp.root", "data/$ipl\_001.cp.root");}
  }

  print "copy parameter files\n";
  my $pardir="par";
  unless(-e $pardir or mkdir $pardir) {
        die "Unable to create $pardir\n";
    }
  for(my $ipl=$plfirst; $ipl<=$pllast; $ipl++){
    if($ipl<10){copy("$workdir/par/0$ipl\_001.par", "par/0$ipl\_001.par");}
    else{copy("$workdir/par/$ipl\_001.par", "par/$ipl\_001.par");}
  }

  print "copy default.par, lnk.def, create lnk.lst\n";
  copy("$DsTauSoftPATH/DataProcessing/basic_files/lnk_MC.def", "lnk.def");
  copy("$DsTauSoftPATH/DataProcessing/basic_files/default_MC.par", "default.par");

  # create lnk.lst
  my $file = "lnk.lst";

  unless(open FILE, '>'.$file){    die "\nUnable to create $file\n";}

  for(my$ipl=$plfirst; $ipl<=$pllast; $ipl++){
    print FILE "$ipl 1 ./data/* 1\n";
  }
  close FILE;

  #make alignment
  if($doalign>0){
    for(my $ialign=1; $ialign<=$doalign; $ialign++){
      system "recset -a lnk.def";
      system "recset -z lnk.def";
    }
  }
  # do tracking
  system "ln -sf $DsTauSoftPATH/DataProcessing/prg/tracking/dstautracking dstautracking";
  system "./dstautracking lnk.def";

 # vertexing is not yet available

  chdir "..";
}
