// Permutation V1
// Ibrahim HADJ-ARAB
// 27 mars 2024

import ascon_pack::*;

module permutation_V1
	(
	input type_state state_i,
	input logic data_sel_i,
	input logic[3:0] round_i,
	input logic clock_i,
	input logic resetb_i,
	input logic en_reg_state_i,
	output type_state state_o
);

	// Déclaration des fils internes
	type_state mux_to_state_s, cst_to_sub_s, sub_to_lim_s, lim_to_reg_s, state_s;
	
	// Description structurelle du multiplexeur
	mux_state mux1 (
	     .data1_i(state_i),
	     .sel_i(data_sel_i),
	     .data2_i(state_s),
	     .data_o(mux_to_state_s)
	);

	// Description structurelle de l'additionneur de constante
	constant_addition pc (
	     .state_i(mux_to_state_s),
	     .round_i(round_i),
	     .state_o(cst_to_sub_s)
	);

	// Description structurelle de la couche de substitution
	substitution_layer ps (
	     .state_i(cst_to_sub_s),
	     .state_o(sub_to_lim_s)
	);

	// Description structurelle de la couche de diffusion
	diffusion_layer pl (
	     .diffusion_i(sub_to_lim_s),
	     .diffusion_o(lim_to_reg_s)
	);

	// Description structurelle du State Register
	state_register_w_en state_register (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_reg_state_i),
		.data_i(lim_to_reg_s),
		.data_o(state_s) 
	);

	assign state_o = state_s;
	
endmodule
