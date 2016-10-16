// alu_decoder.vp
module ad(
input logic [5:0] alu_op,
input logic [5:0] func,
output [7:0] alu_control,
output logic [3:0] jump_reg);
logic [7:0] alu_control_pass;
always_comb
	begin
	case(alu_op)
	6'b000001: alu_control_pass = 8'b00000001;     //AddI
	6'b000010: alu_control_pass = 8'b00000100;	   //AndI
	6'b000100: alu_control_pass = 8'b00001000;	   //ORI
	6'b001000: alu_control_pass = 8'b10000000;	   //SLTI
	6'b010000: alu_control_pass = 8'b00010000;	   //XorI
	6'b000000: alu_control_pass = 8'b00000010;	   //bgtz sub
	6'b100000:
		begin
			unique case(func)
			6'b100000: begin alu_control_pass = 8'b00000001;      //Add
				   	 //$display("doing add oper"); 
					 end 
			6'b100010: alu_control_pass = 8'b00000010;	    //Sub
			6'b100100: alu_control_pass = 8'b00000100;      //And
			6'b100101: alu_control_pass = 8'b00001000;      //Or
			6'b100110: alu_control_pass = 8'b00010000;      //Xor
			6'b100111: alu_control_pass = 8'b00100000;      //Nor
			6'b000011: alu_control_pass = 8'b01000000;      //SRA
			6'b101010: alu_control_pass = 8'b10000000;      //SLT
			6'b001000: alu_control_pass = 8'b00000000;      //Jump Register
			endcase	
		end
	endcase
	end
	
assign jump_reg = ({alu_op,func} == 12'b100000_001000)?4'b1000:4'b0000;
assign alu_control = alu_control_pass;
endmodule
