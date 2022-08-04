
class prio_change extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,15);
   endfunction

   task run_cases(); begin
      // assign port prios
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

      // Make a write to one ofthe port
      stim = new();
      if (stim.randomize()) begin
         stim.addr_in = {4{16'd3}};
         stim.wr_en = 4'hf;
      end
      test2gen.put(stim);

      // adjust a priority
      stim = new();
      stim.port_sel = 2;
      stim.prio_wr = 1;
      stim.prio_val = 500;
      test2gen.put(stim);

      // Make a write to one ofthe port
      stim = new();
      if (stim.randomize()) begin
         stim.addr_in = {4{16'd3}};
         stim.wr_en = 4'hf;
      end
      test2gen.put(stim);

      // Read all fifos
      repeat (8) begin
         stim = new();
         stim.rd_en = 4'hf;
         test2gen.put(stim);
      end
   end
   endtask

endclass