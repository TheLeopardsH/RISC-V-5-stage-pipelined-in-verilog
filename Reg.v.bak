module Reg #(parameter width = 32)
   (input clk,reset,den,
    input [width-1 : 0]     dIn,
    output reg [width-1 :0] dOut);
   always @(posedge clk )
     begin
        if(reset)
          dOut <= 0;
        elses
          if(!den)
            dOut <= dIn;
     end
endmodule // Reg