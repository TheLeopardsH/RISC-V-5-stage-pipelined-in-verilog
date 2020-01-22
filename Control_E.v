`include"defination.v"


module Control_ID(input [31:0] instr,//basically this module is for signed extension selections
                 
                  output reg PCsel,
                  
                  output reg [1:0] extOp);//ext tells which immediate to choose signed or unsigned
                    
 always @(*)
   begin
        PCsel <= 1'b0;
 //handle extOp
//checkif following are true for signed extension
//on cheatsheet it is written immediate fields are sign extented
//confusion in ALU I am also taking signed operations whats their meaning may be nothing to notice
//what about 'a' if we put the number in a what about it does compiler would  put sign extension or not just check
        if(`LB  || `LH || `LW || `ADDI || `SLTI || `XORI ||`ORI || `ANDI ||`SLLI || `SRLI || `SRAI )
          extOp <= 2'b01;
			else if (`SB || `SH || `SW)
			  extOp <=2'b11;
        else
          extOp <= 2'b00;

     end // always @ (*)
endmodule // ConTrol_ID

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//Also b selection is from here also
module Control_E(input [31:0] instr,
                 output reg [3:0] ALUOp,
                 output reg  BSel);

always @(*)
 begin
//handle ALUOp
       if(`SUB)
        ALUOp = 4'b00_01;
      else if(`AND || `ANDI)
        ALUOp = 4'b01_00;
      else if(`OR || `ORI)
        ALUOp = 4'b01_01;
      else if(`XOR || `XORI)
        ALUOp = 4'b01_10;
      else if(`SLL || `SLLI)
        ALUOp = 4'b10_00;
      else if(`SRL || `SRLI)
        ALUOp = 4'b10_10;
      else if(`SRA || `SRAI)
        ALUOp = 4'b10_11;
      else if(`SLT || `SLTI)
        ALUOp = 4'b11_00;
      else if(`SLTU || `SLTIU)
        ALUOp = 4'b11_01;
      else //others use add
        ALUOp = 4'b00_00;

if(`LB || `LBU || `LH || `LHU || `LW ||`ADDI || `ANDI || `ORI || `XORI || `SLTI || `SLTIU || `SLLI || `SRLI || `SRAI ||`SB || `SH || `SW) 
        BSel = 1'b1;
		  
else    
        BSel = 1'b0;//for selecting b register

   end
endmodule // Control_IE

//Memory write for store instructions based on byte or half word or word level store
//check how store instruction works otherwise destination can go wrong
module Control_M(input [31:0] instr,
                 output reg memWr,
                 output reg [1:0] BEextOp);
   always @(*)
             begin
   if(`SB || `SH || `SW)
     memWr = 1;
   else
     memWr = 0;

   if(`SH)
     BEextOp = 2'b10;
   else if(`SB)
     BEextOp = 2'b11;
   else
     BEextOp = 2'b00;
             end 
   
endmodule // Control_M

//for writing to mem
module Control_W(input [31:0] instr,
                 output reg  WRSel,
                 output reg  WDSel,
                 output reg       regWr,
                 output reg [2:0] WBextOp);
   always @(*)
                begin
                if(`LBU)
                  WBextOp = 3'b001;
                else if(`LB)
                  WBextOp = 3'b010;
                else if(`LHU)
                  WBextOp = 3'b011;
                else if(`LH)
                  WBextOp = 3'b100;
                else
                  WBextOp = 3'b000;

                   if(`ADD  || `SUB  || `SLT || `SLTU || `SLL || `SRL || `SRA || `AND || `OR || `XOR) //r-r cal and MF
                               begin
                                  regWr <= 1'b1;
                                  WRSel <= 1'b0;//RD
                                  WDSel <= 1'b0;//ALU
                               end
                             else if(`LB || `LBU || `LH || `LHU || `LW) //load
                             begin
                                regWr <= 1'b1;
                                WRSel <= 1'b0;//RD
                                WDSel <= 1'b1; //rdata
                             end
                           else if(`ADDI  || `ANDI || `ORI || `XORI || `SLTI || `SLTIU) //r-i cal
                             begin
                                regWr <= 1'b1;
                                WRSel <= 1'b0;//
                                WDSel <= 1'b0;//ALU
                             end
                           else //default maybe for Store instructions msitake here
                             begin
                                regWr <= 1'b0;
                                WRSel <= 1'b0;//********* converted from 1 to 0 as i think RD is always this
                                WDSel <= 1'b0;
                             end // 
                end // always @ begin
   
   endmodule // Control_W
