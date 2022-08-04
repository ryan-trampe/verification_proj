
class crv_input;
   // config bits
   rand bit [7:0] prio_val;
   randc bit [15:0] port_addr;
   rand bit [1:0] port_sel;
   rand bit port_wr,prio_wr,port_en;

   // input bits
   rand bit [15:0] addr_in0;
   rand bit [15:0] addr_in1;
   rand bit [15:0] addr_in2;
   rand bit [15:0] addr_in3;
   rand bit [63:0] data_in;
   rand bit [3:0] wr_en,rd_en;

   // randomize between config(1) | I/O(0)
   rand bit config_mode;
   
   // array of current addresses that output port is configured to
   bit [15:0] output_addr [4] = {0,1,2,3};
   // array of current priorities assigned to input ports
   int input_prios[4] = {0,0,0,0};

   /* Constraints */
   // Constrain port_sel to be on the valid numbers
   constraint valid_port_sel {port_sel inside {[0:3]};}
   // Constrain each of the addresses to be inside the valid addresses
   constraint valid_addr0 {addr_in0 inside {output_addr};}
   constraint valid_addr1 {addr_in1 inside {output_addr};}
   constraint valid_addr2 {addr_in2 inside {output_addr};}
   constraint valid_addr3 {addr_in3 inside {output_addr};}
   // constrain config mode to skew probabilites of each one
   constraint config_prob {config_mode dist {0:=8,1:=2};}
   // constrain priorities to be not unique from currently assigned priorities
   constraint unique_prio {!(prio_val inside {input_prios});}

endclass

class randomized_testing extends testcase;
   crv_input rand_in;
   // number of iterations
   int num_it = 500000;

   function new(mailbox test2gen);
      super.new(test2gen,500004);
      rand_in = new();
   endfunction

   task run_cases();
      begin
         // begin by configuring each port
         for (int i=0;i<4;i++) begin
            stim = new();
            stim.port_sel     = i;
            stim.port_en      = 1'b1;
            stim.port_wr      = 1;
            stim.port_addr    = i+1;
            stim.prio_wr      = 1;
            stim.prio_val     = i*5+1;
            rand_in.output_addr[i] = i+1;
            rand_in.input_prios[i] = i*5+1;
            test2gen.put(stim);
         end
         $display("Reaches here");
         // Then begin CRV
         repeat (num_it) begin
            if (rand_in.randomize()) begin
               stim = new();
               if (rand_in.config_mode) begin
                  // Configuration mode
                  stim.port_sel     = rand_in.port_sel;
                  stim.port_en      = rand_in.port_en;
                  stim.port_wr      = rand_in.port_wr;
                  stim.port_addr    = rand_in.port_addr;
                  stim.prio_wr      = rand_in.prio_wr;
                  stim.prio_val     = rand_in.prio_val;
                  if (rand_in.port_wr)
                     rand_in.output_addr[rand_in.port_sel] = rand_in.port_addr;
                  if (rand_in.prio_wr)
                     rand_in.input_prios[rand_in.port_sel] = rand_in.prio_val;
               end else begin
                  // I/O mode
                  stim.addr_in      = {rand_in.addr_in3,rand_in.addr_in2,rand_in.addr_in1,rand_in.addr_in0};
                  stim.data_in      = rand_in.data_in;
                  stim.wr_en        = rand_in.wr_en;
                  stim.rd_en        = rand_in.rd_en;
               end
               test2gen.put(stim);
            end
         end
      end
   endtask

endclass