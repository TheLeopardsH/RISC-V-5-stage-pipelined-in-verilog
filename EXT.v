

module EXT(input [31:0] immIn,
           input [1:0] ExtOp,
           output reg [31:0] immOut);//**need to change in pipeline immediate
   always @(ExtOp or immIn)
	begin
	if (ExtOp==2'b11)
       immOut <={{20{immIn[31]}},immIn[31:25],immIn[11:7]};
	else if(ExtOp==2'b01)
       immOut <= {{20{immIn[31]}},immIn[31:20]};
   else
       immOut <= {20'b0,immIn[31:20]};
	end
   
endmodule // ext