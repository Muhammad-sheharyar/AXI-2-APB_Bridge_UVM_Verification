package axi2apb_tb_uvm_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

// AXI Agent
`include "axi_seq_item.sv"
`include "axi_sequencer.sv"
`include "axi_driver.sv"
`include "axi_monitor.sv"
`include "axi_agent.sv"

// APB Agent
`include "apb_seq_item.sv"
`include "apb_sequencer.sv"
`include "apb_driver.sv"
`include "apb_monitor.sv"
`include "apb_agent.sv"

// Environment
`include "axi2apb_scoreboard.sv"
`include "axi2apb_coverage.sv"
`include "axi2apb_env.sv"

// Sequences
`include "axi_write_seq.sv"
`include "axi_read_seq.sv"
`include "axi_single_item_seq.sv"
`include "axi_random_seq.sv"

// Tests
`include "axi2apb_base_test.sv"
`include "reset_test.sv"
`include "axi_write_ready_test.sv"
`include "axi_read_ready_test.sv"
`include "axi_write_wait_test.sv"
`include "axi_read_wait_test.sv"
`include "bready_delay_test.sv"
`include "rready_delay_test.sv"
`include "rd_wr_priority_test.sv"
`include "bk2bk_read_test.sv"
`include "bk2bk_write_test.sv"
`include "mixed_traffic_test.sv"
`include "id_user_test.sv"
`include "pslverr_test.sv"
`include "rand_test.sv"
`include "rand_axi_test.sv"
`include "rand_mixed_test.sv"
`include "coverage_closure_test.sv"

endpackage