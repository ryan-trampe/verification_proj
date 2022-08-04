// addr check when all port 0 address is changed

class port_wr_0 extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,25);
   endfunction

   task run_cases();
      begin
         // assign port prios and addresses
         for (int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel = i;
            stim.prio_wr = 1'b1;
            stim.prio_val = i*10+5;
            stim.port_en = 1;
            stim.port_wr = 1;
            stim.port_addr = i*5+5;
            test2gen.put(stim);
         end

         // make a few writes to specified address
         repeat (5) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {{16'd0},{16'd0},{16'd0},{16'd5}};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // change specified addresses
         stim = new();
         stim.port_sel = 4'b0001;
         stim.port_en = 1;
         stim.port_wr = 1;
         stim.port_addr = 16'd100;
         test2gen.put(stim);

         // make a few write specified addresses
         repeat (5) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {{16'd0},{16'd0},{16'd0},{16'd100}};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // Read all inputs made
         for (int i=0;i<10;i++) begin
            stim = new();
            stim.rd_en = 4'hf;
            test2gen.put(stim);
         end

      end
   endtask

endclass