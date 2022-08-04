module dut_top(intf port);

   xswitch xswitch_core(
      // source ports
      .addr_in(port.addr_in),
      .data_in(port.data_in),
      .wr_en(port.wr_en),
      .data_rcv(port.data_rcv),
      // desitination ports
      .addr_out(port.addr_out),
      .data_out(port.data_out),
      .rd_en(port.rd_en),
      .data_rdy(port.data_rdy),
      // fifo ports
      .fifo_ae(port.fifo_ae),
      .fifo_empty(port.fifo_empty),
      .fifo_full(port.fifo_full),
      .fifo_af(port.fifo_af),
      // prio and port sel ports
      .prio_wr(port.prio_wr),
      .prio_val(port.prio_val),
      .port_en(port.port_en),
      .port_wr(port.port_wr),
      .port_sel(port.port_sel),
      .port_addr(port.port_addr),
      // control ports
      .clk(port.clk),
      .reset(port.driv_reset)
   );

   initial begin
      xswitch_core.student_no = 11254939;
      xswitch_core.enable_dut_bugs();
   end

endmodule