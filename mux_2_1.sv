// mux_2_1.vp
module mux2(
input logic [31:0] mux_input_1, 
input logic [31:0] mux_input_2,
input logic mux_control,
output logic [31:0] mux_out);

assign mux_out = (mux_control)?mux_input_1:mux_input_2;
//always_comb begin 
//$display("mux_input1 %d mux_input2 %d mux_control %d mux_out %d ",mux_input_1,mux_input_2,mux_control,mux_out);
//end
endmodule