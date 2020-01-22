`include "defination.v"
module StallUnit(input reset,
                 input [31:0] instr_D,instr_E,instr_M,
                 output reg stall);
//FOR MEMORY STORE WE ALWAYS HAVE RS2 DESTINATION
always @ (*)
     begin 
   if(reset==1'b0)	
	  stall<=1'b0;
	else if(load(instr_E))
          begin
            if(cal_r(instr_D) && instr_E[`RD] == instr_D[`RS2])
               stall <= 1'b1;//**correct
            else if((cal_r(instr_D) || cal_i(instr_D) || load(instr_D) || store(instr_D))  && instr_E[`RD] == instr_D[`RS1])
               stall <= 1'b1;//**wrong making everything wrong
            else 
               stall <= 1'b0;
          end // if (load(instr_E))
     else if(cal_i(instr_E)) //cal_i_E
              stall <= 1'b0;     
     else if(cal_r(instr_E) && instr_E[`RD] != 5'b0 ) 
              stall <= 1'b0;
     else if(load(instr_M))
              stall <= 1'b0;
     else 
           stall <= 1'b0;
     end // always @ begin

function load;
   input [31:0] instr ;
    load =  (`LB || `LBU || `LH || `LHU || `LW);
endfunction // StallUnit

function cal_r;//include sll srl sra 
   input [31:0] instr;
    cal_r = (`ADD  || `SUB  || `SLT || `SLTU || `SLL || `SRL || `SRA ||  `AND || `OR || `XOR);
endfunction // StallUnit

function cal_i;
   input [31:0] instr;
    cal_i = (`ADDI  || `ORI || `XORI || `SLTI || `SLTIU || `SLLI||`SRLI||`SRAI||`ANDI);
endfunction // StallUnit

function store;
   input [31:0] instr;
    store = (`SB || `SH || `SW);
endfunction // StallUnit
   
endmodule // StallUnit



module HazardUnit(input [31:0] instr_D,instr_E,instr_M,instr_W,
                  output reg [1:0] FowardRS1E,FowardRS2E,//RSD=DECODING INSTRUCTION NEED OF RS1 SO FORWARD AND ALSO SAMEFOR OTHERS
                  output reg       FowardRDM);
   

	


   always @(*) //for Foward RS1E
//between memory and execute for rs1
   //if(cal_r(instr_E) || cal_i(instr_E) || load(instr_E) || store(instr_E) || )//cal_i cal_r lw sw E
      
     if((cal_r(instr_M) && instr_M[`RD] != 5'b0) && instr_M[`RD] == instr_E[`RS1]) //cal_r M   **RS2 to RD
       FowardRS1E <= 2'b01;
     else if(cal_i(instr_M) && instr_M[`RD] == instr_E[`RS1]) //cal_i M
       FowardRS1E <= 2'b01;
     else if((cal_r(instr_W) && instr_W[`RD] != 5'b0) && instr_W[`RD] == instr_E[`RS1]) //cal_r W
       FowardRS1E <= 2'b11;
     else if(cal_i(instr_W) && instr_W[`RD] == instr_E[`RS1]) //cal_i W
       FowardRS1E <= 2'b11;
     else if(load(instr_W) && instr_W[`RD] == instr_E[`RS1]) //load W****IMP FOR LOAD 
       FowardRS1E <= 2'b11;
     else
       FowardRS1E <= 2'b00;
   

   always @(*) //for Foward RS2E
//between memory/WRITE TO REGISTER and execute for for RS2
                                                         //if(cal_r(instr_E) || store(instr_E)   //cal_i sw E
     if((cal_r(instr_M) && instr_M[`RD] != 5'b0) && instr_M[`RD] == instr_E[`RS2]) //cal_r M
       FowardRS2E <= 2'b01;
     else if(cal_i(instr_M) && instr_M[`RD] == instr_E[`RS2]) //cal_i M
       FowardRS2E <= 2'b01;
     else if((cal_r(instr_W) && instr_W[`RD] != 5'b0 ) && instr_W[`RD] == instr_E[`RS2]) //cal_r W
       FowardRS2E <= 2'b11;
     else if(cal_i(instr_W) && instr_W[`RD] == instr_E[`RS2]) //cal_i W
       FowardRS2E <= 2'b11;
     else if(load(instr_W) && instr_W[`RD] == instr_E[`RS2]) //load W
       FowardRS2E <= 2'b11;
     else
       FowardRS2E <= 2'b00;
   
   always @(*) //for Foward RDM
//BETWEEN MEMORY AND WRITE TO REGISTER
                                                         //if(store(instr_M)) //sw M
     if((cal_r(instr_W) && instr_W[`RD] != 5'b0 ) && instr_W[`RD] == instr_M[`RS2]) //cal_r W
       FowardRDM <= 1'b1;
     else if((cal_i(instr_W) || load(instr_W)) && instr_W[`RD] == instr_M[`RS2]) //cal_i W
       FowardRDM <= 1'b1;
     else
       FowardRDM <= 1'b0;

function load;
   input [31:0] instr;
    load = (`LB || `LBU || `LH || `LHU || `LW);
endfunction // StallUnit

function cal_r;//include sll srl sra 
   input [31:0] instr;
  cal_r = (`ADD  || `SUB  || `SLT || `SLTU || `SLL || `SRL || `SRA ||  `AND || `OR || `XOR);
endfunction // StallUnit

function cal_i;
   input [31:0] instr;
    cal_i = (`ADDI  || `ORI || `XORI || `SLTI || `SLTIU||`SLLI||`SRLI||`SRAI||`ANDI);
endfunction // StallUnit

function store;
   input [31:0] instr;
    store = (`SB || `SH || `SW);
endfunction // StallUnit
	
endmodule // HazardUnit
