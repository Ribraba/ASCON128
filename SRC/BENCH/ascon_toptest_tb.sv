`timescale 1 ns/ 1 ps

import ascon_pack::*;


module Ascon128_tb ();

    logic data_valid_i;
    logic clock_i= 1'b0;
    logic start_i;
    logic resetb_i;

    logic [63:0]data_i;    
    logic [127:0]key_i;
    logic [127:0]nonce_i;
    logic [63:0] cipher_o;
    logic [127:0] tag_o;
    
    logic end_o;
    logic cipher_valid_o;


   Ascon128 Ascon128_ins (
         .clock_i(clock_i),
         .data_valid_i(data_valid_i),
         .start_i(start_i),
         .resetb_i(resetb_i),
         .data_i(data_i),
         .key_i(key_i),
         .nonce_i(nonce_i),
         .end_o(end_o),
         .cipher_valid_o(cipher_valid_o),
         .cipher_o(cipher_o),
         .tag_o(tag_o)

   );
//On cadence l'horloge
   always begin
      forever #10 clock_i = ~clock_i;
      
   end
   initial begin

//On initialise les données d'entrées

      data_i = 64'h80400c0600000000;
      key_i = 128'h000102030405060708090A0B0C0D0E0F;
      nonce_i = 128'h00112233445566778899aabbccddeeff;
      data_i = 64'h0;
      resetb_i = 1'b0;
      data_valid_i = 1'b0;
      start_i = 1'b0;
      #100;
      resetb_i = 1'b1;
      #20;
      start_i = 1'b1;//On déclenche l'ASCON128
      #500;
      data_i = 64'h3230323380000000;
      #20;
      data_valid_i = 1;
      #20;
      data_valid_i = 0;   
      #40;

      data_i = 64'h436F6E636576657A;
      #20;
      data_valid_i = 1;
      #100;
      data_valid_i = 0;   
      #80;
      data_i = 64'h204153434F4E2065;
      #20;
      data_valid_i = 1;
      #100;
      data_valid_i = 0;   
      #80; 
      data_i = 64'h6E2053797374656D;
      #20;
      data_valid_i = 1;
      #100;
      data_valid_i = 0;   
      #80; 
      data_i = 64'h566572696C6F6780;
      #20;
      data_valid_i = 1;
      #100;
      data_valid_i = 0;   
      #80;
      
      
   end

endmodule : Ascon128_tb