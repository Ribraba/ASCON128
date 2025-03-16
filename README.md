# SystemVerilog Implementation of the ASCON128 Encryption Algorithm

## Introduction

This project presents a simplified hardware implementation of the authenticated encryption algorithm ASCON128 using SystemVerilog. ASCON128 is an authenticated encryption algorithm with associated data (AEAD), built on a sponge construction designed to provide message confidentiality and integrity. The primary objective is to deliver a clear, efficient, and modular architecture implemented in SystemVerilog, a widely-used hardware description language (HDL) for digital design.

## Project Architecture

The overall architecture of ASCON128 comprises several interconnected SystemVerilog modules, each performing essential encryption and authentication operations:

- **Permutation Module**: Reversible transformations combining constant addition, substitution (S-box), diffusion, and XOR operations.
- **mux_state Module**: Multiplexer selecting inputs (IV, key K, nonce N) or internal states.
- **XOR_begin and XOR_end Modules**: Perform specific XOR operations at the start and end of algorithm phases.
- **state_register_w_en Module**: Conditional activation register maintaining internal algorithm states.
- **ascon_top Module**: Main interface linking all modules, managed by a finite state machine (FSM).

<img width="721" alt="Image" src="https://github.com/user-attachments/assets/32bbfcf8-adda-4f4a-b55a-22745032d708" />

## Detailed Module Description

### Permutation Module

Enforces confusion and diffusion through repeated transformations:

- **Constant Addition**: Adds round-specific constants to enhance security.
- **Substitution Layer (via S-box)**: Introduces essential cryptographic non-linearity.
- **Diffusion Layer**: Linearly propagates changes to maximize the impact of prior operations.

### mux_state Module

Selects inputs from either initial data or the permutation output based on internal control `data_sel_i`.

### XOR Modules

- **XOR_begin**: Performs XOR with key or data at the beginning of critical phases.
- **XOR_end**: Performs final XOR with the key or specific bit according to the algorithm stage.

## Finite State Machine (FSM)

The implemented FSM is Moore-type, structured around these phases:

- **Initialization**: Prepares internal states using IV, key, and nonce.
- **Associated Data**: Processes and authenticates associated data without encryption.
- **Plaintext**: Encrypts messages through specified transformations.
- **Finalization**: Produces final ciphertext and generates authentication tag.

The FSM was optimized by merging states to simplify complexity while maintaining structural clarity.

## Testing and Validation

Validation was conducted using ModelSim through multiple test benches, employing `.do` scripts to automate tests. To compile and simulate a specific test bench, remove the associated comment in the `compil_ascon.txt` file.

## Optimizations

Optimizations primarily focused on the FSM, reducing the number of states by using composite states (super-states) to enhance general efficiency and code readability.

## Project File Structure

```
ASCON128/
├── compil_ascon.txt
├── init_modelsim.txt
├── LIB/
│   ├── LIB_RTL/
│   └── LIB_BENCH/
├── modelsim.ini
└── SRC/
    ├── RTL/
    │   ├── ascon_pack.sv
    │   ├── ascon_sbox.sv
    │   ├── ascon_top.sv
    │   ├── compteur_double_init.sv
    │   ├── compteur_simple_init.sv
    │   ├── constant_addition.sv
    │   ├── diffusion_layer.sv
    │   ├── FSM_OPT.sv
    │   ├── FSM.sv
    │   ├── mux_state.sv
    │   ├── permutation_V1.sv
    │   ├── permutation_xor.sv
    │   ├── state_register_w_en.sv
    │   ├── substitution_layer.sv
    │   ├── xor_begin_perm.sv
    │   └── xor_end_perm.sv
    └── BENCH/
        ├── ascon_sbox_tb.sv
        ├── ascon_top_tb.do
        ├── ascon_top_tb.sv
        ├── constant_addition_tb.sv
        ├── diffusion_layer_tb.sv
        ├── permutation_V1_tb.sv
        ├── permutation_xor_step1_tb.sv
        ├── permutation_xor_tb.do
        ├── permutation_xor_tb.sv
        └── substitution_layer_tb.sv
```

## Compilation and Simulation Instructions with ModelSim

To compile and run simulations, follow these steps in ModelSim:

```shell
source init_modelsim.txt
source compil_ascon.txt
do ./SRC/BENCH/permutation_xor_tb.do
```
For further information on this project check the report `Rapport_ASCON.pdf` 
