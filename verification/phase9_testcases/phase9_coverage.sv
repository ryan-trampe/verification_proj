`ifndef _COVERAGE_
`define _COVERAGE_

class coverage;

transaction trans;
covergroup xswitch_coverage;
   // options
   option.per_instance = 1;

   // Receive port coverage
   addressIn_0    : coverpoint trans.addr_in[15:0];
   addressIn_1    : coverpoint trans.addr_in[31:16];
   addressIn_2    : coverpoint trans.addr_in[47:32];
   addressIn_3    : coverpoint trans.addr_in[63:48];
   dataIn_0       : coverpoint trans.data_in[15:0];
   dataIn_1       : coverpoint trans.data_in[31:16];
   dataIn_2       : coverpoint trans.data_in[47:32];
   dataIn_3       : coverpoint trans.data_in[63:48];
   write_en       : coverpoint trans.wr_en;
   data_receive   : coverpoint trans.data_rcv;

   // Destination port coverage
   addressOut_0   : coverpoint trans.addr_out[15:0]{
      bins valid_addr_0 = {[0:3]};
   }
   addressOut_1   : coverpoint trans.addr_out[31:16]{
      bins valid_addr_1 = {[0:3]};
   }
   addressOut_2   : coverpoint trans.addr_out[47:32]{
      bins valid_addr_2 = {[0:3]};
   }
   addressOut_3   : coverpoint trans.addr_out[63:48]{
      bins valid_addr_3 = {[0:3]};
   }
   dataOut_0      : coverpoint trans.data_out[15:0];
   dataOut_1      : coverpoint trans.data_out[31:16];
   dataOut_2      : coverpoint trans.data_out[47:32];
   dataOut_3      : coverpoint trans.data_out[63:48];
   data_ready     : coverpoint trans.data_rdy;
   read_en        : coverpoint trans.rd_en;

   // Port Addressing Coverage
   port_enable    : coverpoint trans.port_en;
   port_write     : coverpoint trans.port_wr;
   port_select    : coverpoint trans.port_sel;
   port_addrress  : coverpoint trans.port_addr;

   // Priority Coverage
   priority_wr    : coverpoint trans.prio_wr;
   priority_val   : coverpoint trans.prio_val;

   // FIFO Coverage
   fifo_full      : coverpoint trans.fifo_full;
   fifo_empty     : coverpoint trans.fifo_empty;
   fifo_ae        : coverpoint trans.fifo_ae;
   fifo_af        : coverpoint trans.fifo_af;
   
   // Cross type of receive inputs
   input_combs    : cross write_en,data_receive;
   output_combs   : cross data_ready, read_en;


endgroup


function new();
   xswitch_coverage = new();
endfunction

task sample(transaction trans);
   this.trans = trans;
   xswitch_coverage.sample();
endtask

endclass
`endif