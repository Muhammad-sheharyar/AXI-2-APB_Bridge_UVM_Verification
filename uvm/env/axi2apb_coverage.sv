`uvm_analysis_imp_decl(_axi_cov)
`uvm_analysis_imp_decl(_apb_cov)

class axi2apb_coverage extends uvm_component;
    `uvm_component_utils(axi2apb_coverage)

    uvm_analysis_imp_axi_cov #(axi_seq_item, axi2apb_coverage) axi_imp;
    uvm_analysis_imp_apb_cov #(apb_seq_item, axi2apb_coverage) apb_imp;

    axi_seq_item tr_axi;
    apb_seq_item tr_apb;

    // ==========================================
    // AXI Coverage Group
    // ==========================================
    covergroup cg_axi;
        cp_kind: coverpoint tr_axi.kind {
            bins wr = {axi_seq_item::AXI_WRITE};
            bins rd = {axi_seq_item::AXI_READ};
        }
        
        cp_addr: coverpoint tr_axi.addr {
            bins zero = {32'h0000_0000};
            bins low  = {[32'h0000_0001 : 32'h0000_FFFF]};
            bins mid  = {[32'h0001_0000 : 32'h7FFF_FFFF]};
            bins max  = {[32'h8000_0000 : 32'hFFFF_FFFC]};
        }
        
        cp_data: coverpoint tr_axi.data {
            bins zero = {32'h0000_0000};
            bins ones = {32'hFFFF_FFFF};
            bins alt1 = {32'hAAAA_AAAA};
            bins alt2 = {32'h5555_5555};
            bins walk1 = {32'h0000_0001, 32'h0000_0002, 32'h0000_0004, 32'h0000_0008};
            bins other = default;
        }
        
        cp_id: coverpoint tr_axi.id {
            bins zero = {16'h0000};
            bins ones = {16'hFFFF};
            bins other = default;
        }
        
        cp_user: coverpoint tr_axi.user {
            bins zero = {10'h000};
            bins ones = {10'h3FF};
            bins other = default;
        }
        
        cp_bready_bp: coverpoint tr_axi.bready_delay {
            bins imm = {0};
            bins delay1 = {[1:2]};
            bins delay_multi = {[3:10]};
        }
        
        cp_rready_bp: coverpoint tr_axi.rready_delay {
            bins imm = {0};
            bins delay1 = {[1:2]};
            bins delay_multi = {[3:10]};
        }
        
        // Cross coverage with ignored impossible bins
        cross cp_kind, cp_bready_bp, cp_rready_bp {
            // Ignore Write with RREADY delay (Impossible)
            ignore_bins wr_rrdy = binsof(cp_kind.wr) && 
                                  (binsof(cp_rready_bp.delay1) || binsof(cp_rready_bp.delay_multi));
            // Ignore Read with BREADY delay (Impossible)
            ignore_bins rd_brdy = binsof(cp_kind.rd) && 
                                  (binsof(cp_bready_bp.delay1) || binsof(cp_bready_bp.delay_multi));
        }
    endgroup

    // ==========================================
    // APB Coverage Group
    // ==========================================
    covergroup cg_apb;
        cp_pwrite: coverpoint tr_apb.pwrite {
            bins wr = {1};
            bins rd = {0};
        }
        
        cp_pready_delay: coverpoint tr_apb.pready_delay {
            bins imm = {0};
            bins delay1 = {[1:2]};
            bins delay_multi = {[3:10]};
        }
        
        cp_pslverr: coverpoint tr_apb.pslverr {
            bins low = {0};
            bins high = {1};
        }
        
        cross cp_pwrite, cp_pready_delay, cp_pslverr;
    endgroup

    function new(string name, uvm_component parent);
        super.new(name, parent);
        axi_imp = new("axi_imp", this);
        apb_imp = new("apb_imp", this);
        cg_axi = new();
        cg_apb = new();
    endfunction

    function void write_axi_cov(axi_seq_item t);
        tr_axi = t;
        cg_axi.sample();
    endfunction

    function void write_apb_cov(apb_seq_item t);
        tr_apb = t;
        cg_apb.sample();
    endfunction
endclass