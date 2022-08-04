`include "phase6_interface.sv"
`include "phase6_transaction.sv"
`include "phase6_testbench.sv"
`include "phase6_generator.sv"
`include "phase6_driver.sv"
`include "phase6_environment.sv"

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