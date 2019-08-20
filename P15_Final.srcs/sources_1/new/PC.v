`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:26:06
// Design Name: 
// Module Name: PC
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


module PC( clk, rst, PCWr, NPC, PC );
           
   input         clk;
   input         rst;
   input         PCWr;
   input  [31:2] NPC;
   output [31:2] PC;
   
   reg [31:2] PC;
   reg [1:0] tmp;
               
   always @(posedge clk or posedge rst) begin
      if ( rst ) 
         {PC, tmp} <= 32'h0000_3000;   
      else if ( PCWr ) 
         PC <= NPC;
   end // end always
           
endmodule

