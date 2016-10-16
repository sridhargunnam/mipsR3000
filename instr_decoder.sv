// instr_decoder.vp
module id(
input logic [5:0] instr,
output logic [5:0] alu_op,
output logic [3:0] branch_control,
output logic source_1_sel,branch,jump,load,store,mem_rd_en,mem_wr_en);
logic [12:0] control;
always_comb
	begin
	unique case(instr)
	6'b000000:    begin control = 13'b100000_0_0_0_0_0_0_0;    //R Type Instruction
//			$display("R type"); 
			end
	6'b001000:    control = 13'b000001_1_0_0_0_0_0_0;    //ADD I
	6'b001100:    control = 13'b000010_1_0_0_0_0_0_0;    //AND I 
	6'b000100:    control = 13'b000000_0_1_0_0_0_0_0;	   //Branch Equal
			
	6'b000111:    control = 13'b000000_0_1_0_0_0_0_0;	   //Branch Greater than
	6'b000101:    control = 13'b000000_0_1_0_0_0_0_0;	   //Branch Not Equal
	6'b100101:    control = 13'b000001_1_0_0_0_0_1_0;	   //Load
	6'b001101:    control = 13'b000100_1_0_0_0_0_0_0;	   //OR I
	6'b001010:    control = 13'b001000_1_0_0_0_0_0_0;	   //SLT I
    6'b101011:    control = 13'b000001_1_0_0_0_1_0_1;	   //Store
	6'b001110:    control = 13'b010000_1_0_0_0_0_0_0;	   //XOR I
	6'b000010: 	  control = 13'b000000_0_0_1_0_0_0_0; //JUMP
	

	endcase
	end
	always_comb begin
	unique case(instr)
	6'b000100: branch_control = 4'b0001;
	6'b000111: branch_control = 4'b0100;
	6'b000101: branch_control = 4'b0010;
	default : branch_control = 4'b0000;
	endcase
	end
assign {alu_op,source_1_sel,branch,jump,load,store,mem_rd_en,mem_wr_en} = control;
endmodule
