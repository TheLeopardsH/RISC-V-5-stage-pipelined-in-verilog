module rom #(parameter N=7,M = 32)
   (input [6:0] addr,
    output [M-1:0] dout);
   reg [M-1:0]     imem [2**N-1:0];
	initial
	begin
	   $readmemb("C:/intelFPGA_lite/quartusprojects/riscv_top2/insmem.txt",imem,0,74);
		end
   assign dout = imem[addr];
endmodule // rom