// Module : FSM OPTIMISÉE pour toutes les phases 
//(C'est une machine de Mealy car les états futurs dépendent de l'état précédent ET des entrées)
// Ibrahim HADJ-ARAB
// 13 mai 2024

module FSM_OPT (

    // Entrées 
    input logic clock_i,
    input logic resetb_i,
    input logic start_i,
    input logic data_valid_i, 
    input logic [3:0] round_i, // Compteur de rondes
    input logic [3:0] cpt_block_i, // Compteur de bloc

    // Sortie Multiplexeur 
    output logic data_sel_o, // Quelle sortie du mux on choisit

    // Sorties pour les XOR
    output logic en_xor_key_begin_o,
    output logic en_xor_data_begin_o,
    output logic en_xor_key_end_o,
    output logic en_xor_lsb_end_o,

    // Sorties pour les registres
    output logic en_reg_state_o,
    output logic en_cipher_o,
    output logic en_tag_o,

    // Sorties pour les compteurs
    output logic en_cpt_round_o, // Sert à savoir si on remet le compteur de rondes à 0
    output logic init_p12_o, // RAZ du compteur de rondes pour 12 rondes
    output logic init_p6_o, // RAZ du compteur de rondes pour 6 rondes
    output logic en_cpt_block_o, // Sert à savoir si on remet le compteur de bloc à 0
    output logic init_cpt_block_o, // RAZ du compteur de blocs ou incrémentation


    // Sortie 
    output logic end_o,
    output  logic cipher_valid_o
);

typedef enum {

    // Phase d'initialisation
    attente, conf_init, init_rd0_to_rd11, 

    // Phase de données associées
    attente_da, da_rd0_to_rd5,

    // Phase de texte clair
    attente_pt, pt_bloc0_to_bloc1, pt_rd1_to_rd5, pt_attente_cipher,

    // Phase de finalisation
    final_init, final_rd0_to_rd11, fin_final
} state_t;

state_t current_state, next_state;

// Logique de transition d'état
always_ff @(posedge clock_i or negedge resetb_i) begin
    if (!resetb_i)
        current_state <= attente;
    else
        current_state <= next_state;
end

// Logique du prochain état
always_comb begin
    case (current_state)
        attente: next_state = start_i ? conf_init : attente;
        conf_init: next_state = data_valid_i ? init_rd0_to_rd11 : attente;
        init_rd0_to_rd11: next_state = (round_i == 11) ? attente_da : init_rd0_to_rd11;

        attente_da: next_state = data_valid_i ? da_rd0_to_rd5 : attente_da;
        da_rd0_to_rd5: next_state = (round_i == 11) ? attente_pt : da_rd0_to_rd5;

        attente_pt: next_state = data_valid_i ? pt_bloc0_to_bloc1 : attente_pt;
        pt_bloc0_to_bloc1: 
            if (cpt_block_i == 2)
                next_state = final_init;
            else 
                next_state = pt_rd1_to_rd5;
        pt_rd1_to_rd5:
            if (round_i == 10)
                next_state = pt_attente_cipher;
            else 
                next_state = pt_rd1_to_rd5;
        pt_attente_cipher: next_state = pt_bloc0_to_bloc1;

        final_init: next_state = final_rd0_to_rd11;
        final_rd0_to_rd11: next_state = (round_i == 11) ? fin_final : final_rd0_to_rd11;
        fin_final: next_state = attente;

        default: next_state = attente;
    endcase
end

// Logique de sortie en fonction de l'état
always_comb begin
    // Initialiser toutes les sorties à zéro
    
    data_sel_o = 0; 
    
    en_xor_key_begin_o = 0; 
    en_xor_data_begin_o = 0; 
    en_xor_key_end_o = 0;
    en_xor_lsb_end_o = 0; 
    
    en_reg_state_o = 0; 
    en_cipher_o = 0; 
    en_tag_o = 0;
    
    en_cpt_round_o = 0; 
    init_p12_o = 0; 
    init_p6_o = 0; 
    en_cpt_block_o = 0; 
    init_cpt_block_o = 0;

    cipher_valid_o = 0;
    
    end_o = 0;

    // Définir les sorties pour chaque état
    case (current_state)
        attente: begin
            en_tag_o = 1;
        end
        conf_init: begin
            en_cpt_round_o = 1; 
            init_p12_o = 1; 
        end

        init_rd0_to_rd11: begin
            en_cpt_round_o = 1; 
            en_reg_state_o = 1;
            if (round_i > 0){
                data_sel_o = 1;
                if (round_i = 10){
                    en_xor_key_end_o = 1;
                }
            }
            
        end
        
        attente_da: begin
            en_cpt_round_o = 1; 
            init_p6_o = 1; 
            data_sel_o = 1; 
        
        end

        da_rd0_to_rd5: begin
            data_sel_o = 1; 
            en_reg_state_o = 1;
            if (round_i = 0){
                en_xor_data_begin_o = 1; 
                en_cpt_round_o = 1;
            }
            else if (round_i = 10){
                en_xor_lsb_end_o = 1;
            }
            else{
                en_cpt_round_o = 1; 
            }
    
        end

        pt_bloc0_to_bloc1: begin
            data_sel_o = 1; 
            en_cpt_round_o = 1; 
            init_p6_o = 1;
            en_cpt_block_o = 1;
             
        end

        pt_rd1_to_rd5: begin
            data_sel_o = 1;
            en_reg_state_o = 1;
            en_cpt_round_o = 1; 
            if (round_i = 1){
                en_xor_data_begin_o = 1;
                en_cipher_o = 1;
            }
            else {
                cipher_valid_o = 1;
            }
            
        end

        pt_attente_cipher: begin
            data_sel_o = 1;
            en_reg_state_o = 1;
        end

        final_init: begin
            data_sel_o = 1; 
            en_cpt_round_o = 1;
            init_p12_o = 1;
        end

        final_rd0_to_rd11: begin
            data_sel_o = 1; 
            en_reg_state_o = 1;
            en_cpt_round_o = 1;
            if (round_i = 0){
                en_xor_key_begin_o = 1; 
                en_xor_data_begin_o = 1; // Pour XOR avec P3
                en_cipher_o = 1;
                cipher_valid_o = 1;
            }
            else if (round_i = 11){
                en_xor_key_end_o = 1;
                en_tag_o = 1;
            }    
        
        end

        fin_final: begin
            data_sel_o = 1;
            end_o = 1;
        end
    endcase
end

endmodule : FSM_OPT
