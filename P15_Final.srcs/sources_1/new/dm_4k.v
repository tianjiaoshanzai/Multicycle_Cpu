`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:29:48
// Design Name: 
// Module Name: dm_4k
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


module dm_4k( addr, din, DMWr, clk, dout );
   
   input  [11:2] addr;
   input  [31:0] din;
   input         DMWr;//数据存储器写使能信号
   input         clk;
   output [31:0] dout;
     
   reg [31:0] dmem[1023:0];
   
   always @(posedge clk) begin
      if (DMWr)
         dmem[addr] <= din;
   end // end always
   
   assign dout = dmem[addr];
    
endmodule
