`ifndef _ENV_
`define _ENV_
`include "phase9_generator.sv"
`include "phase9_driver.sv"
`include "phase9_monitor.sv"
`include "phase9_scoreboard.sv"

class environment;

   // virtual interface
   virtual intf vif;
   // generator/driver instance
   generator gen;
   driver driv;
   monitor mon;
   scoreboard scb;
   // mailbox handles
   mailbox test2gen;
   mailbox gen2driv;
   mailbox driv2mon;
   mailbox mon2scb;
   // Global file descriptor
   int fd;

   // constructor
   function new(int num_cases,virtual intf vif, mailbox test2gen);
     // get the interface from test
     this.vif = vif;
     // create mailbox(es) for data exchange
     this.test2gen = test2gen;
     this.gen2driv = new(1);
     this.driv2mon = new(1);
     this.mon2scb = new(1);
     // open txt file to write tb outputs
     this.fd = $fopen("./report/phase9_out.txt","w");
     // create generator instance
     this.gen = new(num_cases,test2gen,gen2driv);
     this.driv = new(num_cases,vif,gen2driv,driv2mon,fd);
     this.mon = new(num_cases,vif,driv2mon,mon2scb,fd);
     this.scb = new(num_cases,mon2scb,fd);
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
        scb.main();
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
     $finish;
   endtask


endclass

`endif