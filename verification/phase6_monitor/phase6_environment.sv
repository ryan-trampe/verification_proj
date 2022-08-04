`ifndef _ENV_
`define _ENV_
`include "phase6_generator.sv"
`include "phase6_driver.sv"
`include "phase6_monitor.sv"

class environment;

    // virtual interface
    virtual intf vif;
    // generator/driver instance
    generator gen;
    driver driv;
    monitor mon;
    // mailbox handles
    mailbox gen2driv;
    mailbox driv2mon;
    // Global file descriptor
    int fd;

    // constructor
    function new(int num_cases,virtual intf vif);
        // get the interface from test
        this.vif = vif;
        // create mailbox(es) for data exchange
        gen2driv = new(1);
        driv2mon = new(1);
        // open txt file to write tb outputs
        fd = $fopen("./report/phase6_out.txt","w");
        // create generator instance
        gen = new(num_cases,gen2driv);
        driv = new(num_cases,vif,gen2driv,driv2mon,fd);
        mon = new(num_cases,vif,driv2mon,fd);
    endfunction

    task pre_test();
        $display("[Environment]: Start of pre_test() at %0d",$time);
        reset();
        $display("[Environment]: End of pre_test() at %0d",$time);
    endtask

    task test();
        $display("[Environment]: Start of test() at %0d",$time);
        fork
            gen.main();
            driv.main();
            mon.main();
        join
        $display("[Environment]: End of test() at %0d",$time);
    endtask

    task post_test();
        $display("[Environment]: Start of post_test() at %0d",$time);
        $fclose(fd);
        $display("[Environment]: End of post_test() at %0d",$time);
    endtask

    task reset();
        wait(vif.reset);
        $display("[Environment]: Reset started at %0d",$time);
        vif.addr_in     <= 64'h0000;
        vif.data_in     <= 64'h0000;
        vif.wr_en       <= 4'h0;
        vif.rd_en       <= 4'h0;
        vif.prio_wr     <= 1'b0;
        vif.prio_val    <= 8'h0;
        vif.port_en     <= 1'b0;
        vif.port_wr     <= 1'b0;
        vif.port_sel    <= 2'b0;
        vif.port_addr   <= 16'h0;
        wait(!vif.reset);
        $display("[Environment]: Reset ended at %0d",$time);
    endtask

    task run;
        $display("[Environment]: Start of run() at %0d",$time);
        pre_test();
        test();
        post_test();
        $display("[Environment]: End of run() at %0d",$time);
    endtask


endclass

`endif