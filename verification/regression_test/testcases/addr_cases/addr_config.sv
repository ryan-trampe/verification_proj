// addr check when all 4 ports have their addresses change

class addr_config extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,28);
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

         // make a write to all addresses
         repeat (5) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {{16'd5},{16'd10},{16'd15},{16'd20}};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // change all addresses
         for (int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel = i;
            stim.port_en = 1;
            stim.port_wr = 1;
            stim.port_addr = i*10+10;
            test2gen.put(stim);
         end

         // make a write to all addresses
         repeat (5) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {{16'd10},{16'd30},{16'd20},{16'd40}};
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