`include "phase8_interface.sv"
`include "phase8_transaction.sv"
`include "phase8_testbench.sv"
`include "phase8_generator.sv"
`include "phase8_driver.sv"
`include "phase8_environment.sv"
`include "testcases.sv"
`include "phase8_data_fifo.sv"
`include "phase8_scoreboard.sv"
`include "phase8_coverage.sv"

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

    // testbench program
    testbench test(i_intf);

    // dut wrapper
    dut_top dut(i_intf.dut_port);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end




endmodule