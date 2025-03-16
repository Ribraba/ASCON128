// ascon_top
// Ibrahim HADJ-ARAB
// 28 avril 2024

import ascon_pack::*;

module ascon_top (
    input logic clock_i, // Horloge principale
    input logic resetb_i, // Signal de réinitialisation (active low)
    input logic [63:0] data_i, // Données d'entrée
    input logic data_valid_i, // Signal indiquant que les données sont valides
    input logic [127:0] key_i, // Clé secrète pour le chiffrement
    input logic [127:0] nonce_i, // Nonce pour le chiffrement
    input logic start_i, // Signal pour démarrer le processus de chiffrement

    output logic [63:0] cipher_o, // Données chiffrées de sortie
    output logic [127:0] tag_o, // Tag de sortie pour l'authentification
    output logic end_o, // Signal indiquant la fin du processus de chiffrement
    output logic cipher_valid_o // Signal indiquant que le chiffrement est valide
);

    // Signaux d'interconnexion
    logic [3:0] round_s; // Compteur de rondes
    logic [3:0] cpt_bloc_s; // Compteur de blocs

    logic state_mode_s; // Mode du multiplexeur
    logic en_xor_key_begin_s, en_xor_data_begin_s, en_xor_key_end_s, en_xor_lsb_end_s;
    logic en_reg_state_s, en_cipher_s, en_tag_s;
    logic en_cpt_round_s, en_cpt_block_s, init_cpt_block_s;

    logic init_p6_s, init_p12_s;
    
    type_state state_output_s; // Sortie de l'état après permutation et XOR
    
    // Instance de la FSM
    FSM FSM_inst (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .start_i(start_i),
        .data_valid_i(data_valid_i),
        .round_i(round_s),
        .cpt_block_i(cpt_bloc_s),
        .data_sel_o(state_mode_s),
        .en_xor_key_begin_o(en_xor_key_begin_s),
        .en_xor_data_begin_o(en_xor_data_begin_s),
        .en_xor_key_end_o(en_xor_key_end_s),
        .en_xor_lsb_end_o(en_xor_lsb_end_s),
        .en_reg_state_o(en_reg_state_s),
        .en_cipher_o(en_cipher_s),
        .en_tag_o(en_tag_s),
        .en_cpt_round_o(en_cpt_round_s),
        .init_p12_o(init_p12_s),
        .init_p6_o(init_p6_s),
        .en_cpt_block_o(en_cpt_block_s),
        .init_cpt_block_o(init_cpt_block_s),
        .end_o(end_o),
        .cipher_valid_o(cipher_valid_o)
    );

    // Compteur de blocs
    compteur_simple_init compteur_de_bloc (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_i(en_cpt_block_s),
        .init_a_i(init_cpt_block_o),
        .cpt_o(cpt_bloc_s) 
    );

    // Compteur de rondes
    compteur_double_init compteur_de_rondes (
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_i(en_cpt_round_s),
        .init_a_i(init_p12_s),
        .init_b_i(init_p6_s),
        .cpt_o(round_s) 
    );

    // Module permutation_xor
    permutation_xor permutation_finale (
        .state_i({data_i, key_i[127:64], key_i[63:0], nonce_i[127:64], nonce_i[63:0]}),
        .round_i(round_s),
        .clock_i(clock_i),
        .resetb_i(resetb_i),
        .en_i(en_reg_state_s),
        .en_out_tag_i(en_tag_s),
        .en_out_cipher_i(en_cipher_s),
        .state_mode_i(state_mode_s),
        .key_i(key_i),
        .en_xor_key_begin_i(en_xor_key_begin_s),
        .en_xor_lsb_i(en_xor_lsb_end_s),
        .en_xor_key_end_i(en_xor_key_end_s),
        .data_i(data_i),
        .en_xor_data_i(en_xor_data_begin_s),
        .cipher_o(cipher_o),
        .tag_o(tag_o)
    );

endmodule : ascon_top
