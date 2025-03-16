// Test Bench du module FSM 
// Ibrahim HADJ-ARAB
// 2 Mai 2024

`timescale 1ns/1ps

import ascon_pack::*;

module ascon_top_tb ();

// Signaux interconnexion
    logic clock_s = 1'b0, resetb_s;
    logic [63:0] data_s;
    logic [63:0] P1_s;
    logic [63:0] P2_s;
    logic [63:0] P3_s;
    logic data_valid_s;
    logic [127:0] key_s;
    logic [127:0] nonce_s;
    logic start_s;

    logic [63:0] cipher_s;
    logic cipher_valid_s;
    logic [127:0] tag_s;
    logic end_s;

// DUT
    ascon_top DUT (
        .clock_i(clock_s),
        .resetb_i(resetb_s),
        .data_i(data_s),
        .data_valid_i(data_valid_s),
        .key_i(key_s),
        .nonce_i(nonce_s),
        .start_i(start_s),

        .cipher_o(cipher_s),
        .tag_o(tag_s),
        .cipher_valid_o(cipher_valid_s),
        .end_o(end_s)
    );


// Stimuli du test bench

    // Horloge
    always begin
        #10;
        assign clock_s = ~clock_s;
    end

    // Gestion du reset et du start
    initial
    begin
        start_s = 1'b0;
        resetb_s = 1'b0;
        data_valid_s = 1'b0;

        // Initialisation de l'état avec IV, K et N
        data_s = 64'h80400C0600000000; // IV
        key_s = 128'h8a55114d1cb6a9a2be263d4d7aecaaff; // K
        nonce_s = 128'h4ed0ec0b98c529b7c8cddf37bcd0284a; // N

        P1_s = 64'h5244562061752054;
        P2_s = 64'h6927626172206365;
        P3_s = 64'h20736f6972203f80;

        #2;
        resetb_s = 1'b1;
        
        #18;
        start_s = 1'b1;
        data_valid_s = 1'b1;

        #20;
        start_s = 1'b0;

        #260;

        data_s = 64'h4120746f20428000; // A1
        #20;

        data_valid_s = 1'b1;
        #20;

        data_valid_s = 1'b0;
        #100; // Avant c'était à 20

        data_s = P1_s; // P1
        #20;

        data_valid_s = 1'b1;
        #60;

        data_valid_s = 1'b0;
        #70;

        data_s = P2_s; // P2
        #20;

        data_valid_s = 1'b1;
        #20;

        data_valid_s = 1'b0;
        #110;

        data_s = P3_s; // P3
        #20;

        data_valid_s = 1'b1;
        #20;

        data_valid_s = 1'b0;
        #20;

     

    end

endmodule : ascon_top_tb
