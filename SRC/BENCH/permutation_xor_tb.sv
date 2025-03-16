// Permutation avec XOR Test Bench 
// Ibrahim HADJ-ARAB
// 25 Avril 2024
// Il y a une erreur : dans la phase de texte clair on récupère 2 bits de plus pour C3 ce qui ne doit pas être le cas (ligne 138)

`timescale 1 ns/ 1 ps

import ascon_pack::*;

module permutation_xor_tb ();

    // Déclaration des signaux
    type_state state_input_s;
    logic[3:0] round_input_s;
    logic clock_input_s = 1'b0;
    logic resetb_input_s; 
    logic en_reg_state_input_s;
    logic en_input_s;
    logic en_out_cipher_input_s;
    logic en_out_tag_input_s;
    logic state_mode_input_s;
    logic[127:0] key_input_s;
    logic en_xor_key_begin_input_s;
    logic en_xor_lsb_input_s;
    logic en_xor_key_end_input_s; 
    logic[63:0] data_input_s; 
    logic en_xor_data_input_s; 
    type_state state_output_s; 
    logic[63:0] cipher_output_s;
    logic[127:0] tag_output_s;
    logic[63:0] p[2:0]; // Tableau de blocs de texte clair

    // Instanciation du module à tester (DUT)
    permutation_xor DUT (
        .state_i(state_input_s),
        .round_i(round_input_s),
        .clock_i(clock_input_s), 
        .resetb_i(resetb_input_s), 
        .en_i(en_input_s),
        .en_out_cipher_i(en_out_cipher_input_s),
        .en_out_tag_i(en_out_tag_input_s),
        .state_mode_i(state_mode_input_s),
        .key_i(key_input_s),
        .en_xor_key_begin_i(en_xor_key_begin_input_s), 
        .en_xor_lsb_i(en_xor_lsb_input_s), 
        .en_xor_key_end_i(en_xor_key_end_input_s), 
        .data_i(data_input_s), 
        .en_xor_data_i(en_xor_data_input_s), 
        .state_o(state_output_s), 
        .cipher_o(cipher_output_s),
        .tag_o(tag_output_s)
    );

    // Horloge
    always begin 
        #10;
        assign clock_input_s = ~clock_input_s;
    end

    initial begin

        // Initialisation des signaux
        resetb_input_s = 0; 
        state_mode_input_s = 0; // Sélecteur pour le multiplexeur d'état

        en_input_s = 1'b1; // Active l'écriture de state_s dans le registre
        en_out_cipher_input_s = 1'b0;
        en_out_tag_input_s = 1'b0;

        round_input_s = 4'b0000;
        key_input_s = 128'h8a55114d1cb6a9a2be263d4d7aecaaff;; // K

        en_xor_key_begin_input_s = 1'b0; 
        en_xor_data_input_s = 1'b0;
        en_xor_key_end_input_s =1'b0;
        en_xor_lsb_input_s = 1'b0;

        // Appliquer le reset
        #2;
        resetb_input_s = 1'b1;
        
        // Initialisation de l'état avec IV, K et N
        state_input_s[0] = 64'h80400c0600000000; // données d'entrées
        state_input_s[1] = 64'h8a55114d1cb6a9a2;
        state_input_s[2] = 64'hbe263d4d7aecaaff;
        state_input_s[3] = 64'h4ed0ec0b98c529b7;
        state_input_s[4] = 64'hc8cddf37bcd0284a;

        #18; // Attendre que le système se stabilise après le reset

        state_mode_input_s = 1'b1;

        // Phase d'initialisation 

        for (int round = 1; round < 12; round++) begin
            round_input_s = round; // Incrémentation du compteur de tours
            en_xor_key_end_input_s = (round == 11) ? 1'b1 : 1'b0; // Activation du XOR avec la clé à la fin de l'initialisation
            @(posedge clock_input_s); // Attendre un cycle d'horloge
        end

        en_xor_key_end_input_s = 1'b0; // Désactivation du XOR avec la clé

        // Fin de la phase d'initialisation
        
        // Phase des données associées

        data_input_s = 64'h4120746f20428000; // A1
        en_xor_data_input_s = 1'b1; // Activer le XOR avec les données associées
        round_input_s = 6;
        @(posedge clock_input_s);
        en_xor_data_input_s = 1'b0; // Désactiver le XOR
        

        // On fait 6 rondes de permutation après l'injection des données associées

        for (int round = 7; round < 12; round++) begin
            round_input_s = round; // Réinitialiser le compteur de tours pour les permutations p6
            en_xor_lsb_input_s = (round == 11) ? 1'b1 : 1'b0; // Activation du XOR pour le LSB à la phase de données associées
            @(posedge clock_input_s); // Attendre la fin du tour

        end
        
        en_xor_lsb_input_s = 1'b0; // On désactive le XOR LSB

        // Fin de la phase des données associées

        // Phase du texte clair 

        p[0] = 64'h5244562061752054; // P1
        p[1] = 64'h6927626172206365; // P2
        p[2] = 64'h20736f6972203f80; // P3

        // Boucle sur chaque bloc de texte clair
        for (int i = 0; i < 2; i++) begin
            data_input_s = p[i]; // On prend P1 puis P2 pour la phase de texte clair

            // On fait 6 rondes de permutation après chaque bloc
            for (int round = 6; round < 12; round++) begin
                round_input_s = round;
                
                en_out_cipher_input_s = (round == 6) ? 1'b1 : 1'b0; // On enregistre C1 et C2 si round = 6
                en_xor_data_input_s = (round == 6) ? 1'b1 : 1'b0; // Apliquer le XOR avec le bloc de texte clair (pour P1 et P2 si round = 6)

                @(posedge clock_input_s); // Attendre la fin du tour
            end
        end

        data_input_s = p[2]; // P3
        en_out_cipher_input_s = 1'b1;
        en_xor_data_input_s = 1'b1;
        en_input_s = 1'b0;

        @(posedge clock_input_s); // Attendre la fin du tour

        en_input_s = 1'b1;
        en_out_cipher_input_s = 1'b0; // On a fini de récupérer C3

        // Fin de la phase de texte clair

        // Phase de finalisation et obtention du tag

        // On fait 12 rondes de permutation

        for (int round = 0; round < 12; round++) begin
            round_input_s = round;

            en_xor_data_input_s = (round == 0) ? 1'b1 : 1'b0;
            en_xor_key_begin_input_s = (round == 0) ? 1'b1 : 1'b0; // On XOR avec la clef en début de phase de finalisation
            en_xor_key_end_input_s = (round == 11) ? 1'b1 : 1'b0; // On XOR avec la clef à la fin des 12 rondes (XOR final)
            @(posedge clock_input_s); // Attendre la fin du tour
        end

        en_xor_key_end_input_s = 1'b0; // On désactive le XOR

        en_out_tag_input_s = 1'b1; // On enregistre le tag après la 12ème ronde
        en_input_s = 1'b0; // On désactive l'écriture pour le banc de registre

        @(posedge clock_input_s); // Attendre la fin du tour

        en_out_tag_input_s = 1'b0; // On désactive l'écriture du tag

        // Fin de phase de Finalisation 

        // Affichage des résultats
        
        $display("Clé de chiffrement : %h", cipher_output_s);
        $display("Tag : %h", tag_output_s);

    end

endmodule
