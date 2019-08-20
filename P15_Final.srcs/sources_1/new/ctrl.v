`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/20 21:42:03
// Design Name: 
// Module Name: ctrl
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
`include "instruction_def.v"
module ctrl(clk, rst, Zero, Op, Funct,
            RFWr, DMWr, PCWr, IRWr,
            EXTOp, ALUOp, NPCOp, RF_A3_sel,
            RF_WD_sel, B_sel);
    
   input clk, rst, Zero;       
   input [5:0] Op;
   input [5:0] Funct;
   output       RFWr;
   output       DMWr;
   output       PCWr;
   output       IRWr;
   output [1:0] EXTOp;
   output [3:0] ALUOp;
   output [1:0] NPCOp;
   output [1:0] RF_A3_sel;
   output [1:0] RF_WD_sel;//RF的WD端口选择
   output       B_sel; //ALU的B端口选择
    
   parameter Fetch  = 4'b0000,//读取指令
              DCD    = 4'b0001,//读取操作数
              MA    = 4'b0010,
              MR     = 4'b0011,
              MemWB = 4'b0100,
              MW    = 4'b0101,
              Exe     = 4'b0110,
              WB     = 4'b0111,
              Branch     = 4'b1000,
              Jmp  = 4'b1001; 
	
   wire RType;   // Type of R-Type Instruction
   wire IType;   // Type of Imm    Instruction  
   wire BrType;  // Type of Branch Instruction
   wire JType;   // Type of Jump   Instruction
   wire LdType;  // Type of Load   Instruction
   wire StType;  // Type of Store  Instruction
   wire MemType; // Type pf Memory Instruction(Load/Store)
	
   assign RType   = (Op == `INSTR_RTYPE_OP);
   assign IType   = (Op == `INSTR_ORI_OP|| Op ==`INSTR_ANDI_OP|| Op ==`INSTR_ADDIU_OP||Op ==`INSTR_XORI_OP);//扩充I型的指令
   assign BrType  = (Op == `INSTR_BEQ_OP|| Op ==`INSTR_BNE_OP);//扩充Branch型指令
   assign JType   = (Op == `INSTR_JAL_OP|| Op == `INSTR_J_OP );//扩充Jmp型指令
   assign LdType  = (Op == `INSTR_LW_OP );
   assign StType  = (Op == `INSTR_SW_OP );
   assign MemType = LdType || StType;
    
   /*************************************************/
   /******               FSM                   ******/
   reg [3:0] nextstate;
   reg [3:0] state;
   
   always @(posedge clk or posedge rst) begin
      if ( rst )
		   state <= Fetch;
      else
           state <= nextstate;
   end // end always
             
   always @(*) begin//state transition
      case (state)
         Fetch: nextstate = DCD;
         DCD: begin
            if ( RType || IType ) nextstate = Exe;
            else if ( MemType )  nextstate = MA;
            else if ( BrType )  nextstate = Branch;
            else if ( JType )  nextstate = Jmp;
            else   //if Op wrong, then fetch next one.
               nextstate = Fetch;
         end
         Exe:  nextstate = WB;
         MA: begin 
            if ( LdType ) nextstate = MR;   //LW
            else if ( StType ) nextstate = MW;   //SW
	     end
         Branch: nextstate = Fetch;
         Jmp: 	 nextstate = Fetch;
         MR:     nextstate = MemWB;
         MW:     nextstate = Fetch;
         WB:     nextstate = Fetch;
         MemWB:  nextstate = Fetch;      
			default: ;
       endcase
   end // end always
   
	/*************************************************/
	/******         Control Signal              ******/
   reg       RFWr;
   reg       DMWr;
   reg       PCWr;
   reg       IRWr;
   reg [1:0] EXTOp;
   reg [3:0] ALUOp;
   reg [1:0] NPCOp;
   reg [1:0] RF_A3_sel;
   reg [1:0] RF_WD_sel;
   reg       B_sel;
	
   always @( * ) begin//output
	   case ( state ) 
		 Fetch: begin
            PCWr   = 1'b1;
            NPCOp  = `NPC_PLUS4; 
            IRWr   = 1'b1;
            RFWr  = 1'b0;
            DMWr   = 1'b0;            
		 end // end Fetch
         DCD: begin
            PCWr   = 1'b0;           
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;				
            if (IType)
               EXTOp = `EXT_ZERO;
            else if (MemType)
               EXTOp  = `EXT_SIGNED;
			else
               EXTOp = 0;				
		 end	// end DCD
         Exe: begin
            PCWr   = 1'b0;           
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            DMWr   = 0;
            if (IType)
               B_sel   = `EXT;
            else
               B_sel   = `B;					
            if (Op == `INSTR_ORI_OP)
               ALUOp = `ALUOp_OR;
            else if (Op == `INSTR_ANDI_OP)
               ALUOp = `ALUOp_AND;
            else if (Op == `INSTR_ADDIU_OP)
               ALUOp = `ALUOp_ADDU;
            else if (Op == `INSTR_XORI_OP)
               ALUOp = `ALUOp_XOR;
            else if (Op == `INSTR_RTYPE_OP) begin
               case (Funct)
                   `INSTR_ADDU_FUNCT: ALUOp = `ALUOp_ADDU;
                   `INSTR_SUBU_FUNCT: ALUOp = `ALUOp_SUBU;
                   `INSTR_AND_FUNCT:  ALUOp = `ALUOp_AND;
                   `INSTR_XOR_FUNCT:  ALUOp = `ALUOp_XOR;
                   `INSTR_OR_FUNCT:   ALUOp = `ALUOp_OR;
                   `INSTR_NOR_FUNCT:  ALUOp = `ALUOp_NOR;
                   default: ;
               endcase
            end
		 end // end Exe
         MA: begin
            PCWr   = 1'b0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;            
            B_sel   = `EXT;
            ALUOp  = `ALUOp_ADDU;
		 end // end MA
         Branch: begin           
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            B_sel   = `B;
            ALUOp  = `ALUOp_SUBU;
            NPCOp  = `NPC_BRANCH;
            if (Op == `INSTR_BEQ_OP && Zero == 0)
               PCWr=1'b0;
            else if (Op == `INSTR_BNE_OP && Zero == 1)
               PCWr=1'b0;
            else
               PCWr=1'b1;
		 end // end Branch
         Jmp: begin
            PCWr   = 1'b1;
            NPCOp  = `NPC_JUMP;
            IRWr   = 1'b0;
            DMWr   = 1'b0;      
            RF_A3_sel = `RFSel_31;
            RF_WD_sel  = `WDSel_FromPC;
            if ( Op == `INSTR_J_OP)
               RFWr  = 1'b0;
            else if (Op == `INSTR_JAL_OP)
               RFWr  = 1'b1;
		 end // end Jmp
         MR:  begin
            PCWr   = 1'b0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;           
		 end // end MR
         MW:  begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b1;
            EXTOp  = 0;
            RF_A3_sel = 0;
            RF_WD_sel  = 0;
            B_sel   = 0;
            ALUOp  = 0;
		 end // end MW
         WB: begin
            PCWr   = 1'b0;            
            IRWr   = 1'b0;
            RFWr  = 1'b1;
            DMWr   = 1'b0;
            if (IType)
               RF_A3_sel = `RFSel_RT;
            else
               RF_A3_sel = `RFSel_RD;
            RF_WD_sel  = `WDSel_FromALU;
            B_sel   = 0;
            ALUOp  = 0;
		 end // end WB
         MemWB: begin
            PCWr   = 1'b0;            
            IRWr   = 1'b0;
            RFWr  = 1'b1;
            DMWr   = 1'b0;            
            RF_A3_sel = `RFSel_RT;
            RF_WD_sel  = `WDSel_FromMEM;          
		 end // end MemWB
		default: begin
            PCWr   = 1'b0;
            NPCOp  = 0;
            IRWr   = 1'b0;
            RFWr  = 1'b0;
            DMWr   = 1'b0;
            EXTOp  = 0;
            RF_A3_sel = 0;
            RF_WD_sel  = 0;
            B_sel   = 0;
            ALUOp  = 0;
		end // end default
	   endcase
   end // end always    
endmodule
