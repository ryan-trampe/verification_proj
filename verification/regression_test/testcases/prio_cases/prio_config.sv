// Write a testcase where multiple ports write to the same address with unique prios

class prio_config extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,324);
   endfunction

   task run_cases();
      begin
         // assign port prios and addresses
         for (int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel = i;
            stim.port_en = 1'b1;
            stim.port_wr = 1'b1;
            stim.port_addr = i+1;
            stim.prio_wr = 1'b1;
            stim.prio_val = i*10+2;
            test2gen.put(stim);
         end

         // make  writes to 1 port
         repeat (64) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {4{16'd1}};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // make 256 reads
         repeat (256) begin
            stim = new();
            stim.rd_en = 4'hf;
            test2gen.put(stim);
         end
      end
   endtask


endclass