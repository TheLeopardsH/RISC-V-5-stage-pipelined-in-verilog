module mux4 #(parameter width = 32)
   (input [width-1:0] d0,d1,d2,d3,
    input [1:0]        sel,
    output [width-1:0] y);
   assign y = sel[1] ? (sel[0] ? d3 : d2) : (sel[0] ? d1 : d0);
endmodule // mux
module mux2 #(parameter width = 32)
   (input [width-1:0] d0,d1,
    input              sel,
    output [width-1:0] y);
   assign y = sel ? d1 : d0;
endmodule // mux2