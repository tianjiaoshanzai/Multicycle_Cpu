`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:24:18
// Design Name: 
// Module Name: alu
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
module alu (A, B, ALUOp, C, Zero);
           
   input  [31:0] A, B;
   input  [3:0]  ALUOp;
   output [31:0] C;
   output        Zero;
   
   reg [31:0] C;
       
   always @( A or B or ALUOp ) begin
      case ( ALUOp )
         `ALUOp_ADDU: 	C = A + B;
         `ALUOp_SUBU: 	C = A - B;
         `ALUOp_AND:   	C = A&B;
         `ALUOp_OR:   	C = A | B;
         `ALUOp_XOR:   	C = A^ B;
         `ALUOp_NOR:   	C = ~(A| B);
          default:   ;
      endcase
   end // end always;
   
   assign Zero = (A == B) ? 1 : 0;

endmodule    

