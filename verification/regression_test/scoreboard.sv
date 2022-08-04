`ifndef _SCB_
`define _SCB_
`include "data_fifo.sv"
`include "coverage.sv"

class scoreboard;
   // Mailbox to receive from monitor
   mailbox mon2scb;
   // File descriptor to write resutls
   int err_fd,out_fd;
   // Int to write how many stim runs
   int repeat_count;
   // number of errors
   int error_count;
   // current trasactions to be used and previous transaction
   transaction trans,prev_trans;
   // fifos to keep track of data and addresses for each port
   data_fifo data_q [4];
   data_fifo addr_q [4];
   // store port priorities in array
   bit [7:0] port_prio [4];
   int prio_list[4];
   // store assigned addresses of output ports in an array
   bit [15:0] port_addr [4];
   // current data and addresses that are being showwn on the ports by monitor
   bit [63:0] cur_data_out;
   bit [63:0] cur_addr_out;
   // Transaction based coverage
   coverage cov;
   

   // constructor
   function new(int repeat_count, mailbox mon2scb, int fd);
      this.repeat_count = repeat_count;
      this.err_fd = $fopen("report/phase9_err.txt","w");
      this.out_fd = fd;
      this.mon2scb = mon2scb;
      this.error_count = 0;
      this.prio_list = {0,1,2,3};
      foreach(data_q[i]) begin
         data_q[i] = new();
         // data_q[i].push(16'h0);
      end
      foreach(addr_q[i]) begin
         addr_q[i] = new();
         // addr_q[i].push(16'h0);
      end
      prev_trans = new();
      cur_data_out = 0;
      cur_addr_out = 0;
      this.cov = new();
   endfunction

   local task check_output_ports(int n);
      bit [16:0] expected_data;
      bit [16:0] expected_addr;

      if (trans.rd_en[n] && data_q[n].size()>0) begin
         expected_data = data_q[n].pop();
         expected_addr = addr_q[n].pop();
      end else begin
         // expected_data = prev_trans.data_out[n];
         // expected_addr = prev_trans.addr_out[n];
         expected_data = cur_data_out[16*n+:16];
         expected_addr = cur_addr_out[16*n+:16];
      end

      if (trans.data_rdy[n] && trans.rd_en[n]) begin
         // check if transaction and expected are the same 
         if (trans.data_out[16*n+:16] != expected_data) begin
            error_count += 1;
            $fdisplay(err_fd,"Error: data_out     [%1d] = 0x%4h",n,trans.data_out[16*n+:16]);
            $fdisplay(err_fd,"Error: expected_data[%1d] = 0x%4h",n,expected_data);
         end
         if (trans.addr_out[16*n+:16] != expected_addr) begin
            error_count += 1;
            $fdisplay(err_fd,"Error: addr_out     [%1d] = 0x%4h",n,trans.addr_out[16*n+:16]);
            $fdisplay(err_fd,"Error: expected_addr[%1d] = 0x%4h",n,expected_addr);
         end
      end
   endtask

   /* Function to search each port_addr to see if a given address is there
   and insert data and address into that queue
   */
   local task store_data_addr(int in, int n);
   bit [15:0] local_port_addr  = port_addr[n];
      if (local_port_addr == trans.addr_in[16*n+:16]) begin
         data_q[n].push(trans.data_in[16*in+:16]);
         addr_q[n].push(in);
      end
   endtask

   // Task to sort prio_list indexing array using current prio_list values
   local task prio_sort();
      int temp_list[] = prio_list;
      int i,j,temp;

      i = 1;
      // First sort based on priority
      while (i<4) begin
         j = i;
         while (j>0 && (port_prio[temp_list[j-1]] < port_prio[temp_list[j]])) begin
            temp = temp_list[j];
            temp_list[j] = temp_list[j-1];
            temp_list[j-1] = temp;
            j-=1;
         end
         i+=1;
      end

      // then check if priorities are the same and sort based on index
      for (i=0;i<3;i++) begin
         if (port_prio[temp_list[i]] == port_prio[temp_list[i+1]]) begin
            if (temp_list[i] > temp_list[i+1]) begin
               temp = temp_list[i];
               temp_list[i] = temp_list[i+1];
               temp_list[i+1] = temp;
            end
         end
      end   

      prio_list = temp_list;
   endtask

   // Task to check a specific port #'s fifo outputs
   local task fifo_check(int i);
      int cur_size = data_q[i].size();
      if ((cur_size == 256 && !trans.fifo_full[i]) || (cur_size!=256 && trans.fifo_full[i])) begin
         error_count++;
         $fdisplay(err_fd,"Error:port #%1d fifo_full",i);
         $fdisplay(err_fd,"expected size: %1d  received: %1d",cur_size, trans.fifo_full[i]);
      end
      if ((cur_size>192 && !trans.fifo_af[i]) || (cur_size<=192 && trans.fifo_af[i])) begin
         error_count++;
         $fdisplay(err_fd,"Error:port #%1d fifo_af",i);
         $fdisplay(err_fd,"expected size: %1d  received: %1d",cur_size, trans.fifo_af[i]);
      end
      if ((cur_size>=64 && trans.fifo_ae[i]) || (cur_size<64 && !trans.fifo_ae[i])) begin
         error_count++;
         $fdisplay(err_fd,"Error:port #%1d fifo_ae",i);
         $fdisplay(err_fd,"expected size: %1d  received: %1d",cur_size, trans.fifo_ae[i]);
      end
      if ((cur_size!=0 && trans.fifo_empty[i]) || (cur_size==0 && trans.fifo_empty[i]==0)) begin
         error_count++;
         $fdisplay(err_fd,"Error:port #%1d fifo_empty",i);
         $fdisplay(err_fd,"expected size: %1d  received: %1d",cur_size, trans.fifo_empty[i]);
      end
   endtask

   local task reset_scb();
      this.prio_list = {0,1,2,3};
      foreach (port_prio[i])
         port_prio[i] = 0;
      foreach(data_q[i]) begin
         data_q[i] = new();
      end
      foreach(addr_q[i]) begin
         addr_q[i] = new();
      end
      foreach (port_addr[i])
         port_addr[i] = 0;
      cur_data_out = 0;
      cur_addr_out = 0;
   endtask

   task main;
      for(int cur_stim = 0;cur_stim<repeat_count;cur_stim++) begin
         $fdisplay(err_fd,"[Scoreboard]: Transaction %1d)",cur_stim);
         mon2scb.get(trans);
         cov.sample(trans);

         // If reset, then apply reset first
         if (trans.driv_reset)
            reset_scb();

         // check the monitor port if its correct
         for (int i=0;i<4;i++)
            check_output_ports(i);

         // logic to store new data/addr pair inside according to prio
         // also checks data_rcv
         foreach (prio_list[n]) begin // loop over input ports in order of priority
            int src_port = prio_list[n];
            if (trans.wr_en[src_port]) begin
               for (int i=0;i<4;i++) begin // loop over each output port & check if matching addr
                  // if matching addresses and there is room on target port then apply
                  if (port_addr[i] == trans.addr_in[16*src_port+:16] && data_q[i].size()<256) begin
                     data_q[i].push(trans.data_in[16*src_port+:16]);
                     addr_q[i].push(src_port);
                     // When data is pushed onto queue, check data_rcv (should be asserted)
                     if (trans.data_rcv[src_port] == 0) begin
                        error_count++;
                        $fdisplay(err_fd,"Error: port%1d data_rcv",src_port);
                        $fdisplay(err_fd,"Data was stored, but data_rcv=1'b0");
                     end
                  end
               end
            end
         end

         // assign new addresses to output ports
         for (int i=0;i<4;i++) begin
            if (trans.port_en && trans.port_wr && trans.port_sel == i)
               port_addr[i] = trans.port_addr;
         end

         // Logic to storing new priorities
         for (int i=0; i<4; i++) begin
            if (trans.prio_wr && trans.port_sel == i)
               port_prio[i] = trans.prio_val;
         end

         // Sort prio_addr list 
         prio_sort();

         // check data_rdy based on whether there is data on the port fifo
         for (int i=0;i<4;i++) begin
            if (data_q[i].size() > 0 && !trans.data_rdy[i]) begin
               error_count++;
               $fdisplay(err_fd,"Error:port #%1d data_rdy0",i);
               $fdisplay(err_fd,"fifo size:%1d   data_rdy:0b%1b",data_q[i].size(),trans.data_rdy[i]);
            end
            if (data_q[i].size() == 0 && trans.data_rdy[i] && 
            trans.data_out[16*i+:16] == prev_trans.data_out[16*i+:16] &&
            trans.addr_out[16*i+:16] == prev_trans.addr_out[16*i+:16])begin
               error_count++;
               $fdisplay(err_fd,"Error:port #%1d data_rdy1",i);
               $fdisplay(err_fd,"fifo size:%1d   data_rdy:0b%1b",data_q[i].size(),trans.data_rdy[i]);
            end 
         end
         
         // check that the fifo outputs are correct
         for (int i=0;i<4;i++) begin
            fifo_check(i);
         end

         // Display transactions based on what was driven/monitored;
         $fdisplay(out_fd,"#################### Trans %0d @ %0d ####################",cur_stim,$time);
         // if (trans.port_en && trans.port_wr)
         //    trans.display_addr_file("[Scoreboard]",out_fd);
         // if (trans.prio_wr)
         //    trans.display_prio_file("[Scoreboard]",out_fd);
         // if (trans.wr_en > 0)
            trans.display_src_file("[Scoreboard]",out_fd);
         // if (trans.rd_en > 0)
            trans.display_dst_file("[Scoreboard]",out_fd);
         trans.display_fifo_file("[Scoreboard]",out_fd);

         // Display current machine state
         // Display addresses
         $fdisplayh(err_fd,"Output Addresses: %p",port_addr);
         // Display priorities
         $fdisplay(err_fd,"Port Priority order: %p", prio_list);
         $fdisplay(err_fd,"Port Priority values: %p", port_prio);
         // Display addr/data pairs
         for (int i=0;i<4;i++) begin
            data_q[i].fdisplay_data("data",err_fd);
            addr_q[i].fdisplay_data("addr",err_fd);
         end

         // Store final data/addr output
         cur_data_out = trans.data_out;
         cur_addr_out = trans.addr_out;
         // Store old transaction
         prev_trans = trans;
      end
      $fclose(err_fd);
      $display("[Scoreboard]: Error Count: %d",error_count);
      $display("[Scoreboard]: Coverage = %0.2f",cov.xswitch_coverage.get_inst_coverage());
   endtask

endclass;
`endif