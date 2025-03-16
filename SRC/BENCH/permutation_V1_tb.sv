// Permutation V1 Test Bench
// Ibrahim HADJ-ARAB
// 27 mars 2024

`timescale 1ns / 1ps

import ascon_pack::*;

module permutation_V1_tb ();
	
// Déclaration des signaux
type_state state_input_s, state_output_s;
logic data_sel_input_s;
logic[3:0] round_input_s;
logic clock_input_s= 1'b0;
logic resetb_input_s;
logic en_reg_state_input_s;

// Instanciation du DUT (Design Under Test)
permutation_step1 DUT (
	.state_i(state_input_s),
	.data_sel_i(data_sel_input_s),
	.round_i(round_input_s),
	.clock_i(clock_input_s),
	.resetb_i(resetb_input_s),
	.en_reg_state_i(en_reg_state_input_s),
	.state_o(state_output_s)
);

// Horloge
always begin 
	#10;
	assign clock_input_s = ~clock_input_s;
end

initial begin

	state_input_s[0] = 64'h80400c0600000000;
	state_input_s[1] = 64'h8a55114d1cb6a9a2;
	state_input_s[2] = 64'hbe263d4d7aecaaff;
	state_input_s[3] = 64'h4ed0ec0b98c529b7;
	state_input_s[4] = 64'hc8cddf37bcd0284a;

	resetb_input_s = 1'b0;
	data_sel_input_s = 1'b0;
	en_reg_state_input_s = 1'b1;
	round_input_s = 4'b0000;
	#2;
	
	resetb_input_s = 1'b1;
	#18;

	data_sel_input_s = 1'b1;
	round_input_s = 4'b0001;
	#20;

	round_input_s = 4'b0010;
	#20;

	round_input_s = 4'b0011;
	#20;

	round_input_s = 4'b0100;
	#20;

	round_input_s = 4'b0101;
	#20;

	round_input_s = 4'b0110;
	#20;

	round_input_s = 4'b0111;
	#20;

	round_input_s = 4'b1000;
	#20;

	round_input_s = 4'b1001;
	#20;

	round_input_s = 4'b1010;
	#20;

	round_input_s = 4'b1011;
	#20;

end

endmodule
