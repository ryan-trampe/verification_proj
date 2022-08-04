class reset_check extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,20);
   endfunction

   task run_cases(); begin
      // Port configuration
      for (int i=0;i<4;i++) begin
         stim = new();
         stim.port_sel = i;
         stim.port_wr = 1;
         stim.port_en = 1;
         stim.port_addr = i+1;
         stim.prio_wr = 1;
         stim.prio_val = i*5+1;
         test2gen.put(stim);
      end

      // run a number of times
      repeat (10) begin
         stim = new();
         if (stim.randomize()) begin
            stim.addr_in = {16'd4,16'd2,16'd3,16'd1};
            stim.rd_en = 4'hf;
            stim.wr_en = 4'hf;
            test2gen.put(stim);
         end
      end

      // then reset
      stim = new();
      stim.driv_reset = 1;
      test2gen.put(stim);

      // Configure port again
      for (int i=0;i<4;i++) begin
         stim = new();
         stim.port_sel = i;
         stim.port_wr = 1;
         stim.port_en = 1;
         stim.port_addr = i+1;
         stim.prio_wr = 1;
         stim.prio_val = i*5+1;
         test2gen.put(stim);
      end

      // Read to check if data is still stored
      stim = new();
      stim.rd_en = 4'hf;
      test2gen.put(stim);

   end
   endtask


endclass