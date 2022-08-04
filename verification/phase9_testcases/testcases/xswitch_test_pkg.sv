package xswitch_test_pkg;

class stim_transaction;
   bit [63:0] addr_in;
   rand bit [63:0] data_in;
   
   bit [3:0] wr_en,rd_en;
   bit [7:0] prio_val;
   bit [15:0] port_addr;
   bit [1:0] port_sel;
   bit port_wr,prio_wr,port_en;
   bit driv_reset;
endclass

class testcase;
   stim_transaction stim;
   mailbox test2gen;
   int num_stim;

   function new(mailbox test2gen, int num_stim);
      this.test2gen = test2gen;
      this.num_stim = num_stim;
   endfunction

   virtual task run_cases();
      begin
         $display("Should not print");
      end
   endtask
endclass

`include "randomized_testing.sv"
`include "sanity_check.sv"
`include "rd_wr_cycle.sv"
`include "reset_check.sv"
`include "addr_config.sv"
`include "port_wr_0.sv"
`include "port_wr_1.sv"
`include "port_wr_2.sv"
`include "port_wr_3.sv"
`include "fifo_case_1.sv"
`include "fifo_case_2.sv"
`include "fifo_case_3.sv"
`include "fifo_case_4.sv"
`include "prio_config.sv"
`include "prio_change.sv"
`include "prio_wr_0.sv"
`include "prio_wr_1.sv"
`include "prio_wr_2.sv"
`include "prio_wr_3.sv"

endpackage