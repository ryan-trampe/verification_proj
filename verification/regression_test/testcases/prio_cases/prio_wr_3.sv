// Priority testcase that tests if prio_wr for port 3 is functioning

class prio_wr_3 extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,45);
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

         // make 10 writes to 1 port
         for (int i=0;i<10;i++) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {4{16'd1}};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // change port 0 prio
         stim = new();
         stim.port_sel = 3;
         stim.prio_wr = 1;
         stim.prio_val = 500;
         test2gen.put(stim);

         //make another 10 writes
         for (int i=0;i<10;i++) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {4{16'd1}};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // make 20 reads
         for (int i=0;i<20;i++) begin
            stim = new();
            stim.rd_en = 4'hf;
            test2gen.put(stim);
         end
      end
   endtask


endclass