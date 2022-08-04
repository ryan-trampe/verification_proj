`include "phase9_interface.sv"
`include "phase9_transaction.sv"
`include "phase9_testbench.sv"
`include "phase9_generator.sv"
`include "phase9_driver.sv"
`include "phase9_environment.sv"
`include "xswitch_test_pkg.sv"
`include "phase9_data_fifo.sv"
`include "phase9_scoreboard.sv"
`include "phase9_coverage.sv"


module tbench_top();
   bit clk;
   bit reset;
   always #5 clk = ~clk;
   // reset generation
   initial begin
      reset = 1;
      #6 reset = 0;
   end

   // clocked interface
   intf i_intf(clk,reset);

   // dut wrapper
   dut_top dut(i_intf.dut_port);
   // initial begin
   //    dut.student_no =11254939;
   //    dut.enable_dut_bugs();
   // end

   // testbench program
   testbench test(i_intf);

   initial begin
      $dumpfile("dump.vcd");
      $dumpvars;
   end


endmodule