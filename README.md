##  UVM Verification Architecture

The following diagram illustrates the dual-agent UVM environment, showing how the AXI Master Agent drives stimulus into the `axi2apb` DUT, which then translates and communicates with the APB Slave Agent. Both monitors send observed transactions to the Scoreboard for comparison.

+---------------------------------------------------------------------------------------+
|                               UVM TESTBENCH ENVIRONMENT                              |
|                                                                                       |
|   +----------------+                                            +-----------------+   |
|   |   AXI AGENT    |                                            |   APB AGENT     |   |
|   |  (AXI Master)  |                                            |   (APB Slave)   |   |
|   |                |                                            |                 |   |
|   |  [Sequences]   |                                            |  [Sequences]    |   |
|   |       |        |                                            |       |         |   |
|   |       v        |                                            |       v         |   |
|   |  [Sequencer]   |                                            |  [Sequencer]    |   |
|   |       |        |                                            |       |         |   |
|   |       v        |                                            |       v         |   |
|   |  [AXI Driver]  |                                            |  [APB Driver]   |   |
|   +------+---------+                                            +--------+--------+   |
|          |                                                               |            |
|          |                                                               |            |
|          v (Drives Signals)                             (Drives Signals) v            |
|   +------+---------+                                            +--------+--------+   |
|   |  AXI Interface |                                            |  APB Interface  |   |
|   +------+---------+                                            +--------+--------+   |
|          |                                                               |            |
+----------|---------------------------------------------------------------|------------+
           |                                                               |
           | (AXI4 Signals)                                  (APB Signals) | 
           v                                                               v
      +----+---------------------------------------------------------------+----+
      |                                                                         |
      |                                axi2apb DUT                              |
      |                          (Design Under Verification)                    |
      |                                                                         |
      +----+---------------------------------------------------------------+----+
           |                                                               |
           |                                                               |
+----------|---------------------------------------------------------------|------------+
|          | (Monitors)                                                    | (Monitors) |
|          v                                                               v            |
|   +------+---------+                                            +--------+--------+   |
|   |  AXI Monitor   |                                            |   APB Monitor   |   |
|   +------+---------+                                            +--------+--------+   |
|          |                                                               |            |
|   (TLM Analysis Port)                                           (TLM Analysis Port)   |
|          |                                                               |            |
|          +--------------------------+               +--------------------+            |
|                                     |               |                                 |
|                                     v               v                                 |
|                        +--------------------------------------+                       |
|                        |              Scoreboard              |                       |
|                        |  (Compares AXI and APB Transactions) |                       |
|                        +------------------+-------------------+                       |
|                                           |                                           |
|                                           v                                           |
|                        +--------------------------------------+                       |
|                        |          Coverage Collector          |                       |
|                        +--------------------------------------+                       |
|                                                                                       |
+---------------------------------------------------------------------------------------+

## 📂 Repository Structure
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
│   └── reference/         (axi_slice*, axi2apb_wrap, axi2apb_64_32)
|
├── tb/
│   ├── axi_if.sv
│   ├── apb_if.sv
|   ├── axi2apb_tb_uvm_pkg.sv
│   └── tb_top.sv
|
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
|
├── sequences/
│   ├── axi_write_seq.sv
|   ├── axi_read_seq.sv
|   ├── axi_random_seq.sv
|   ├── axi2apb_vseq.sv
│   └── axi_single_item_seq.sv
|
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
|   ├── coverage_closure_test.sv
|   ├── rand_axi_test.sv
|   ├── rand_mixed_test.sv
│   └── rand_test.sv
|
├── assertions/
│   └── (Not performed)
|
├──sim/
|   ├── Makefile          ← stays
|   ├── build.flist       ← stays
|   └── out/              ← everything generated goes here
|    ├── simv
|    ├── simv.daidir/
|    ├── csrc/
|    ├── ucli.key
|    ├── vc_hdrs.h
|    ├── tr_db.log
|    ├── cov_db/       (coverage databases)
|   
├── scripts/
|     ├── parse_log.py
|
├── docs/
|    ├── AXI2APB_UVM_Final_Project_Specification
|    ├── Verification_Plan
|    ├── AXI2APB_Bridge_UVM_Verification_PPT
|
├── logs/
|    ├── contain log file of all tests
|
├── results/
|     ├── regression_summary
|     ├── coverage_summary
|
├── README.md
└── .gitignore
      ├── simv
      ├── simv.daidir/
      ├── csrc/
      ├── ucli.key
      ├── vc_hdrs.h
      ├── tr_db.log
``

cd sim

# 1. Compile
make compile

# 2. Run one test
make sim TEST=reset_test
make sim TEST=axi_write_ready_test
make sim TEST=axi_read_wait_test

# 3. Run full directed + random regression
make regression

# 4. GUI (for waveform debug)
make sim_gui TEST=axi_write_ready_test

# 5. All Clean
make allclean
