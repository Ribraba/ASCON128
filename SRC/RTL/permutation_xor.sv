// Permutation avec XOR 
// Ibrahim HADJ-ARAB
// 15 Avril 2024

`timescale 1ns/1ps

import ascon_pack::*;

module permutation_xor (

	input type_state state_i,
	input logic[3:0] round_i,
	input logic clock_i, 
	input logic resetb_i, 
	input logic en_i, // choix si on écrit dans le banc de registre à la fin des permu et du XOR
	input logic en_out_tag_i, // choix si on écrit dans le registre pour le tag
	input logic en_out_cipher_i, // choix si on écrit dans le registre pour la clef  de chiffrement cipher 
	input logic state_mode_i, // Choisir l'état du multiplexeur
	input logic[127:0] key_i, // clef K 
	input logic en_xor_key_begin_i, // choix si on XOR avec la clef avant permu
	input logic en_xor_lsb_i,  // choix si on XOR en fin de données associées
	input logic en_xor_key_end_i, // choix si on XOR avec la clef après permu
	input logic[63:0] data_i, // donnée qu'on XOR avant les permutations (A, P1, P2 et P3)
	input logic en_xor_data_i, // choix si on XOR avec data_i
	output logic[63:0] cipher_o, // sortie C1, C2 et C3
	output logic[127:0] tag_o // sortie du tag : T


);
  
	// Déclaration des fils internes
	type_state mux_to_state_s, cst_to_sub_s, sub_to_lim_s, lim_to_xor_end_s, state_s, xor_begin_perm_s, xor_end_perm_s; // permutation_loop = state_s 

	// Description structurelle du multiplexeur
	mux_state mux1 (
		.data1_i(state_i),
		.sel_i(state_mode_i),
		.data2_i(state_s),
		.data_o(mux_to_state_s)
	);

	
	// Description structurelle du premier XOR
	xor_begin_perm xor1 (
		.en_xor_data_i(en_xor_data_i), //active xor donnée associée ou plaintext
		.en_xor_key_i(en_xor_key_begin_i), //active xor avec cle pour la finalisation
		.key_i(key_i),
		.data_i(data_i),
		.state_i(mux_to_state_s),
		.state_o(xor_begin_perm_s)
	);

	// Description structurelle du registre_write_enable après le premier XOR
	register_w_en #(
		.nb_bits_g(64)
	) cipher_reg (
		.clock_i(clock_i),
		.resetb_i(reset_i),
		.en_i(en_out_cipher_i),
		.data_i(xor_begin_perm_s[0]),
		.data_o(cipher_o)
	);

	// Description structurelle de l'additionneur de constante
	constant_addition pc (
		.state_i(xor_begin_perm_s),
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
		.diffusion_o(lim_to_xor_end_s)
	);


	// Description structurelle du deuxième XOR
	xor_end_perm xor2 (
		.en_xor_lsb_i(en_xor_lsb_i), //active xor avec LSB en fin de DA
		.en_xor_key_i(en_xor_key_end_i), //active xor avec cle en fin initialisation
		.key_i(key_i),
		.state_i(lim_to_xor_end_s),
		.state_o(xor_end_perm_s)
	);

	// Description structurelle du State Register
	state_register_w_en state_register (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_i),
		.data_i(xor_end_perm_s),
		.data_o(state_s) 
	);

	// Description structurelle du registre_write_enable après le deuxième XOR
	register_w_en #(
		.nb_bits_g(128)
	) tag_reg (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_out_tag_i),
		.data_i({state_s[3], state[4]}),
		.data_o(tag_o)
	);

endmodule : permutation_xor
