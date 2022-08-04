`include "phase5_environment.sv"
program testbench(intf i_intf);

    environment env;

    initial begin
        env = new(5,i_intf);
        $display("[Testbench]: Start of testcase(s) at %0d",$time);
        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d",$time);



endprogram