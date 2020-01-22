`define RD 11:7
`define RS1 19:15 
`define RS2 24:20
`define OP 6:2
`define OP1 6:0
`define FUNT3 14:12
`define FUNT7 30
`define FUNT2 26:25
`define FUNT5 31:26
`define shift 24:20 
//load and store(comes in I format) 
`define LB (instr[`OP1]==5'b0000011 && instr[`FUNT3]==3'b000 )
`define LH (instr[`OP1]==5'b0000011 && instr[`FUNT3]==3'b001 )
`define LW (instr[`OP1]==5'b0000011 && instr[`FUNT3]==3'b010 )
`define LBU (instr[`OP1]==5'b0000011 && instr[`FUNT3]==3'b100 )
`define LHU (instr[`OP1]==5'b0000011 && instr[`FUNT3]==3'b101 )
//TYPE S
`define SB (instr[`OP]==5'b01000 && instr[`FUNT3]==3'b000 )
`define SH (instr[`OP]==5'b01000 && instr[`FUNT3]==3'b001 )
`define SW (instr[`OP]==5'b01000 && instr[`FUNT3]==3'b010 )
//R-R register to register  instructions(R FORMAT)
`define ADD (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b000 && instr[`FUNT7]==0&& instr[`FUNT2]==2'b00)
`define SUB (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b000 && instr[`FUNT7]==1&& instr[`FUNT2]==2'b00)
`define SLL (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b001&& instr[`FUNT2]==2'b00)
`define SLT (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b010&& instr[`FUNT2]==2'b00)
`define SLTU (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b011&& instr[`FUNT2]==2'b00)
`define XOR (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b100&& instr[`FUNT2]==2'b00)
`define SRL (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b101&& instr[`FUNT7]==0&& instr[`FUNT2]==2'b00)
`define SRA (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b101&& instr[`FUNT7]==1&& instr[`FUNT2]==2'b00)
`define OR (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b110&& instr[`FUNT2]==2'b00)
`define AND (instr[`OP]==5'b01100 && instr[`FUNT3]==3'b110&& instr[`FUNT2]==2'b00)

//R-I register to immediate

`define ADDI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b000)
`define SLTI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b010)
`define SLTIU (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b011)
`define XORI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b100)
`define ORI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b110)
`define ANDI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b111)
`define SLLI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b001)
`define SRLI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b101&& instr[`FUNT7]==0)
`define SRAI (instr[`OP]==5'b00100 && instr[`FUNT3]==3'b101&& instr[`FUNT7]==1)