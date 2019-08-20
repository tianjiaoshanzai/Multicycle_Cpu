`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:40:18
// Design Name: 
// Module Name: RF
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


module RF( A1, A2, A3, WD, clk, RFWr, RD1, RD2);
    
   input  [4:0]  A1, A2, A3;
   input  [31:0] WD;
   input         clk;
   input         RFWr;
   output [31:0] RD1, RD2;
   
   reg [31:0] rf[31:0];
 
   always @(posedge clk) 
     if (RFWr)  rf[A3] <= WD;
     
   assign RD1 = (A1 == 0) ? 32'd0 : rf[A1];
   assign RD2 = (A2 == 0) ? 32'd0 : rf[A2];   
endmodule 
