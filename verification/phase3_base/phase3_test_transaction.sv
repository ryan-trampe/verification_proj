`include "phase3_transaction.sv"
program test_transaction;

transaction trans;

initial begin
    trans = new();
    repeat(5) begin
        trans.addr_in = $random();
        trans.data_in = $random();
        trans.wr_en = $random();
        trans.data_rcv = $random();

        trans.addr_out = $random();
        trans.data_out = $random();
        trans.rd_en  = $random();
        trans.data_rdy = $random();

        trans.fifo_ae = $random();
        trans.fifo_empty = $random();
        trans.fifo_full = $random();
        trans.fifo_af = $random();

        trans.prio_wr = $random();
        trans.prio_val = $random();

        trans.port_en = $random();
        trans.port_wr = $random();
        trans.port_sel = $random();
        trans.port_addr = $random();


        trans.display_inputs("[Transaction Test]");
        trans.display_output("[Transaction Test]");
    end
end

endprogram : test_transaction