`include "phase7_environment.sv"
import xswitch_test_pkg::*;

program testbench(intf i_intf);

   environment env;
   sanity_check test;
   mailbox test2gen;

   initial begin
      test2gen = new(1);
      test = new(test2gen);
      env = new(test.num_stim,i_intf,test2gen);
      $display("[Testbench]: Start of testcase(s) at %0d",$time);
      fork
         test.run_cases();
         env.run();
      join
    end

   final
      $display("[Testbench]: End of testcase(s) at %0d",$time);



endprogram