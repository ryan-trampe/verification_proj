`include "phase3_data_fifo.sv"
program test_fifo;

   data_fifo data_fifo;
   bit [15:0] data;

   initial begin
      data_fifo = new();
      $display("inputs");
      repeat(256) begin
         data = $random();
         $display("Data: %h",data);
         data_fifo.push(data);
      end
      $display("Queue Size: %d",data_fifo.size());
   end

endprogram : test_fifo