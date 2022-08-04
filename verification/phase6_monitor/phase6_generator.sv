`ifndef _GENERATOR_
`define _GENERATOR_

class generator;
    // declare variables
    transaction trans;
    int repeat_count;
    // mailbox to go to driver
    mailbox gen2driv;

    function new(int repeat_count,mailbox gen2driv);
        this.repeat_count = repeat_count;
        this.gen2driv = gen2driv;
    endfunction

    task main();
        // repeat (repeat_count) begin
        //     trans = new();
        //     trans.addr_in       = $random();
        //     trans.data_in       = $random();
        //     trans.wr_en         = $random();
        //     trans.rd_en         = $random();
        //     trans.port_sel      = $random();
        //     trans.port_en       = $random();
        //     trans.port_wr       = $random();
        //     trans.port_addr     = $random();
        //     trans.port_sel      = $random();
        //     trans.prio_wr       = $random();
        //     trans.prio_val      = $random();
        //     // trans.display_inputs("[Generator]");
        //     gen2driv.put(trans);
        // end

        trans = new();
        trans.port_en = 1'b1;
        trans.port_wr = 1'b1;
        trans.port_sel = 2'd0;
        trans.port_addr = 16'h0;
        trans.prio_wr = 1'b1;
        trans.prio_val = 8'h00;
        gen2driv.put(trans);

        trans = new();
        trans.port_en = 1'b1;
        trans.port_wr = 1'b1;
        trans.port_sel = 2'd1;
        trans.port_addr = 16'h1111;
        trans.prio_wr = 1'b1;
        trans.prio_val = 8'h11;
        gen2driv.put(trans);

        trans = new();
        trans.port_en = 1'b1;
        trans.port_wr = 1'b1;
        trans.port_sel = 2'd2;
        trans.port_addr = 16'h2222;
        trans.prio_wr = 1'b1;
        trans.prio_val = 8'h22;
        gen2driv.put(trans);

        trans = new();
        trans.port_en = 1'b1;
        trans.port_wr = 1'b1;
        trans.port_sel = 2'd3;
        trans.port_addr = 16'h3333;
        trans.prio_wr = 1'b1;
        trans.prio_val = 8'h33;
        gen2driv.put(trans);

        // make 4 random assignments
        trans = new();
        trans.addr_in = 64'h0000111122223333;
        trans.data_in = $random();
        trans.wr_en = 4'hf;
        gen2driv.put(trans);

        trans = new();
        trans.addr_in = 64'h0000111122223333;
        trans.data_in = $random();
        trans.wr_en = 4'hf;
        gen2driv.put(trans);

        trans = new();
        trans.addr_in = 64'h0000111122223333;
        trans.data_in = $random();
        trans.wr_en = 4'hf;
        gen2driv.put(trans);

        trans = new();
        trans.addr_in = 64'h0000111122223333;
        trans.data_in = $random();
        trans.wr_en = 4'hf;
        gen2driv.put(trans);

        // Read each assignment
        trans = new();
        trans.rd_en = 4'hf;
        gen2driv.put(trans);
        trans = new();
        trans.rd_en = 4'hf;
        gen2driv.put(trans);
        trans = new();
        trans.rd_en = 4'hf;
        gen2driv.put(trans);
        trans = new();
        trans.rd_en = 4'hf;
        gen2driv.put(trans);
        trans = new();
        trans.rd_en = 4'hf;
        gen2driv.put(trans);
    endtask


endclass
`endif