program testbench(intf i_intf);

    initial begin
        $display("[Testbench]: Start of testcase(s) at %0d",$time);
    end

    final
        $display("[Testbench]: End of testcase(s) at %0d",$time);



endprogram