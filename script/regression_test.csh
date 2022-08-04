#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh
# set rootdir
set rootdir = `dirname $0`
echo $rootdir
#set working directory
set workdir = "$rootdir/../verification/regression_test"
if (! -d $workdir) then
   echo "Error: $workdir doesn't exist!"
   exit 0
else
   echo "Working in $workdir....."
endif
# set output directory
set outputdir = "$rootdir/../report"
if (! -d $outputdir) then
   echo "Error: $outputdir doesn't exist!"
   exit 0
else
   rm -r $outputdir/*
   echo "Outputting to $outputdir...."
endif

if (! -e work) then
   vlib work
endif

# current list of testcases
set testcase_list = "sanity_check rd_wr_cycle reset_check crv"
set testcase_list = "$testcase_list fifo_case_1 fifo_case_2 fifo_case_3 fifo_case_4"
set testcase_list = "$testcase_list addr_config port_wr_0 port_wr_1 port_wr_2 port_wr_3"
set testcase_list = "$testcase_list prio_config prio_change prio_wr_0 prio_wr_1 prio_wr_2 prio_wr_3"

foreach testcase ($testcase_list)
   set testcase_uc = `echo $testcase | tr "[:lower:]" "[:upper:]"`
   vlog +cover -f $rootdir/regression_test.f
   vsim -coverage -vopt tbench_top -c +$testcase -do \
   "coverage exclude -srcfile tbench_top.sv;\
   coverage exclude -srcfile interface.sv;\
   coverage save -onexit $outputdir/$testcase.ucdb;\
   run -all;\
   exit"
end

set ucdb_list = "$outputdir/sanity_check.ucdb $outputdir/rd_wr_cycle.ucdb $outputdir/reset_check.ucdb $outputdir/crv.ucdb"
set ucdb_list = "$ucdb_list $outputdir/fifo_case_1.ucdb $outputdir/fifo_case_2.ucdb $outputdir/fifo_case_3.ucdb"
set ucdb_list = "$ucdb_list $outputdir/addr_config.ucdb $outputdir/port_wr_0.ucdb $outputdir/port_wr_1.ucdb $outputdir/port_wr_2.ucdb $outputdir/port_wr_3.ucdb"
set ucdb_list = "$ucdb_list $outputdir/prio_config.ucdb $outputdir/prio_wr_0.ucdb $outputdir/prio_wr_1.ucdb $outputdir/prio_wr_2.ucdb $outputdir/prio_wr_3.ucdb"

vcover merge $outputdir/xswitch_cov.ucdb $ucdb_list
vcover report -details $outputdir/xswitch_cov.ucdb -file $outputdir/detailed_xswitch_fc.rpt
vcover report -html $outputdir/xswitch_cov.ucdb -output $outputdir/html_output
vcover report $outputdir/xswitch_cov.ucdb -file $outputdir/xswitch_cc.rpt