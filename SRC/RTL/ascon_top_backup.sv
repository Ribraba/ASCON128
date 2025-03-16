// ascon_top
// Ibrahim HADJ-ARAB
// 28 avril 2024

import ascon_pack::*;

module ascon_top_backup (
    input logic clock_i, //OK
    input logic resetb_i, //OK
    input logic [63:0] data_i, //OK
    input logic data_valid_i, //OK
    input logic [127:0] key_i, //OK
    input logic [127:0] nounce_i, //OK
    input logic start_i, //OK


    output logic [63:0] cipher_o, //OK
    output logic [127:0] tag_o, //OK
    output logic end_o, //OK
    output logic cipher_valid_o //OK
);
    assign data_i = 64'h4120746f2042; // A
    assign key_i = 128'h8a55114d1cb6a9a2be263d4d7aecaaff; // K
    assign nounce_i = 128'h4ed0ec0b98c529b7c8cddf37bcd0284a; // N

    // Signaux d'interconnexion
    logic [3:0] round_s; //OK
    logic [3 : 0] cpt_bloc_s; //OK

    logic state_mode_s; //OK
    logic en_xor_key_begin_s, en_xor_data_begin_s, en_xor_key_end_s, en_xor_lsb_end_s; //OK
    logic en_reg_state_s, en_cipher_s, en_tag_s;

    logic init_p6_s, init_p12_s;
    logic input_mode_s, xor_key_s; // mux, 
    type_state state_output_s; //OK
    
    FSM FSM_inst (

        // Entrées 
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .start_i(start_i),
        .data_valid_i(data_valid_i), 
        .round_i(round_s), // Compteur de rondes
        .cpt_block_i(cpt_bloc_s), // Compteur de bloc

        // Sortie Multiplexeur 
        .data_sel_o(state_mode_s), // Quelle sortie du mux on choisit

        // Sorties pour les XOR
        .en_xor_key_begin_o(en_xor_key_begin_s),
        .en_xor_data_begin_o(en_xor_data_begin_s),
        .en_xor_key_end_o(en_xor_key_end_s),
        .en_xor_lsb_end_o(en_xor_lsb_end_s),

        // Sorties pour les registres
        .en_reg_state_o(en_reg_state_s),
        .en_cipher_o(en_cipher_s),
        .en_tag_o(en_tag_s),

        // Sorties pour les compteurs
        .en_cpt_round_o(), // Sert à savoir si on remet le compteur de rondes à 0
        .init_p12_o(init_p12_s), // RAZ du compteur de rondes pour 12 rondes
        .init_p6_o(init_p6_s), // RAZ du compteur de rondes pour 6 rondes
        .en_cpt_block_o(), // Sert à savoir si on remet le compteur de bloc à 0
        .init_cpt_block_o(), // RAZ du compteur de blocs ou incrémentation


        // Sortie 
        .end_o(end_o),
        .cipher_valid_o(cipher_valid_o)
    );

    //Initialisation du compteur simple // Normalement il y a que des _s ici
    compteur_simple_init compteur_de_bloc (

    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .en_i(en_reg_state_s),
    .init_a_i(),
    .cpt_o(cpt_bloc_s) 

    );

    // Initialisation du compteur double // Normalement il y a que des _s ici
    compteur_double_init compteur_de_rondes (

    .clock_i(clock_i),
    .resetb_i(resetb_i),
    .en_i(en_reg_state_s),
    .init_a_i(init_p12_s),
    .init_b_i(init_p6_s),
    .cpt_o(round_s) 

    );

    // Initialisation du permutation_xor

    permutation_xor permutaion_finale (

	.state_i({64'h80400C0600000000, key_i, nounce_i}), // Segmenter key_i en 2 pareil pour nounce_i
	.round_i(round_s),
	.clock_i(clock_i), 
	.resetb_i(resetb_i), 
	.en_i(en_reg_state_s), // choix si on écrit dans le banc de registre à la fin des permu et du XOR
	.en_out_tag_i(), // choix si on écrit dans le registre pour le tag
	.en_out_cipher_i(), // choix si on écrit dans le registre pour la clef  de chiffrement cipher 
	.state_mode_i(), // Choisir l'état du multiplexeur
	.key_i(key_i), // clef K 
	.en_xor_key_begin_i(en_xor_key_begin_s), // choix si on XOR avec la clef avant permu
	.en_xor_lsb_i(en_xor_lsb_end_s),  // choix si on XOR en fin de données associées
	.en_xor_key_end_i(en_xor_key_end_s), // choix si on XOR avec la clef après permu
	.data_i(data_i), // donnée qu'on XOR avant les permutations (A, P1, P2 et P3)
	.en_xor_data_i(en_xor_data_begin_s), // choix si on XOR avec data_i
	.state_o(state_output_s), 
	.cipher_o(cipher_o), // sortie C1, C2 et C3
	.tag_o(tag_o) // sortie du tag : T

    );

endmodule: ascon_top_backup


