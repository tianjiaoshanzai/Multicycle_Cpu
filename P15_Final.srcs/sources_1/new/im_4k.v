`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:30:40
// Design Name: 
// Module Name: im_4k
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


module im_4k( rst, addr, dout );
    input rst;
    input [11:2] addr;
    output [31:0] dout;
        
    reg [31:0] imem[1023:0];
    
    /*always @(posedge rst)
    if(rst)
    begin
        imem[0]=32'h00000026;
    imem[1]=32'h24021234;
    imem[2]=32'h30433456;
    imem[3]=32'h00432021;
    imem[4]=32'h00622823;
    imem[5]=32'hac020000;
    imem[6]=32'hac030004;
    imem[7]=32'hac040008;
    imem[8]=32'hac050010;
    imem[9]=32'h341d000c;
    imem[10]=32'h38416543;
    imem[11]=32'h00230824;
    imem[12]=32'h00240825;
    imem[13]=32'hac01000c;
    imem[14]=32'h8c050000;
    imem[15]=32'h10450001;
    imem[16]=32'h8c030004;
    imem[17]=32'h8c050004;
    imem[18]=32'h1465fffd;
    imem[19]=32'h0c000c15;
    imem[20]=32'hac02000c;
    imem[21]=32'h00a23023;
    imem[22]=32'hafa6fffc;
    imem[23]=32'h08000c19;
    imem[24]=32'hac02000c;
    imem[25]=32'h1464ffff;
    end
    */
    assign dout = imem[addr];
endmodule
