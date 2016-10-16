// alu.vp
module alu1 (
input logic [31:0] alu_input_a, alu_input_b,
input logic [7:0] alu_control,
output [31:0] alu_out,
output logic zero);
logic [31:0] alu_out_pass;
always_comb
	begin
	unique case(alu_control)
	8'b00000001: begin alu_out_pass = alu_input_a + alu_input_b; 
//	$display("alu_src0 %d alu_src1 %d alu_out %d",alu_input_a,alu_input_b,alu_out_pass); 
			end
	
	8'b00000010: alu_out_pass = alu_input_a - alu_input_b;
	8'b00000100: alu_out_pass = alu_input_a & alu_input_b;
	8'b00001000: alu_out_pass = alu_input_a | alu_input_b;
	8'b00010000: alu_out_pass = alu_input_a ^ alu_input_b;
	8'b00100000: alu_out_pass = ~(alu_input_a |  alu_input_b);
	8'b01000000: alu_out_pass = alu_input_a >> 5'd5;
	8'b10000000: alu_out_pass = (alu_input_a < alu_input_b)?32'd1:32'd0;
	default: alu_out_pass='bx;
	endcase
//$display("out of case");
	end
assign zero = ((alu_input_a - alu_input_b)==32'd0)?1'b1:1'b0;
assign alu_out = alu_out_pass ;
endmodule
	
	
