`ifndef _INTERFACE_
`define _INTEFACE_

interface intf(input logic clk,reset);
    // source ports 
    logic [63:0]    addr_in;
    logic [63:0]    data_in;
    logic [3:0]     wr_en;
    logic [3:0]     data_rcv;
    // destination ports
    logic [63:0]    addr_out;
    logic [63:0]    data_out;
    logic [3:0]     rd_en;
    logic [3:0]    data_rdy;
    // fifo ports
    logic [3:0]     fifo_ae;
    logic [3:0]     fifo_empty;
    logic [3:0]     fifo_full;
    logic [3:0]     fifo_af;
    // prio ports
    logic           prio_wr;
    logic [7:0]     prio_val;
    // port select ports
    logic           port_en;
    logic           port_wr;
    logic [1:0]     port_sel;
    logic [15:0]    port_addr;
    // reset
   logic           logic_reset;     
   logic           driv_reset;

   assign driv_reset = logic_reset || reset;
    
    clocking negative_cb @(posedge clk);
        default input #2ns output #1ns;
    endclocking

    clocking positive_cb @(negedge clk);
        default input #2ns output #1ns;
    endclocking

    modport dut_port(
        input driv_reset,clk,
        input addr_in,data_in,wr_en,
        input prio_wr,prio_val,
        input port_en,port_wr,port_sel,port_addr,
        input rd_en,

        output addr_out,data_out,data_rdy,data_rcv,
        output fifo_ae,fifo_af,fifo_empty,fifo_full
    );

    modport driver_port(
        clocking positive_cb,
        output reset,clk,
        output addr_in,data_in,wr_en,
        output prio_wr,prio_val,
        output port_en,port_wr,port_sel,port_addr,
        output rd_en
    );

    modport monitor_port(
        clocking negative_cb,
        input addr_out,data_out,data_rdy,data_rcv,
        input fifo_ae,fifo_af,fifo_empty,fifo_full
    );

endinterface
`endif