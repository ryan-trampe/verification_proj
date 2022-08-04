`ifndef _DRIVER_
`define _DRIVER_

class driver;
    // create virtual interface handle
    virtual intf vif;
    // create mailbox handle
    mailbox gen2driv;
    mailbox driv2mon;
    // count the number of transactions
    int repeat_count;
    int fd;

    // constructor
    function new(int repeat_count,virtual intf vif, mailbox gen2driv,
                mailbox driv2mon, int file_d);
        // number of driver cycles
        this.repeat_count = repeat_count;
        // get the interface
        this.vif = vif;
        // get file descriptor
        this.fd = file_d;
        // get the mailbox
        this.gen2driv = gen2driv;
        this.driv2mon = driv2mon;
    endfunction

    task main;
        repeat (repeat_count) begin
            transaction trans;
            gen2driv.get(trans);
            @vif.positive_cb;
            vif.addr_in     <= trans.addr_in;
            vif.data_in     <= trans.data_in;
            vif.wr_en       <= trans.wr_en;
            vif.rd_en       <= trans.rd_en;
            vif.port_sel    <= trans.port_sel;
            vif.port_en     <= trans.port_en;
            vif.port_wr     <= trans.port_wr;
            vif.port_addr   <= trans.port_addr;
            vif.prio_wr     <= trans.prio_wr;
            vif.prio_val    <= trans.prio_val;
            vif.driv_reset  <= trans.driv_reset;
            // trans.display_inputs("[Driver]");
            // trans.display_in_file("[Driver]",fd);
            driv2mon.put(trans);
        end
    endtask

endclass
`endif