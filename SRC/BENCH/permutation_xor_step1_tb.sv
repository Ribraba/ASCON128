// Permutation avec XOR Test Bench de la phase d'initialisation
// Ibrahim HADJ-ARAB
// 23 Avril 2024

`timescale 1 ns/ 1 ps

import ascon_pack::*;

module permutation_xor_step1_tb ();

// Déclaration des signaux
type_state state_input_s;
logic[3:0] round_input_s;
logic clock_input_s = 1'b0;
logic resetb_input_s; 
logic en_reg_state_input_s;
logic state_mode_input_s;
logic[127:0] key_input_s;
logic en_xor_key_begin_input_s;
logic en_xor_lsb_input_s;
logic en_xor_key_end_input_s; 
logic[63:0] data_input_s; 
logic en_xor_data_input_s; 
type_state state_output_s; 
logic[63:0] cipher_input_s;
logic[63:0] cipher_output_s;
logic[127:0] tag_output_s;


// Instanciation du DUT (Design Under Test)
permutation_xor DUT (
    .state_i(state_input_s),
    .round_i(round_input_s),
    .clock_i(clock_input_s), 
    .resetb_i(resetb_input_s), 
    .en_i(en_reg_state_input_s),
    .state_mode_i(state_mode_input_s),
    .key_i(key_input_s),
    .en_xor_key_begin_i(en_xor_key_begin_input_s), 
    .en_xor_lsb_i(en_xor_lsb_input_s), 
    .en_xor_key_end_i(en_xor_key_end_input_s), 
    .data_i(data_input_s), 
    .en_xor_data_i(en_xor_data_input_s), 
    .state_o(state_output_s), 
    .cipher_i(cipher_input_s),
    .cipher_o(cipher_output_s),
    .tag_o(tag_output_s)
   
);

// Horloge
always begin 
	#10;
	assign clock_input_s = ~clock_input_s;
end

initial
    begin
      
    state_input_s[0] = 64'h80400c0600000000; // données d'entrées
	state_input_s[1] = 64'h8a55114d1cb6a9a2;
	state_input_s[2] = 64'hbe263d4d7aecaaff;
	state_input_s[3] = 64'h4ed0ec0b98c529b7;
	state_input_s[4] = 64'hc8cddf37bcd0284a;

    key_input_s = 128'h8a55114d1cb6a9a2be263d4d7aecaaff; // K

	resetb_input_s = 1'b0; 
	state_mode_input_s = 1'b0; // Selectionneur du premier multiplexeur
	en_reg_state_input_s = 1'b1;
	round_input_s = 4'b0000; // Nombre de rondes en cours

    en_xor_key_begin_input_s = 1'b0; 
    en_xor_data_input_s = 1'b0;
    en_xor_key_end_input_s =1'b0;
    en_xor_lsb_input_s = 1'b0;

	#2;

    resetb_input_s = 1'b1;
	#18;

	state_mode_input_s = 1'b1;

    // Phase d'Initialisation

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

    // À r = 11 on doit XOR avec la clef
    en_xor_key_end_input_s = 1'b1;

    #20;

    en_xor_key_end_input_s = 1'b0;

    // Fin de la phase d'initialisation
    
   end

endmodule 