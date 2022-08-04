#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh
# set rootdir
set rootdir = `dirname $0`
echo $rootdir
# set workdir and phase number
set workdir = "$rootdir/../verification/phase5_driver"

if (! -d $workdir) then
    echo "Error: $workdir doesn't exist!"
    exit 0
else
    echo "Working in $workdir....."
endif

if (! -e work) then
   vlib work
endif

vsim -c -do $rootdir/phase5.do