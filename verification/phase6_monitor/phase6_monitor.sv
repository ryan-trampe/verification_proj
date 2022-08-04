`ifndef _MONITOR_
`define _MONITOR_

class monitor;
    // create virtual interface handle;
    virtual intf vif;
    // declare mailbox handles
    mailbox driv2mon;
    int repeat_count;
    int fd;

    // constructor
    function new(int repeat_count,virtual intf vif, mailbox driv2mon, int file_d);
        // get the modport interface
        this.vif = vif;
        // get file descriptor
        this.fd = file_d;
        // get mailbox handles and count of cases
        this.repeat_count = repeat_count;
        this.driv2mon = driv2mon;
    endfunction

    task main;
        repeat(repeat_count) begin
            transaction trans;
            driv2mon.get(trans);
            @vif.negative_cb;
            trans.addr_out      = vif.monitor_port.addr_out;
            trans.data_out      = vif.monitor_port.data_out;
            trans.data_rdy      = vif.monitor_port.data_rdy;
            trans.data_rcv      = vif.monitor_port.data_rcv;
            trans.fifo_empty    = vif.monitor_port.fifo_empty;
            trans.fifo_full     = vif.monitor_port.fifo_full;
            trans.fifo_ae       = vif.monitor_port.fifo_ae;
            trans.fifo_af       = vif.monitor_port.fifo_af;
            // trans.display_outputs("[Monitor]");
            trans.display_out_file("[Monitor]",fd);
        end
    endtask

endclass



`endif