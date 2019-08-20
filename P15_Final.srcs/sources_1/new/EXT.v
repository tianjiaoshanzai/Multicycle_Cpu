`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:36:04
// Design Name: 
// Module Name: EXT
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


`include "ctrl_encode_def.v"
module EXT( Imm16, EXTOp, Imm32 );
    
   input  [15:0] Imm16;
   input  [1:0]  EXTOp;
   output [31:0] Imm32;
   
   reg [31:0] Imm32;
    
   always @(*) begin
      case (EXTOp)
         `EXT_ZERO:    Imm32 = {16'd0, Imm16};
         `EXT_SIGNED:  Imm32 = {{16{Imm16[15]}}, Imm16};
         `EXT_HIGHPOS: Imm32 = {Imm16, 16'd0};
         default: ;
      endcase
   end // end always
    
endmodule