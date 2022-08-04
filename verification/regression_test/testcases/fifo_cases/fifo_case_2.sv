// Fifo case where we fill the FIFO ports, read twice from it, then write to it again

class fifo_case_2 extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,520);
   endfunction

   task run_cases(); begin
      // assign port prios and addresses
      for (int i=0;i<4;i++) begin
         stim = new();
         stim.port_sel = i;
         stim.port_en = 1'b1;
         stim.port_wr = 1'b1;
         stim.port_addr = i+1;
         stim.prio_wr = 1'b1;
         stim.prio_val = i*2+10;
         test2gen.put(stim);
      end

      // fill fifo ports
      repeat (64) begin
         stim = new();
         if (stim.randomize()) begin
            stim.addr_in = {16'd1,16'd1,16'd1,16'd1};
            stim.wr_en = 4'hf;
         end
         test2gen.put(stim);
      end
      repeat (64) begin
         stim = new();
         if (stim.randomize()) begin
            stim.addr_in = {16'd2,16'd2,16'd2,16'd2};
            stim.wr_en = 4'hf;
         end
         test2gen.put(stim);
      end
      repeat (64) begin
         stim = new();
         if (stim.randomize()) begin
            stim.addr_in = {16'd3,16'd3,16'd3,16'd3};
            stim.wr_en = 4'hf;
         end
         test2gen.put(stim);
      end
      repeat (64) begin
         stim = new();
         if (stim.randomize()) begin
            stim.addr_in = {16'd4,16'd4,16'd4,16'd4};
            stim.wr_en = 4'hf;
         end
         test2gen.put(stim);
      end

      // Read twice
      repeat(2) begin
         stim = new();
         stim.rd_en = 4'hf;
         test2gen.put(stim);
      end

      // Write twice again
      repeat (2) begin
         stim = new();
         if (stim.randomize()) begin
            stim.addr_in = {16'd1,16'd2,16'd3,16'd4};
            stim.wr_en = 4'hf;
         end
         test2gen.put(stim);
      end

      // Empty all 256 in FIFO
      repeat (256) begin
         stim = new();
         stim.rd_en = 4'hf;
         test2gen.put(stim);
      end

   end
   endtask


endclass