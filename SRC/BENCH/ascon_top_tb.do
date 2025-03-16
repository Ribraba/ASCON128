-- Automatisation du ascon_top Test Bench
-- Ibrahim HADJ-ARAB
-- 14 Mai 2024 

add wave -position insertpoint  \
sim:/ascon_top_tb/DUT/start_i \
sim:/ascon_top_tb/DUT/resetb_i \
sim:/ascon_top_tb/DUT/clock_i \
sim:/ascon_top_tb/DUT/data_valid_i\
sim:/ascon_top_tb/DUT/data_i\
sim:/ascon_top_tb/DUT/nonce_i \
sim:/ascon_top_tb/DUT/key_i \
sim:/ascon_top_tb/DUT/cipher_valid_o \
sim:/ascon_top_tb/DUT/end_o \
sim:/ascon_top_tb/DUT/cipher_o \
sim:/ascon_top_tb/DUT/tag_o \
sim:/ascon_top_tb/DUT/state_mode_s \
sim:/ascon_top_tb/DUT/round_s \
sim:/ascon_top_tb/DUT/en_xor_key_begin_s \
sim:/ascon_top_tb/DUT/en_xor_data_begin_s \
sim:/ascon_top_tb/DUT/en_xor_key_end_s \
sim:/ascon_top_tb/DUT/en_xor_lsb_end_s \
sim:/ascon_top_tb/DUT/en_reg_state_s \
sim:/ascon_top_tb/DUT/round_s \
sim:/ascon_top_tb/DUT/en_cipher_s \
sim:/ascon_top_tb/DUT/en_tag_s \
sim:/ascon_top_tb/DUT/en_cpt_round_s \
sim:/ascon_top_tb/DUT/init_p6_s \
sim:/ascon_top_tb/DUT/init_p12_s \
sim:/ascon_top_tb/DUT/en_cpt_block_s \
sim:/ascon_top_tb/DUT/init_cpt_block_s \
sim:/ascon_top_tb/DUT/FSM_inst/current_state \

run 1060 ns
