`include "environment.sv"
import xswitch_test_pkg::*;

program testbench(intf i_intf);
   environment env;
   // sanity_check test;
   testcase test;
   mailbox test2gen;
   string testcase_str;

   initial begin
      test2gen = new(1);
      if ($value$plusargs("%s",testcase_str)) begin
         case (testcase_str)
            "fifo_case_1":     test = fifo_case_1::new(test2gen);
            "fifo_case_2":     test = fifo_case_2::new(test2gen);
            "fifo_case_3":     test = fifo_case_3::new(test2gen);
            "fifo_case_4":     test = fifo_case_4::new(test2gen);
            "addr_config":     test = addr_config::new(test2gen);
            "port_wr_0":       test = port_wr_0::new(test2gen);
            "port_wr_1":       test = port_wr_1::new(test2gen);
            "port_wr_2":       test = port_wr_2::new(test2gen);
            "port_wr_3":       test = port_wr_3::new(test2gen);
            "prio_config":     test = prio_config::new(test2gen);
            "prio_change":     test = prio_change::new(test2gen);
            "prio_wr_0":       test = prio_wr_0::new(test2gen);
            "prio_wr_1":       test = prio_wr_1::new(test2gen);
            "prio_wr_2":       test = prio_wr_2::new(test2gen);
            "prio_wr_3":       test = prio_wr_3::new(test2gen);
            "crv":             test = randomized_testing::new(test2gen);
            "rd_wr_cycle":     test = rd_wr_cycle::new(test2gen);
            "reset_check":     test = reset_check::new(test2gen);
            default:           test = sanity_check::new(test2gen);
         endcase
      end
      $display("[Testbench]: Running case %s",testcase_str);
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