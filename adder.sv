// adder.vp 
module adder (
input logic [31:0] adder_input_a, adder_input_b,
output logic [31:0] alu_out);

assign alu_out = adder_input_a + adder_input_b;

endmodule
