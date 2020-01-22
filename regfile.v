module regfile (rna,rnb,d,wn,we,clk,clrn,qa,qb); // 32x32 regfile 
input [31:0] d; // data of write port 
input [4:0] rna; // reg # of read port A 
input [4:0] rnb; // reg # of read port B 
input [4:0] wn; // reg # of write port 
input we; // write enable 
input clk, clrn; // clock and reset
output [31:0] qa, qb; // read ports A and B
 reg [31:0] register [1:31]; // 31 32-bit registers
 assign qa = (rna == 0)? 0 : register[rna]; // read port A 
 assign qb = (rnb == 0)? 0 : register[rnb]; // read port B 
 integer i; 
 always @(posedge clk or negedge clrn) // write port
 if (clrn==1'b0) 
     for (i = 1; i < 32; i = i + 1)
	   register[i] <= 0; // reset 
 else 
if ((wn != 0) && we) // not reg[0] & enabled 
	 register[wn] <= d; // write d to reg[wn] 
		  endmodule
 
 