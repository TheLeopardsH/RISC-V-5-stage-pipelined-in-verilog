`include"defination.v"
`timescale 1us / 1ns


module riscv_top ( 
 input clk,   // clock 
 input rst_n  // active low asynchronous rst_n 
); 

	 wire WRSel,WDSel;
	 wire [31:0] WBextOut;
	 wire [2:0]       WBextOp;
	 wire [3:0]    BE;
	 wire regWr,PCSel,BSel,memWr;
	 wire [1:0] extOp,BEextOp;
	 wire [3:0] ALUOp;
	 wire overflow;
	 wire [31:0] instr,pc,next_pc,pc4_D,RD1,pc8_M,pc8_E,pc8_W,RS1_E,RS2_E,RS2_M,ALUOut,RD2;
	 wire [31:0] instr_D,wDataReg_W,extOut,ext_E;
	 wire [31:0] instr_E,ALUrdB;
	 wire [31:0] instr_M,rData;
	 wire [31:0] instr_W,rData_W;
    wire [31:0] ALUOut_W;
	 wire [31:0] ALUOut_M;
	 //Foward Unit and stall
	wire [1:0] FowardRS1E,FowardRS2E; //foward signals
   wire        FowardRDM,stall;
   wire [31:0] FDRS1D,FDRS2D,FDRS1E,FDRS2E,FDRDM; //foward data
   //--------FUNCTION UNITS BEGIN HERE!-------------
   HazardUnit hazardUnit(instr_D,instr_E,instr_M,instr_W,
                         FowardRS1E,FowardRS2E,FowardRDM);
   StallUnit stallUnit(rst_n,instr_D,instr_E,instr_M,stall);
   //IF Unit
   PC pcReg(clk,rst_n,stall,next_pc,pc);
   rom inmem(pc[8:2],instr);
	  
   //IF_ID pipelineRegisters
   Reg        IR_DReg(clk,rst_n,stall,instr,instr_D); //IF_ID_den
   Reg        PC4_DReg(clk,rst_n,stall,pc+32'b100,pc4_D);//IF_ID_den
   //ID Unit
   mux2 MFRSD(RD1,ALUOut_M,1'b0,FDRS1D);
   mux2 MFRTD(RD2,ALUOut_M,1'b0,FDRS2D);
   regfile rf(instr_D[`RS1],instr_D[`RS2],wDataReg_W,instr_W[`RD],regWr,clk,rst_n,RD1,RD2);
   EXT ext(instr_D,extOp,extOut);//**
   mux2 M1(pc+32'b100,32'b0,PCSel,next_pc);
   Control_ID control_ID(instr_D,PCSel,extOp);//**
	
   //ID_EX pipelineRegisters
   Reg        IR_EReg(clk,(rst_n || stall),1'b0,instr_D,instr_E);//IR_E_Clear
   Reg        PC8_EReg(clk,rst_n,1'b0,pc4_D+32'b100,pc8_E);
   Reg        RS1_EReg(clk,rst_n,1'b0,FDRS1D,RS1_E);
   Reg        RS2_EReg(clk,rst_n,1'b0,FDRS2D,RS2_E);
   Reg        extReg(clk,rst_n,1'b0,extOut,ext_E);
   //EX Unit
   mux4 MFRSE(RS1_E,ALUOut_M,pc8_M,wDataReg_W,FowardRS1E,FDRS1E);
   mux4 MFRTE(RS2_E,ALUOut_M,pc8_M,wDataReg_W,FowardRS2E,FDRS2E);
    
   Control_E control_E(instr_E,ALUOp,BSel);
   mux2 aluSrcBMux(FDRS2E,ext_E,BSel,ALUrdB);
   ALU alu(FDRS1E,ALUrdB,ALUOp,ALUOut,overflow);
   //EX_MEM pipelineRegisters
   Reg        IR_MReg(clk,rst_n,1'b0,instr_E,instr_M); 
   Reg        PC8_MReg(clk,rst_n,1'b0,pc8_E,pc8_M);
   Reg        RS2_MReg(clk,rst_n,1'b0,FDRS2E,RS2_M);
   Reg        ALUOutReg_M(clk,rst_n,1'b0,ALUOut,ALUOut_M);
   
   
   //MEM Unit
   mux2 MFRTM(RS2_M,wDataReg_W,FowardRDM,FDRDM);
   Control_M control_M(instr_M,memWr,BEextOp);
   ram dmem(clk,rst_n,memWr,ALUOut_M[9:2],BE,FDRDM,rData);
   BEext beext(ALUOut_M[1:0],BEextOp,BE);
   

	 //MEM_WB pipelineRegisters
   Reg        IR_WReg(clk,rst_n,1'b0,instr_M,instr_W);
   Reg        PC8_WReg(clk,rst_n,1'b0,pc8_M,pc8_W);
   Reg        ALUOutReg_W(clk,rst_n,1'b0,ALUOut_M,ALUOut_W);
   Reg        rDataReg(clk,rst_n,1'b0,rData,rData_W);
   //WB Unit
   WBext wbext(ALUOut_W[1:0],rData_W,WBextOp,WBextOut);
   Control_W control_W(instr_W,WRSel,WDSel,regWr,WBextOp);
   mux2 wrDataRegMux(ALUOut_W,WBextOut,WDSel,wDataReg_W);
   
endmodule  


