class sanity_check extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,29);
   endfunction

   task run_cases();
      begin
         // begin with a reset
         stim = new();
         stim.driv_reset = 1'b1;
         test2gen.put(stim);

         // Port Priority Assignments;
         for(int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel = i;
            stim.prio_wr = 1'b1;
            stim.prio_val = i+1;
            test2gen.put(stim);
         end

         // 4 Port Address Assignments;
         for(int i=0;i<4;i++) begin
            stim = new();
            stim.port_en = 1'b1;
            stim.port_wr = 1'b1;
            stim.port_sel = i;
            stim.port_addr = i+1;
            test2gen.put(stim);
         end

         // 10 Input Assignments
         repeat(10) begin
            stim = new();
            stim.data_in = 64'h12345678aabbccdd;
            stim.addr_in = {16'h1,16'h2,16'h3,16'h4};
            stim.wr_en = 4'hf;
            test2gen.put(stim);
         end

         // 10 read assignments
         repeat(10) begin
            stim = new();
            stim.rd_en = 4'hf;
            test2gen.put(stim);
         end
      end
   endtask

endclass