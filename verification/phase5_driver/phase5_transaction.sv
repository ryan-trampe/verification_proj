class transaction;
    // source ports
    bit [63:0]    addr_in;
    bit [63:0]    data_in;
    bit [3:0]     wr_en;
    bit [3:0]     data_rcv;
    // destination ports
    bit [63:0]    addr_out;
    bit [63:0]    data_out;
    bit [3:0]     rd_en;
    bit [3:0]     data_rdy;
    // fifo ports
    bit [3:0]     fifo_ae;
    bit [3:0]     fifo_empty;
    bit [3:0]     fifo_full;
    bit [3:0]     fifo_af;
    // prio ports
    bit           prio_wr;
    bit [7:0]     prio_val;
    // port select ports
    bit           port_en;
    bit           port_wr;
    bit [1:0]     port_sel;
    bit [15:0]    port_addr;

    function void display_inputs(string name);
        $display("-----------------------------------------");
        $display(" %s: ---- Source Port Inputs ----",name);
        $display(" %s: addr_in    =0x%0h",name,addr_in);
        $display(" %s: data_in    =0x%0h",name,data_in);
        $display(" %s: wr_en      =0x%0h",name,wr_en);
        $display(" %s: ---- Destination Port Inputs ----",name);
        $display(" %s: rd_en      =0x%0h",name,rd_en);
        $display(" %s: ---- Port Addressing Inputs ----",name);
        $display(" %s: port_sel   =0x%0h",name,port_sel);
        $display(" %s: port_en    =0x%0h",name,port_en);
        $display(" %s: port_wr    =0x%0h",name,port_wr);
        $display(" %s: port_addr  =0x%0h",name,port_addr);
        $display(" %s: ---- Priority Configuration Inputs ----",name);
        $display(" %s: port_sel   =0x%0h",name,port_sel);
        $display(" %s: prio_wr    =0x%0h",name,prio_wr);
        $display(" %s: prio_val   =0x%0h",name,prio_val);
    endfunction

    function void display_outputs(string name);
        $display("-----------------------------------");
        $display(" %s: ---- Destination Port Outputs ----",name);
        $display(" %s: addr_out   =0x%0h",name,addr_out);
        $display(" %s: data_out   =0x%0h",name,data_out);
        $display(" %s: data_rdy   =0x%0h",name,data_rdy);
        $display(" %s: ---- Source Port Outputs ----",name);
        $display(" %s: data_rcv   =0x%0h",name,data_rcv);
        $display(" %s: ---- FIFO Port Outputs ----",name);
        $display(" %s: fifo_empty =0x%0h",name,data_rdy);
        $display(" %s: fifo_full  =0x%0h",name,data_rdy);
        $display(" %s: fifo_ae    =0x%0h",name,data_rdy);
        $display(" %s: fifo_af    =0x%0h",name,data_rdy);
    endfunction



endclass