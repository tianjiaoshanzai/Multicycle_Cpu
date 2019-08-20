`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:41:06
// Design Name: 
// Module Name: mips
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


module mips( clk, rst, mips_pc, mips_ir );
   input	clk;
   input	rst;
   output [31:0] mips_pc;//program counter
   output [31:0] mips_ir;//instruction register

   
   wire RFWr;
   wire DMWr;
   wire PCWr;
   wire	 IRWr;
   wire [1:0]  EXTOp;
   wire [3:0]  ALUOp;
   wire [1:0]  NPCOp;
   wire [1:0]  RF_A3_sel;
   wire [1:0]  RF_WD_sel;
   wire B_sel;
   wire Zero;
   wire [31:2] PC, NPC;
   wire [31:0] im_dout, dm_dout;
   wire [31:0] DR_dout;
   wire [31:0] instr;
   wire [4:0]  rs;
   wire [4:0]  rt;
   wire [4:0]  rd;
   wire [5:0]  Op;
   wire [5:0]  Funct;
   wire [15:0] Imm16; 
   wire [31:0] Imm32;
   wire [25:0] Imm26;
   wire [4:0]  A3;
   wire [31:0] WD;
   wire [31:0] RD1, RD1_r, RD2, RD2_r;
   wire [31:0] B, C, C_r;
   
   assign mips_pc = {PC[31:2],2'b00};
   assign mips_ir = instr[31:0];
 
   assign Op = instr[31:26];
   assign Funct = instr[5:0];
   assign rs = instr[25:21];
   assign rt = instr[20:16];
   assign rd = instr[15:11];
   assign Imm16 = instr[15:0];
   assign Imm26 = instr[25:0];
   
   
   ctrl U_CTRL (
      .clk(clk),	.rst(rst), .Zero(Zero), .Op(Op),  .Funct(Funct),
      .RFWr(RFWr),   .DMWr(DMWr),   .PCWr(PCWr),   .IRWr(IRWr),
      .EXTOp(EXTOp), .ALUOp(ALUOp), .NPCOp(NPCOp), .RF_A3_sel(RF_A3_sel),
      .RF_WD_sel(RF_WD_sel), .B_sel(B_sel)
   );
   
   PC U_PC (
      .clk(clk), .rst(rst), .PCWr(PCWr), .NPC(NPC), .PC(PC)
   ); 
   
   NPC U_NPC ( 
      .PC(PC), .NPCOp(NPCOp), .IMM(Imm26), .NPC(NPC)
   );
   
   im_4k U_IM ( 
      .rst(rst), .addr(PC[11:2]) , .dout(im_dout)
   );
   
   IR U_IR ( 
      .clk(clk), .rst(rst), .IRWr(IRWr), .im_dout(im_dout), .instr(instr)
   );
   
   RF U_RF (
      .A1(rs), .A2(rt), .A3(A3), .WD(WD), .clk(clk), 
      .RFWr(RFWr), .RD1(RD1), .RD2(RD2)
   );
   
   mux4 #(5) U_MUX4_RF_A3 (
      .d0(rd), .d1(rt), .d2(5'd31), .d3(/*undefine*/5'd0),
      .s(RF_A3_sel), .y(A3)
   );

   mux4 #(32) U_MUX4_RF_WD (
      .d0(C_r), .d1(DR_dout), .d2({PC,2'b00}), .d3(/*undefine*/32'd0),
      .s(RF_WD_sel), .y(WD)
   );
   
   flopr #(32) U_A (
      .clk(clk), .rst(rst), .d(RD1), .q(RD1_r)
   );
   
   flopr #(32) U_B (
      .clk(clk), .rst(rst), .d(RD2), .q(RD2_r)
   );
   
   EXT U_EXT ( 
      .Imm16(Imm16), .EXTOp(EXTOp), .Imm32(Imm32) 
   );
   
   mux2 #(32) U_MUX2_ALU_B (
      .d0(RD2_r), .d1(Imm32), .s(B_sel) , .y(B)
   );
   
   alu U_ALU ( 
      .A(RD1_r), .B(B), .ALUOp(ALUOp), .C(C), .Zero(Zero)
   );
   
   flopr #(32) U_ALUOut (
      .clk(clk), .rst(rst), .d(C), .q(C_r)
   );
   
   dm_4k U_DM ( 
      .addr(C_r[11:2]), .din(RD2_r), .DMWr(DMWr), .clk(clk), .dout(dm_dout)
   );
   
   flopr #(32) U_DR (
      .clk(clk), .rst(rst), .d(dm_dout), .q(DR_dout)
   );

endmodule