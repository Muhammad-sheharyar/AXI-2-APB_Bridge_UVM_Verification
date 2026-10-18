// `timescale 1ns/1ps

module tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // -------- Clock & Reset --------
    logic ACLK;
    logic ARESETn;
    logic test_en_i = 1'b0;

    initial begin
        ACLK = 1'b0;
        forever #5 ACLK = ~ACLK;   // 100 MHz
    end

    initial begin
        ARESETn = 1'b0;
        repeat (5) @(posedge ACLK);
        ARESETn = 1'b1;
        `uvm_info("TB_TOP", "Reset released", UVM_LOW)
    end

    // -------- Interfaces --------
    axi_if #(
        .ADDR_WIDTH (32),
        .DATA_WIDTH (32),
        .ID_WIDTH   (16),
        .USER_WIDTH (10)
    ) axi_vif (
        .ACLK    (ACLK),
        .ARESETn (ARESETn)
    );

    apb_if #(
        .ADDR_WIDTH (32),
        .DATA_WIDTH (32)
    ) apb_vif (
        .PCLK    (ACLK),
        .PRESETn (ARESETn)
    );

    // -------- DUT --------
    axi2apb #(
        .AXI4_ADDRESS_WIDTH (32),
        .AXI4_RDATA_WIDTH   (32),
        .AXI4_WDATA_WIDTH   (32),
        .AXI4_ID_WIDTH      (16),
        .AXI4_USER_WIDTH    (10),
        .AXI_NUMBYTES       (4),
        .BUFF_DEPTH_SLAVE   (4),
        .APB_ADDR_WIDTH     (32)
    ) dut (
        .ACLK     (ACLK),
        .ARESETn  (ARESETn),
        .test_en_i(test_en_i),

        // AW
        .AWID_i    (axi_vif.AWID),
        .AWADDR_i  (axi_vif.AWADDR),
        .AWLEN_i   (axi_vif.AWLEN),
        .AWSIZE_i  (axi_vif.AWSIZE),
        .AWBURST_i (axi_vif.AWBURST),
        .AWLOCK_i  (axi_vif.AWLOCK),
        .AWCACHE_i (axi_vif.AWCACHE),
        .AWPROT_i  (axi_vif.AWPROT),
        .AWREGION_i(axi_vif.AWREGION),
        .AWUSER_i  (axi_vif.AWUSER),
        .AWQOS_i   (axi_vif.AWQOS),
        .AWVALID_i (axi_vif.AWVALID),
        .AWREADY_o (axi_vif.AWREADY),

        // W
        .WDATA_i (axi_vif.WDATA),
        .WSTRB_i (axi_vif.WSTRB),
        .WLAST_i (axi_vif.WLAST),
        .WUSER_i (axi_vif.WUSER),
        .WVALID_i(axi_vif.WVALID),
        .WREADY_o(axi_vif.WREADY),

        // B
        .BID_o   (axi_vif.BID),
        .BRESP_o (axi_vif.BRESP),
        .BVALID_o(axi_vif.BVALID),
        .BUSER_o (axi_vif.BUSER),
        .BREADY_i(axi_vif.BREADY),

        // AR
        .ARID_i    (axi_vif.ARID),
        .ARADDR_i  (axi_vif.ARADDR),
        .ARLEN_i   (axi_vif.ARLEN),
        .ARSIZE_i  (axi_vif.ARSIZE),
        .ARBURST_i (axi_vif.ARBURST),
        .ARLOCK_i  (axi_vif.ARLOCK),
        .ARCACHE_i (axi_vif.ARCACHE),
        .ARPROT_i  (axi_vif.ARPROT),
        .ARREGION_i(axi_vif.ARREGION),
        .ARUSER_i  (axi_vif.ARUSER),
        .ARQOS_i   (axi_vif.ARQOS),
        .ARVALID_i (axi_vif.ARVALID),
        .ARREADY_o (axi_vif.ARREADY),

        // R
        .RID_o   (axi_vif.RID),
        .RDATA_o (axi_vif.RDATA),
        .RRESP_o (axi_vif.RRESP),
        .RLAST_o (axi_vif.RLAST),
        .RUSER_o (axi_vif.RUSER),
        .RVALID_o(axi_vif.RVALID),
        .RREADY_i(axi_vif.RREADY),

        // APB
        .PENABLE (apb_vif.PENABLE),
        .PWRITE  (apb_vif.PWRITE),
        .PADDR   (apb_vif.PADDR),
        .PSEL    (apb_vif.PSEL),
        .PWDATA  (apb_vif.PWDATA),
        .PRDATA  (apb_vif.PRDATA),
        .PREADY  (apb_vif.PREADY),
        .PSLVERR (apb_vif.PSLVERR)
    );

    // -------- UVM config + start --------
    initial begin
        uvm_config_db#(virtual axi_if)::set(null, "*", "vif", axi_vif);
        uvm_config_db#(virtual apb_if)::set(null, "*", "vif", apb_vif);
        run_test();
    end

    // -------- Wave dump (optional) --------
    // initial begin
    //     $dumpfile("out/axi2apb.vcd");
    //     $dumpvars(0, tb_top);
    // end
endmodule