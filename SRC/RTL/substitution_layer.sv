// Couche de substitution 
// Ibrahim HADJ-ARAB
// 20 mars 2024

import ascon_pack::*;

module substitution_layer
	(
	input type_state state_i,
	output type_state state_o
);

// tableau de substitution

	genvar i;
	generate
		for (i=0; i< 64; i++) begin : sub
			ascon_sbox gros_table (
				.sbox_i({state_i[0][i], state_i[1][i], state_i[2][i], state_i[3][i], state_i[4][i]}),
				.sbox_o({state_o[0][i], state_o[1][i], state_o[2][i], state_o[3][i], state_o[4][i]}));
		
		end
	endgenerate
endmodule
