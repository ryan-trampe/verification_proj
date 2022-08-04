package xswitch_test_pkg;

class stim_transaction;
   bit [63:0] addr_in;
   bit [63:0] data_in;
   
   bit [3:0] wr_en,rd_en;
   bit [7:0] prio_val;
   bit [15:0] port_addr;
   bit [1:0] port_sel;
   bit port_wr,prio_wr,port_en;
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

class randomVars;
   rand bit [63:0] addr_in;
   rand bit [63:0] data_in;
   
   rand bit [3:0] wr_en,rd_en;
   rand bit [7:0] prio_val;
   rand bit [15:0] port_addr;
   rand bit [1:0] port_sel;
   rand bit port_wr,prio_wr,port_en;

   constraint valid_port_sel {port_sel inside {[0:3]};}
endclass

`include "sanity_check.sv"


endpackage