import xswitch_test_pkg::*;

class case_1_1 extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,10);
   endfunction

   task run_cases();
      begin
         // start with empty test
         stim = new();
         test2gen.put(stim);

         // assign prios
         for (int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel = i;
            stim.prio_wr = 1'b1;
            stim.prio_val = $urandom();
            test2gen.put(stim);
         end

         // assign the same address to multiple ports
         repeat(10) begin
            stim = new();
            stim.port_sel = $urandom();
            stim.port_en = 1'b1;
            stim.port_wr = 1'b1;
            stim.port_addr = 16'hffff;
            test2gen.put(stim);
         end

         // write to that address
         repeat(10) begin
            stim = new();
            stim.data_in = {$urandom(),$urandom()};
         end
      end
   endtask


endclass