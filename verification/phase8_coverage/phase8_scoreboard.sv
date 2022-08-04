`ifndef _SCB_
`define _SCB_
`include "phase8_data_fifo.sv"
`include "phase8_coverage.sv"

class scoreboard;
   // Mailbox to receive from monitor
   mailbox mon2scb;
   // File descriptor to write resutls
   int fd;
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
   // store assigned addresses of output ports in a searchable queue
   bit [15:0] port_addr [4][$];
   // Transaction based coverage
   coverage cov;
   

   // constructor
   function new(int repeat_count, mailbox mon2scb, int fd);
      this.repeat_count = repeat_count;
      this.fd = fd;
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
      this.prev_trans = new();
      this.cov = new();
   endfunction

   local task check_output_ports(int n);
      bit [16:0] expected_data;
      bit [16:0] expected_addr;

      if (trans.rd_en[n] && data_q[n].size()!=0) begin
         expected_data = data_q[n].pop();
         expected_addr = addr_q[n].pop();
      end else begin
         expected_data = prev_trans.data_out[n];
         expected_addr = prev_trans.addr_out[n];
      end

      if (trans.data_rdy[n] && trans.rd_en[n]) begin
         // check if transaction and expected are the same 
         if (trans.data_out[16*n+:16] != expected_data) begin
            error_count += 1;
            $display("Error: data_out     [%1d] = 0x%4h",n,trans.data_out[16*n+:16]);
            $display("Error: expected_data[%1d] = 0x%4h",n,expected_data);
         end
         if (trans.addr_out[16*n+:16] != expected_addr) begin
            error_count += 1;
            $display("Error: addr_out     [%1d] = 0x%4h",n,trans.addr_out[16*n+:16]);
            $display("Error: expected_addr[%1d] = 0x%4h",n,expected_addr);
         end
      end
   endtask

   /* Function to search each port_addr to see if a given address is there
   and insert data and address into that queue
   */
   local task store_data_addr(int in, int n);
   bit [15:0] local_port_addr [$] = port_addr[n];
      foreach(local_port_addr[i]) begin
         if (local_port_addr[i] == trans.addr_in[16*in+:16]) begin
            data_q[n].push(trans.data_in[16*in+:16]);
            addr_q[n].push(in);
         end
      end
   endtask

   // Task to sort prio_list indexing array using current prio_list values
   local task prio_sort();
      int temp_list[] = prio_list;
      int i,j,min,temp;
      for (i=0;i<4;i++) begin
         min = i;
         for (j=i;j<4;j++) begin
            if (port_prio[prio_list[j]] > port_prio[prio_list[min]])
               min = j;
         end
         if (min != i) begin
            temp = temp_list[min];
            temp_list[min] = temp_list[i];
            temp_list[i] = temp;
         end
      end   

      prio_list = temp_list;
      // $display("port priorities: %p",port_prio);
      // $display("priority list: %p",prio_list);
   endtask

   task main;
      for(int cur_stim = 0;cur_stim<repeat_count;cur_stim++) begin
         // $display("Transaction %1d)",cur_stim);
         mon2scb.get(trans);
         cov.sample(trans);
         
         // check the monitor port if its correct
         for (int i=0;i<4;i++)
            check_output_ports(i);

         // Add new addresses to output ports
         for (int i=0;i<4;i++) begin
            if (trans.port_en && trans.port_wr && trans.port_sel == i)
               port_addr[i].push_back(trans.port_addr);
            // $displayh("port_addr[%1d]:%p",i,port_addr[i]);
         end

         // Logic to storing new priorities
         for (int i=0; i<4; i++) begin
            if (trans.prio_wr && trans.port_sel == i)
               port_prio[i] = trans.prio_val;
            // $displayh("port_prio[%1d]:%p",i,port_prio[i]);
         end
         /* TODO: Need to change prio_sort to also handle same priorities 
         and choose the smaller address */
         prio_sort();
         
         // logic to store new data/addr pair inside according to prio
         for (int n=0;n<4;n++) begin // loop over ports in order of priority
            if (trans.wr_en[n] && trans.data_rcv[n]) begin
               for (int i=0;i<4;i++)
                  store_data_addr(prio_list[n],i);
            end
         end

         // TODO check that the fifo outputs are correct
         for (int i=0;i<4;i++) begin
            int cur_size = data_q[i].size();
            if ((cur_size == 256 && !trans.fifo_full[i]) || (cur_size!=256 && trans.fifo_full[i])) begin
               error_count++;
               $display("[Scoreboard]: Error:port #%1d fifo_full",i);
               $display("[Scoreboard]: expected: %1d  received: %1d",cur_size, trans.fifo_full[i]);
            end
            if ((cur_size>=192 && !trans.fifo_af[i]) || (cur_size<192 && trans.fifo_af[i])) begin
               error_count++;
               $display("[Scoreboard]: Error:port #%1d fifo_af",i);
               $display("[Scoreboard]: expected: %1d  received: %1d",cur_size, trans.fifo_af[i]);
            end
            if ((cur_size>=64 && trans.fifo_ae[i]) || (cur_size<64 && !trans.fifo_ae[i])) begin
               error_count++;
               $display("[Scoreboard]: Error:port #%1d fifo_ae",i);
               $display("[Scoreboard]: expected: %1d  received: %1d",cur_size, trans.fifo_ae[i]);
            end
            if ((cur_size!=0 && trans.fifo_empty[i]) || (cur_size==0 && trans.fifo_empty[i]==0)) begin
               error_count++;
               $display("[Scoreboard]: Error:port #%1d fifo_empty",i);
               $display("[Scoreboard]: expected: %1d  received: %1d",cur_size, trans.fifo_empty[i]);
            end
         end

         prev_trans = trans;

      end
      $display("[Scoreboard]: Error Count: %d",error_count);
      $display("[Scoreboard]: Coverage = %0.2f",cov.xswitch_coverage.get_inst_coverage());
   endtask

endclass;
`endif