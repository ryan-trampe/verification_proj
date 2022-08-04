package xswitch_test_pkg;

class stim_transaction;
   bit [63:0] addr_in;
   bit [63:0] data_in;
   
   bit [3:0] wr_en,rd_en;
   bit [7:0] prio_val;
   bit [15:0] port_addr;
   bit [1:0] port_sel;
   bit port_wr,prio_wr,port_en;
endclass

class testcase;
   stim_transaction stim;
   mailbox test2gen;
   int num_stim;

   function new(mailbox test2gen, int num_stim);
      this.test2gen = test2gen;
      this.num_stim = num_stim;
   endfunction

   virtual task run_cases();
      begin
         $display("Should not print");
      end
   endtask
endclass


class sanity_check extends testcase;
   function new(mailbox test2gen);
      super.new(test2gen,14);
   endfunction

   task run_cases();
      begin
         // start with empty test
         stim = new();
         test2gen.put(stim);

         // Configure output ports addresses and priorities
         stim = new(); // Transaction 1
         stim.port_en = 1'b1;
         stim.port_wr = 1'b1;
         stim.port_sel = 2'd0;
         stim.port_addr = 16'h0;
         stim.prio_wr = 1'b1;
         stim.prio_val = 8'h00;
         test2gen.put(stim);
         stim = new(); // Transaction 2
         stim.port_en = 1'b1;
         stim.port_wr = 1'b1;
         stim.port_sel = 2'd1;
         stim.port_addr = 16'h1111;
         stim.prio_wr = 1'b1;
         stim.prio_val = 8'h11;
         test2gen.put(stim);
         stim = new(); // Transaction 3
         stim.port_en = 1'b1;
         stim.port_wr = 1'b1;
         stim.port_sel = 2'd2;
         stim.port_addr = 16'h2222;
         stim.prio_wr = 1'b1;
         stim.prio_val = 8'h22;
         test2gen.put(stim);
         stim = new(); //  Transaction 4
         stim.port_en = 1'b1;
         stim.port_wr = 1'b1;
         stim.port_sel = 2'd3;
         stim.port_addr = 16'h3333;
         stim.prio_wr = 1'b1;
         stim.prio_val = 8'h33;
         test2gen.put(stim);

         // make 4 random assignments and read at the same time
         stim = new(); //Transaction 5
         stim.addr_in = 64'h3333222211110000;
         stim.data_in = {$urandom(),$urandom()};
         stim.wr_en = 4'hf;
         test2gen.put(stim);
         stim = new(); // Transaction 6
         stim.addr_in = 64'h3333222211110000;
         stim.data_in = {$urandom(),$urandom()};
         stim.wr_en = 4'hf;
         test2gen.put(stim);
         stim = new(); // Transaction 7
         stim.addr_in = 64'h3333222211110000;
         stim.data_in = {$urandom(),$urandom()};
         stim.wr_en = 4'hf;
         test2gen.put(stim);
         stim = new(); // Transaction 8
         stim.addr_in = 64'h3333222211110000;
         stim.data_in = {$urandom(),$urandom()};
         stim.wr_en = 4'hf;
         test2gen.put(stim);

         stim = new(); // Transaction 9
         stim.rd_en = 4'hf;
         test2gen.put(stim);
         stim = new(); // Transaction 10
         stim.rd_en = 4'hf;
         test2gen.put(stim);
         stim = new(); // Transaction 11
         stim.rd_en = 4'hf;
         test2gen.put(stim);
         stim = new(); // Transaction 12
         stim.rd_en = 4'hf;
         test2gen.put(stim);

         // end with empty stim
         stim = new(); // Transaction 13
         test2gen.put(stim);
      end
   endtask
   
endclass





















endpackage