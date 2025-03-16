// FSM
//Gharbi Fares

`timescale 1 ns/ 1 ps

import ascon_pack::*;

module fsm (

  input logic clock_i,
  input logic resetb_i,
  input logic start_i,
  input logic data_valid_i,
  input logic [3:0] round_i,

  
  output logic en_reg_state_o,
  output logic en_tag_o,
  output logic cipher_valid_o,
  output logic end_o,
  output logic input_mode_i,

  output logic en_cpt_round,
  output logic en_cpt_2_o, // enable du compteur bloc qu'on n'utilisera pas 
  output logic init_p_6,
  output logic init_p_12,
  output logic init_cpt_2_o,// signal pour initialiser le compteur bloc 

  output logic bypass_xor_begin_o,
  output logic xor_end_bypass_o,
  output logic mode_ATC_F_xor_begin_o,
  output logic xor_end_mode_key_o
   );


   typedef enum {idle, conf_init, init_round, init_1_to_10, init_round_11, attente_da,da_round_6,da_7_to_10, da_round_11, attente_chiffrement_1, ch1_round_6, ch1_7_to_11, stop_counter_1, attente_chiffrement_2,ch2_round_6, ch2_7_to_11, stop_counter_2, attente_chiffrement_3, ch3_round_6, ch3_7_to_11, stop_counter_3, attente_chiffrement_4, ch4_chiffrement, finalisation_Xor, finalisation_1_to_11, finalisation_result} state_t;
   state_t current_state, next_state;

//Modélisation du registre des états

   always_ff  @(posedge clock_i or negedge resetb_i)
   begin : seq_0
       if (resetb_i == 0)
         begin 
          current_state <= idle;
         end
       else begin 
          current_state <= next_state;
         end
      
   end : seq_0


//Modélisation des transitions
   always_comb
   begin : comb_i

      case (current_state)
         idle :    if (start_i == 1'b1) 
                      next_state = conf_init;
                   else 
                      next_state = idle;


         conf_init: next_state = init_round;
         
         init_round : next_state = init_1_to_10;                   
         init_1_to_10 :   if (round_i == 4'hA) 
                             next_state = init_round_11;
                          else 
                             next_state = init_1_to_10;
                     
         init_round_11 : next_state = attente_da;  
         attente_da: if (data_valid_i == 1) 
                             next_state = da_round_6;
                          else 
                             next_state = attente_da;

         da_round_6: next_state = da_7_to_10;
 
         da_7_to_10: if (round_i == 4'hA) 
                             next_state = da_round_11;
                          else 
                             next_state = da_7_to_10;
    
          da_round_11: next_state = attente_chiffrement_1;
          attente_chiffrement_1:
                          if (data_valid_i == 1) 
                             next_state = ch1_round_6;
                          else 
                             next_state = attente_chiffrement_1;
          ch1_round_6: next_state = ch1_7_to_11;
          ch1_7_to_11:
                if (round_i == 4'hB) 
                   next_state = stop_counter_1;
                else 
                   next_state = ch1_7_to_11;
      
          stop_counter_1: next_state = attente_chiffrement_2;
          attente_chiffrement_2 : 
                          if (data_valid_i == 1) 
                             next_state = ch2_round_6;
                          else 
                             next_state = attente_chiffrement_2;
          ch2_round_6: next_state = ch2_7_to_11;
          ch2_7_to_11:
                if (round_i == 4'hB) 
                   next_state = stop_counter_2;
                else 
                   next_state = ch2_7_to_11;

          stop_counter_2: next_state = attente_chiffrement_3;
          attente_chiffrement_3 : 
                          if (data_valid_i == 1) 
                             next_state = ch3_round_6;
                          else 
                             next_state = attente_chiffrement_3;
          ch3_round_6 : next_state = ch3_7_to_11;
          ch3_7_to_11 : 
                       if (round_i == 4'hB) 
                          next_state = stop_counter_3;
                      else 
                          next_state = ch3_7_to_11;
          stop_counter_3 : next_state = attente_chiffrement_4;
          attente_chiffrement_4 : 
                      if (data_valid_i == 1) 
                             next_state = ch4_chiffrement;
                      else 
                             next_state = attente_chiffrement_4; 
          ch4_chiffrement: next_state = finalisation_Xor;
          finalisation_Xor : next_state = finalisation_1_to_11;
          finalisation_1_to_11 : 
                                 if (round_i == 4'hB) 
                                     next_state = finalisation_result;
                                 else 
                                     next_state = finalisation_1_to_11;
          finalisation_result : next_state = finalisation_result;
         default : next_state = idle;
      endcase; 
   end : comb_i 



  always_comb
   begin : comb_o
      case (current_state)
      // Initialisation
         idle : 
          begin
            
            en_reg_state_o = 1'b0;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b1;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b0;
           end

         conf_init : 
          begin
            
            en_reg_state_o = 1'b0;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b1;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b0;
           end

          init_round :
          begin
            
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b0;                 
           end

         init_1_to_10:  
          begin    
            
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;  
            input_mode_i = 1'b1;        
          end

         init_round_11: 
          begin 
            
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b0;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b1; 
            input_mode_i = 1'b1; 

          end 
      // Données associées
         attente_da : 
          begin
            
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b1;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1; 
          end
        da_round_6:
         begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b0;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b1;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
         
       
         end

        da_7_to_10:
         begin
           en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b1;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
         end
        da_round_11:
         begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b1;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b0;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
         end
 // Chiffrement Texte Claire
        attente_chiffrement_1:
         begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b1;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1;
         end 
  
      ch1_round_6:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b1;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b0;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b1;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;


        end
      ch1_7_to_11:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
        end
      stop_counter_1:
       begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1;


       end
      attente_chiffrement_2:
        begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b1;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1;
        end
      ch2_round_6:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b1;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b0;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b1;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;

        end
      ch2_7_to_11:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
       
        end
      stop_counter_2:
        begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1;
        end
      attente_chiffrement_3:
        begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b1;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1;
        end
      ch3_round_6 :
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b1;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b0;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b1;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;


        end
      ch3_7_to_11:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
        end

      stop_counter_3 : 
        begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1;

        end

      attente_chiffrement_4:
        begin
            en_reg_state_o = 1'b0;
            
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0; 
            input_mode_i = 1'b1; 
        end 
      ch4_chiffrement : 
        begin
            en_reg_state_o = 1'b0;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b1;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b1;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b0;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b1;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
        end 
  // Finalisation
      finalisation_Xor:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b1;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b0;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
        end  

      finalisation_1_to_11:
        begin
            en_reg_state_o = 1'b1;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b0;
            en_cpt_round = 1'b1;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
        end 
      finalisation_result:
           begin
            en_reg_state_o = 1'b0;
            
            en_tag_o = 1'b0;
            cipher_valid_o = 1'b0;
            end_o = 1'b1;
            en_cpt_round = 1'b0;
            init_p_6 = 1'b0;
            init_p_12 = 1'b0;
            en_cpt_2_o = 1'b0;
            init_cpt_2_o = 1'b0;
            bypass_xor_begin_o = 1'b1;
            xor_end_bypass_o = 1'b1;
            mode_ATC_F_xor_begin_o = 1'b0;
            xor_end_mode_key_o = 1'b0;
            input_mode_i = 1'b1;
           end
        endcase;
    end : comb_o;




endmodule fsm