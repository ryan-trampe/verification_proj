#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh

# adding phase dependency
if ($#argv == 0 || $#argv > 1) then
    echo "ERROR: Too many or too few arguments"
    exit 0
endif
# set rootdir
set rootdir = `dirname $0`
echo $rootdir
# set workdir and phase number
set phase_num = $argv[1]
switch($argv[1])
    case "1":
        set workdir = "$rootdir/../verification/phase1_top"
        breaksw
    case "2":
        set workdir = "$rootdir/../verification/phase2_environment"
        breaksw
    case "3":
        set workdir = "$rootdir/../verification/phase3_base"
        breaksw
    case "4":
        set workdir = "$rootdir/../verification/phase4_generator"
        breaksw
    case "5":
        set workdir = "$rootdir/../verification/phase5_driver"
        breaksw
    case "6":
        set workdir = "$rootdir/../verification/phase6_monitor"
        breaksw
    case "7":
        set workdir = "$rootdir/../verification/phase7_scoreboard"
        breaksw
    case "8":
        set workdir = "$rootdir/../verification/phase8_coverage"
        breaksw
    case "9":
        set workdir = "$rootdir/../verification/phase9_testcases"
        breaksw
    default:
        echo "Error: NO phase selected"
        exit(0)
endsw
if (! -d $workdir) then
    echo "Error: $workdir doesn't exist!"
    exit 0
else
    echo "Working in $workdir....."
endif

if (! -e work) then
   vlib work
endif

vsim -c -do $rootdir/phase$phase_num.do