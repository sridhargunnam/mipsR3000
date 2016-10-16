// combCore.vp

//; # Good Habits
//; use strict ;                   # Use a strict interpretation
//; use warnings FATAL=>qw(all);   # Turn warnings into errors
//; use diagnostics ;              # Print helpful info, for errors

//; # Parameters
//; my $bW = parameter( name=>"bitWidth", val=>32 , doc=>"width of the input");

module combCore (
input logic [31:0] instr,
input logic [31:0] pc,
input logic [31:0] src0,
input logic [31:0] src1,
input logic [31:0] memRdData,
output logic [31:0] memRdAddr,
output logic memRdEn,
output logic [31:0] memWrData ,
output logic [31:0] memWrAddr,
output logic memWrEn,
output logic [31:0] dst0,
output logic [31:0] pcNxt
);
logic [5:0] alu_op;
logic source_1_sel,branch,jump,load,store,mem_rd_en,mem_wr_en;
logic [7:0] alu_control;
logic [3:0] jump_reg;
logic [31:0] alu_input_b;
logic [31:0] alu_out;
logic zero;
logic [31:0] inst_sign_ext,sign_ext_br_off;
logic branch_z,branch_neq,branch_gt,brach_or_jumpR;
logic [3:0] branch_control;
logic [31:0] pc_plus_4, pc_b4_jump, jump_pc;
logic [31:0] branch_jump_offset;
logic [31:0] pc_plus_offset;
// instantiation of submodules
//; my $instr_decoderi= generate( "instr_decoder","ID1");
id inst_d (instr[31:26],alu_op,branch_control,source_1_sel,branch,jump,load,store,mem_rd_en,mem_wr_en);
//; my $alu_decoderi = generate( "alu_decoder","alud1");
ad acb(alu_op,instr[5:0],alu_control,jump_reg);
assign inst_sign_ext = {{16{instr[15]}},instr[15:0]}; 
//always@(*) $display("sign extended %d",inst_sign_ext); 
//; my $mux_2_1i = generate("mux_2_1","mux21");
mux2 mux_alu_s1 (inst_sign_ext,src1,source_1_sel,alu_input_b);
//ALU Instantiation
//; my $ALUi = generate("alu","aluact");
alu1 alui (src0,alu_input_b,alu_control,alu_out,zero);
//always@(*) $display("ALU OUT %d",alu_out);
assign dst0 = (load)?memRdData:alu_out;
//always@(*) $display("dst0 is %d",dst0);
assign memRdEn = mem_rd_en;
assign memWrEn = mem_wr_en;
assign memRdAddr = (load)?alu_out:32'd0;
assign memWrData = (store)?src1:32'd0;
assign memWrAddr = (store)?alu_out:32'd0;

//PC Next Logic
assign branch_z = branch & zero;
assign branch_neq = branch & (~zero) ;
assign branch_gt = (branch & (~zero) & ~alu_out[31]);

always @(*)
begin
	unique case(branch_control | jump_reg)
	4'b0001:brach_or_jumpR=branch_z;
	    
	4'b0010:brach_or_jumpR=branch_neq;
	
	4'b0100:brach_or_jumpR=branch_gt;
	
	4'b1000:brach_or_jumpR=jump_reg[3];
	endcase
end

//assign brach_or_jumpR = ( branch_z | branch_neq | branch_gt | jump_reg); 



// use demux
//; my $adderpc4 = generate("adder","pc4");
adder ad2 (pc,32'd4,pc_plus_4);
assign sign_ext_br_off = {{14{instr[15]}},instr[15:0],{2'b00}}; 
assign branch_jump_offset = ((jump_reg[3])?(src0):((branch)?sign_ext_br_off:32'd0));
//always@(*) $display("branch is %d sign_ext_br_off is %b ", branch,sign_ext_br_off);

//; my $adderpc_off = generate("adder","pcoff");
adder pc1 (pc_plus_4,branch_jump_offset,pc_plus_offset);
assign pc_b4_jump = brach_or_jumpR?pc_plus_offset:pc_plus_4;
assign jump_pc = {pc_b4_jump[31:28],instr[25:0],2'd0};
assign pcNxt = jump?jump_pc:pc_b4_jump;

//always@(*) $display("branch target is %d",branch_jump_offset);
endmodule

// jump and branch 
// pc at initial
