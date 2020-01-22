`define Fi 7:0//first byte
`define Se 15:8//second byte
`define Th 23:16//third byte
`define Fo 31:24//fourth byte
`define FH 15:0//first half byte
`define SH1 31:16//seconfd half byte
module ram #(parameter N1=7,N = 8,M = 32)
   (input clk,clrn,we,
    input [N-1:0]  adr,
    input [3:0]    BE,
    input [M-1:0]  din,
    output [M-1:0] dout);
   reg [M-1:0]     dmem[2**N1-1:0];
   
   assign dout = dmem[adr];
   integer i;
   always@(posedge clk or negedge clrn)
     begin
	  if (clrn==1'b0) 
     for (i = 0; i < 128; i = i + 1)
	   dmem[i] <= 0; // reset 
    else 
        if(we)
          case(BE)
            4'b0001: dmem[adr] = {dout[`SH1],dout[`Se],din[`Fi]};
            4'b0010: dmem[adr] = {dout[`SH1],din[`Fi],dout[`Fi]};
            4'b0100: dmem[adr] = {dout[`Fo],din[`Fi],dout[`FH]};
            4'b1000:dmem[adr] = {din[`Fi],dout[`Th],dout[`FH]};
            4'b0011:dmem[adr] = {dout[`SH1],din[`FH]};
            4'b1100:dmem[adr] = {din[`FH],dout[`FH]};
            4'b1111: dmem[adr] = din;
          endcase // case (BE)
   	$display("dmem[%8X]=%8X",adr<<2,dout);
     end 
endmodule // ram

module BEext(input [1:0] addr,
             input [1:0]      BEextOp,
             output reg [3:0] BE);
   always @(*)
      if(BEextOp == 2'b10) //sh
       casez(addr)
         2'b0?: BE = 4'b0011;
         2'b1?: BE = 4'b1100;
       endcase // case (addr)
      else if(BEextOp == 2'b11) //sb
        case(addr)
          2'b00: BE = 4'b0001;
          2'b01: BE = 4'b0010;
          2'b10: BE = 4'b0100;
          2'b11: BE = 4'b1000;
          endcase
      else //sw
             BE = 4'b1111;
endmodule // BEext

module WBext(input [1:0] addr,
             input [31:0]      din,
             input [2:0]       WBextOp,
             output reg [31:0] dout);
   always @(*)
                  if(WBextOp == 3'b001)//unsigned byte
                    case(addr)
                      2'b00: dout = {24'b0,din[`Fi]};
                      2'b01: dout = {24'b0,din[`Se]};
                      2'b10: dout = {24'b0,din[`Th]};
                      2'b11: dout = {24'b0,din[`Fo]};
                    endcase // case (addr)
                  else if(WBextOp == 3'b010)//signed byte
                    case(addr)
                      2'b00: dout = {{24{din[7]}},din[`Fi]};
                      2'b01: dout = {{24{din[15]}},din[`Se]};
                      2'b10: dout = {{24{din[23]}},din[`Th]};
                      2'b11: dout = {{24{din[31]}},din[`Fo]};
                    endcase // case (addr)
                  else if(WBextOp == 3'b011) //unsigned half
                    casez(addr)
                      2'b0?: dout = {16'b0,din[`FH]};
                      2'b1?: dout = {16'b0,din[`SH1]};
                    endcase // casez (addr)
                  else if(WBextOp == 3'b100) //signed half
                    casez(addr)
                      2'b0?: dout = {{16{din[15]}},din[`FH]};
                      2'b1?: dout = {{16{din[31]}},din[`SH1]};
                    endcase // casez (addr)
                  else //no ext
                    dout = din;
endmodule // WBext



