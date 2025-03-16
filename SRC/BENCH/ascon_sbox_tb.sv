// Test Bench de la sbox
// Ibrahim HADJ-ARAB
// 20 mars 2024

import ascon_pack::*;

module ascon_sbox_tb();

// Déclaration des signaux
logic[4:0] sbox_i_s, sbox_o_s;

// Instanciation du DUT (Design Under Test)
ascon_sbox DUT (
	.sbox_i(sbox_i_s),
	.sbox_o(sbox_o_s)
);

// Stimuli de test
initial begin
	integer i;

	for (i=0; i<32; i++) begin
		sbox_i_s = i;
		#50;
	end
    
end

endmodule

