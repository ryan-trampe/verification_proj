// Fifo case where we fill one FIFO port, rthen make a few read/write cycles

class fifo_case_3 extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,334);
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

      // fill port 0
      for (int i=0;i<64;i++) begin
         stim = new();
         stim.addr_in = {4{16'd1}};
         stim.data_in = 64'h12345678abcddcba;
         stim.wr_en = 4'hf;
         test2gen.put(stim);
      end

      // Make 10 read/writes cycles
      repeat (10) begin
         stim = new();
         stim.addr_in = 1;
         stim.data_in = 64'h12345678abcddcba;
         stim.wr_en = 4'hf;
         stim.rd_en = 4'hf;
         test2gen.put(stim);
      end

      // Empty the FIFO 
      repeat(256) begin
         stim = new();
         stim.rd_en = 4'hf;
         test2gen.put(stim);
      end
   end
   endtask


endclass