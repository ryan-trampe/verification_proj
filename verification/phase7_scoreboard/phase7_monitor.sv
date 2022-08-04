`ifndef _MONITOR_
`define _MONITOR_

class monitor;
    // create virtual interface handle;
    virtual intf vif;
    // declare mailbox handles
    mailbox driv2mon;
    mailbox mon2scb;
    int repeat_count;
    int fd;

    // constructor
    function new(int repeat_count,virtual intf vif, mailbox driv2mon, mailbox mon2scb, int file_d);
        // get the modport interface
        this.vif = vif;
        // get file descriptor
        this.fd = file_d;
        // get mailbox handles and count of cases
        this.repeat_count = repeat_count;
        this.driv2mon = driv2mon;
        this.mon2scb = mon2scb;
    endfunction

    task main;
        repeat(repeat_count) begin
            transaction trans;
            driv2mon.get(trans);
            @vif.negative_cb;
            trans.addr_out      = vif.addr_out;
            trans.data_out      = vif.data_out;
            trans.data_rdy      = vif.data_rdy;
            trans.data_rcv      = vif.data_rcv;
            trans.fifo_empty    = vif.fifo_empty;
            trans.fifo_full     = vif.fifo_full;
            trans.fifo_ae       = vif.fifo_ae;
            trans.fifo_af       = vif.fifo_af;
            // trans.display_outputs("[Monitor]");
            trans.display_out_file("[Monitor]",fd);
            mon2scb.put(trans);
        end
    endtask

endclass



`endif