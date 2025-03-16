-- Automatisation du permutation_xor Test Bench
-- Ibrahim HADJ-ARAB
-- 14 Mai 2024 

add wave -position insertpoint  \
sim:/permutation_xor_tb/DUT/cipher_o \
sim:/permutation_xor_tb/DUT/clock_i \
sim:/permutation_xor_tb/DUT/cst_to_sub_s \
sim:/permutation_xor_tb/DUT/data_i \
sim:/permutation_xor_tb/DUT/en_i \
sim:/permutation_xor_tb/DUT/en_out_cipher_i \
sim:/permutation_xor_tb/DUT/en_out_tag_i \
sim:/permutation_xor_tb/DUT/en_xor_data_i \
sim:/permutation_xor_tb/DUT/en_xor_key_begin_i \
sim:/permutation_xor_tb/DUT/en_xor_key_end_i \
sim:/permutation_xor_tb/DUT/en_xor_lsb_i \
sim:/permutation_xor_tb/DUT/key_i \
sim:/permutation_xor_tb/DUT/lim_to_xor_end_s \
sim:/permutation_xor_tb/DUT/mux_to_state_s \
sim:/permutation_xor_tb/DUT/reset_i \
sim:/permutation_xor_tb/DUT/resetb_i \
sim:/permutation_xor_tb/DUT/round_i \
sim:/permutation_xor_tb/DUT/state_i \
sim:/permutation_xor_tb/DUT/state_mode_i \
sim:/permutation_xor_tb/DUT/state_s \
sim:/permutation_xor_tb/DUT/sub_to_lim_s \
sim:/permutation_xor_tb/DUT/tag_o \
sim:/permutation_xor_tb/DUT/xor_begin_perm_s \
sim:/permutation_xor_tb/DUT/xor_end_perm_s

run 880 ns
