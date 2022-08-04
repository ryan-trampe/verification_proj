`ifndef _FIFO_
`define _FIFO_

// Queue wrapper
class data_fifo;
   // bounded queue of data
   bit [15:0] data [$:255];

   function bit [15:0] peek();
      if (data.size() == 0) begin
         return 16'h0;
      end else begin
         bit [15:0] temp = data.pop_front();
         data.push_front(temp);
         return temp;
      end
   endfunction

   function bit [15:0] pop();
      if (data.size() == 0)
         return 16'h0;
      return data.pop_front();
   endfunction

   function void push(bit [15:0] temp);
      data.push_back(temp);
   endfunction

   function int size();
      return data.size();
   endfunction

   function void display_data(string detail);
      $displayh("%s: %p",detail, data);
   endfunction

   function void fdisplay_data(string detail, int fd);
      $fdisplayh(fd,"%s: %p",detail, data);
   endfunction

   function void reset_queue();
      data.delete();
   endfunction

endclass
`endif