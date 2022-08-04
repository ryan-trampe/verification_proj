`ifndef _GENERATOR_
`define _GENERATOR_

class generator;
    // declare variables
    transaction trans;
    int repeat_count;

    mailbox gen2driv;

    function new(mailbox gen2driv);
        this.gen2driv = gen2driv;
    endfunction

    task main();
        repeat (repeat_count) begin
            trans = new();
            trans.addr_in       = $random();
            trans.data_in       = $random();
            trans.wr_en         = $random();
            trans.rd_en         = $random();
            trans.port_sel      = $random();
            trans.port_en       = $random();
            trans.port_wr       = $random();
            trans.port_addr     = $random();
            trans.port_sel      = $random();
            trans.prio_wr       = $random();
            trans.prio_val      = $random();
            trans.display_inputs("[Generator]");
            gen2driv.put(trans);
        end
    endtask


endclass
`endif