
`timescale 1ns / 1ns
module tbriscv  ; 
 
  reg    rst_n   ; 
  reg    clk   ; 
  riscv_top  DUT  ( 
       .rst_n (rst_n ) ,
       .clk (clk ) 
		            ); 




  initial
  begin
	  clk  = 1'b0  ;
	 # 50 ;

   repeat(79)
   begin
	   clk  = 1'b1  ;
	  #50  clk  = 1'b0  ;
	  #50 ;

   end
	  clk  = 1'b1  ;
	 # 50 ;
// dumped values till 2 us
  end


// "Constant Pattern"
// Start Time = 0 ns, End Time = 2 us, Period = 0 ns
  initial
  begin
	  rst_n  = 1'b0  ;
	  #100;
	  rst_n  = 1'b1 ;
	 # 9000 ;
// dumped values till 2 us
  end

  initial
	#10000 $stop;
endmodule
