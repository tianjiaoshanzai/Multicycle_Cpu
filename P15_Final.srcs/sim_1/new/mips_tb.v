`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:52:20
// Design Name£¬£¬// Module Name: mips_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mips_tb();
  
   reg clk, rst;
   wire [31:0] pc,ir;
   
   mips U_MIPS(
      .clk(clk), .rst(rst), .mips_pc(pc),.mips_ir(ir)
   );
   always #(50) clk = ~clk;
   initial
   begin
      $readmemh( "code.hex" , U_MIPS.U_IM.imem );
      $monitor( "PC = 0x%8X, IR = 0x%8X , ALUOut = 0x%8X", U_MIPS.U_PC.PC, U_MIPS.instr,U_MIPS.U_ALU.C );
      clk = 1 ;
      rst = 0 ;
      #5 ;
      rst = 1 ;
      #20 ;
      rst = 0 ;
   end   
endmodule

