module Reg #(parameter width = 32)//Pipelined registers
   (input clk,reset,den,
    input [width-1 : 0]     dIn,
    output reg [width-1 :0] dOut);
   always @(posedge clk )
     begin
        if(reset==1'b0)
          dOut <= 0;
        else
          if(!den)
            dOut <= dIn;
     end
endmodule // Reg