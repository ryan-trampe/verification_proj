`ifndef _DRIVER_
`define _DRIVER_

class driver;
    // create virtual interface handle
    virtual intf.driver_port vif;
    // create mailbox handle
    mailbox gen2driv;
    // count the number of transactions
    int repeat_count;

    // constructor
    function new(int repeat_count,virtual intf.driver_port vif, mailbox gen2driv);
        // number of driver cycles
        this.repeat_count = repeat_count;
        // get the interface
        this.vif = vif;
        // get the mailbox
        this.gen2driv = gen2driv;
    endfunction

    task main;
        repeat (repeat_count) begin
            transaction trans;
            gen2driv.get(trans);
            @vif.positive_cb;
            vif.addr_in     <= trans.addr_in;
            vif.data_in     <= trans.data_in;
            vif.wr_en       <= trans.wr_en;
            vif.rd_en       <= vif.rd_en;
            vif.port_sel    <= vif.port_sel;
            vif.port_en     <= vif.port_en;
            vif.port_wr     <= vif.port_wr;
            vif.port_addr   <= vif.port_addr;
            vif.prio_wr     <= vif.prio_wr;
            vif.prio_val    <= vif.prio_val;
            trans.display_outputs("[Driver]");
        end
    endtask

endclass
`endif