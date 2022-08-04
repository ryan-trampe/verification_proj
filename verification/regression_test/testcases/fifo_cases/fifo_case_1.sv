// First case fills every fifo and empties it to checkif every port is working correctly

class fifo_case_1 extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,516);
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
            stim.prio_val = i*2+10;
            test2gen.put(stim);
         end

         // make 256 writes to every port
         repeat (256) begin
            stim = new();
            if (stim.randomize()) begin
               stim.addr_in = {16'd1,16'd3,16'd4,16'd2};
               stim.wr_en = 4'hf;
            end
            test2gen.put(stim);
         end

         // make an extra write to the ports
         // stim = new();
         // if (stim.randomize()) begin
         //    stim.addr_in = {16'd1,16'd3,16'd4,16'd2};
         //    stim.wr_en = 4'hf;
         // end
         // test2gen.put(stim);

         // make 256 rd to every port
         for (int i=0;i<256;i++) begin
            stim = new();
            stim.rd_en = 4'hf;
            test2gen.put(stim);
         end

      end
   endtask

endclass