`ifndef _GENERATOR_
`define _GENERATOR_

`include "xswitch_test_pkg.sv"
import xswitch_test_pkg::stim_transaction;

class generator;
   // declare variables
   transaction trans;
   stim_transaction stim;
   int repeat_count;
   // mailbox from stim generator
   mailbox test2gen;
   // mailbox to go to driver
   mailbox gen2driv;

   function new(int repeat_count,mailbox test2gen, mailbox gen2driv);
      this.repeat_count = repeat_count;
      this.test2gen = test2gen;
      this.gen2driv = gen2driv;
   endfunction

   task main();
   repeat (repeat_count) begin
      test2gen.get(stim);
      trans = new();
      trans.addr_in       = stim.addr_in;
      trans.data_in       = stim.data_in;
      trans.wr_en         = stim.wr_en;
      trans.rd_en         = stim.rd_en;
      trans.port_sel      = stim.port_sel;
      trans.port_en       = stim.port_en;
      trans.port_wr       = stim.port_wr;
      trans.port_addr     = stim.port_addr;
      trans.port_sel      = stim.port_sel;
      trans.prio_wr       = stim.prio_wr;
      trans.prio_val      = stim.prio_val;
      // trans.display_inputs("[Generator]");
      gen2driv.put(trans);
   end
   endtask


endclass
`endif