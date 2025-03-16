// Couche de diffusion linéaire Test Bench
// Ibrahim HADJ-ARAB
// 21 mars 2024

import ascon_pack::*;

module diffusion_layer_tb ();
	
// Déclaration des signaux
type_state diff_input_s;
type_state diff_output_s;

// Instanciation du DUT (Design Under Test)
diffusion_layer DUT (
	.diffusion_i(diff_input_s),
	.diffusion_o(diff_output_s)
);

initial begin
	diff_input_s[0] = 64'h78e2cc41faabaa1a;
	diff_input_s[1] = 64'hbc7a2e775aababf7;
	diff_input_s[2] = 64'h4b81c0cbbdb5fc1a;
	diff_input_s[3] = 64'hb22e133e424f0250;
	diff_input_s[4] = 64'h044d33702433805d;
	
end

endmodule
