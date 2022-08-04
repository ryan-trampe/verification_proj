class sanity_check extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,176);
   endfunction

   task run_cases();
      begin
         // start with empty test
         stim = new();
         test2gen.put(stim);

         for (int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel = i;
            stim.prio_wr = 1'b1;
            stim.prio_val = $urandom();
            test2gen.put(stim);
         end

         // Port Priority Assignments;
         repeat(50) begin
            stim = new();
            stim.port_sel = $urandom();
            stim.prio_wr = 1'b1;
            stim.prio_val = $urandom();
            test2gen.put(stim);
         end

         // Port Address Assignments;
         repeat(100) begin
            stim = new();
            stim.port_en = 1'b1;
            stim.port_wr = 1'b1;
            stim.port_sel = $urandom();
            stim.port_addr = $urandom();
            test2gen.put(stim);
         end

         // Random Input Assignments
         repeat(10) begin
            stim = new();
            stim.data_in = {$urandom(),$urandom()};
            stim.addr_in = {$urandom(),$urandom()};
            stim.wr_en = 4'hf;
            test2gen.put(stim);
         end

         repeat(10) begin
            stim = new();
            stim.rd_en = 4'hf;
            test2gen.put(stim);
         end

         // end with empty stim
         stim = new(); // Transaction 
         test2gen.put(stim);
      end
   endtask

endclass