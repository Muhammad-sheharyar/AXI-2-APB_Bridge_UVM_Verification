bash
```
axi2apb_uvm_verification/
├── rtl/
│   ├── axi2apb.sv
│   ├── axi_aw_buffer.sv
│   ├── axi_ar_buffer.sv
│   ├── axi_w_buffer.sv
│   ├── axi_r_buffer.sv
│   ├── axi_b_buffer.sv
│   ├── axi_single_slice.sv
│   ├── fifo.sv
│   └── reference/         (axi_slice*, axi2apb_wrap, axi2apb_64_32 — NOT compiled)
├── tb/
│   ├── axi_if.sv
│   ├── apb_if.sv
│   └── tb_top.sv
├── uvm/
│   ├── axi/
│   │   ├── axi_seq_item.sv
│   │   ├── axi_sequencer.sv
│   │   ├── axi_driver.sv
│   │   ├── axi_monitor.sv
│   │   └── axi_agent.sv
│   ├── apb/
│   │   ├── apb_seq_item.sv
│   │   ├── apb_sequencer.sv
│   │   ├── apb_driver.sv
│   │   ├── apb_monitor.sv
│   │   └── apb_agent.sv
│   └── env/
│       ├── axi2apb_scoreboard.sv
│       ├── axi2apb_coverage.sv
│       └── axi2apb_env.sv
├── sequences/
│   ├── axi_write_seq.sv
│   └── axi_read_seq.sv
├── tests/
│   ├── axi2apb_base_test.sv
│   ├── reset_test.sv
│   ├── axi_write_ready_test.sv
│   ├── axi_read_ready_test.sv
│   ├── axi_write_wait_test.sv
│   ├── axi_read_wait_test.sv
│   ├── bready_delay_test.sv
│   ├── rready_delay_test.sv
│   ├── rd_wr_priority_test.sv
│   ├── bk2bk_read_test.sv
│   ├── bk2bk_write_test.sv
│   ├── mixed_traffic_test.sv
│   ├── id_user_test.sv
│   ├── pslverr_test.sv
│   └── rand_test.sv
├── assertions/
│   └── axi2apb_sva.sv
├── coverage/              (coverage class lives in uvm/env — folder kept per spec)
├── sim/
│   ├── Makefile
│   ├── filelist.f
│   └── out/
├── scripts/
├── docs/
├── logs/
├── results/
├── README.md
└── .gitignore
``
