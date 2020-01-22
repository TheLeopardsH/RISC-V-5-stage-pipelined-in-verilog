
module ALU(input [31:0] a,b,
           input [3:0] ALUop,
           output reg[31:0] ALUOut,
           output reg over);// 0 indicate no overflow
always @(*)
      begin 
           case (ALUop)
              4'b00_00: ALUOut=a+b;
              4'b00_01: ALUOut=a-b;
              4'b01_00: ALUOut=a&b;
              4'b01_01: ALUOut=a|b;
              4'b01_10: ALUOut=a^b;
              4'b10_00: ALUOut=a<<b[4:0];//left shift logical
              4'b10_10: ALUOut=a>>b[4:0];//right shift logical
              4'b10_11: ALUOut=$signed(a)>>>$signed(b[4:0]);//arithmetic right shift
              4'b11_00: ALUOut=$signed(a) < $signed(b)? 32'b1:32'b0;//set less than
              4'b11_01: ALUOut=a < b ? 32'b1:32'b0;//set less than unsigned
               endcase 
              over<=0;
        end
endmodule
