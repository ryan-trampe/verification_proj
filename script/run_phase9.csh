#!/bin/csh
source /CMC/scripts/mentor.questasim.2019.2.csh


# current list of testcases
set testcase_list = "sanity_check rd_wr_cycle reset_check crv"
set testcase_list = "$testcase_list fifo_case_1 fifo_case_2 fifo_case_3 fifo_case_4"
set testcase_list = "$testcase_list addr_config port_wr_0 port_wr_1 port_wr_2 port_wr_3"
set testcase_list = "$testcase_list prio_config prio_change prio_wr_0 prio_wr_1 prio_wr_2 prio_wr_3"
# check arguments
if ($#argv == 0 || $#argv > 2) then
   echo "ERROR: Too many or too few arguments"
   exit 0
endif

switch ($argv[1])
case "-l"
   if($#argv > 1) then
      echo "ERROR: Too many arguments"
      exit 0
   else
      echo "list of testcases:"
      @ testcase_num = 0
      foreach case ($testcase_list)
         @ testcase_num++
         echo "  $testcase_num : $case"
      end
      exit 0
   endif
   breaksw
case "-t"
   if ($#argv != 2) then
      echo "ERROR: Too few arguments"
      exit 0
   else
      set target_case = "$argv[2]"
      set test_exist = `echo $testcase_list | grep "$target_case"`
      if ("$test_exist" != "") then
         set testcase = "$argv[2]"
      else
         echo "ERROR: Testcase $target_case does not exist!"
         exit 0
      endif
   endif
   breaksw
default:
   echo "ERROR: invalid arguments"
   exit 0
endsw

# set rootdir
set rootdir = `dirname $0`
echo $rootdir
set workdir = "$rootdir/../verification/phase9_testcases"
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

vmap work work
vlog +cover=t +toggleportsonly -f $rootdir/phase9.f
vsim -coverage -vopt -c tbench_top +$testcase -do \
   "coverage exclude -srcfile tbench_top.sv;\
   coverage exclude -srcfile interface.sv;\
   coverage save -onexit $outputdir/$testcase.ucdb;\
   run -all;\
   exit"
vcover report $outputdir/$testcase.ucdb -output $outputdir/$testcase\_details.rpt
vcover report -html $outputdir/$testcase.ucdb -output $outputdir/html_output
# vcover report -details $outputdir/$testcase.ucdb | less