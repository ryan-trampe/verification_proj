`include "phase4_environment.sv"
program testbench(intf i_intf);

    environment env;

    initial begin
        env = new(i_intf);

        env.gen.repeat_count = 5;
        $display("[Testbench]: Start of testcase(s) at %0d",$time);
        env.run();
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d",$time);



endprogram