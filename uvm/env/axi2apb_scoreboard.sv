`uvm_analysis_imp_decl(_axi)
`uvm_analysis_imp_decl(_apb)

class axi2apb_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi2apb_scoreboard)

    uvm_analysis_imp_axi #(axi_seq_item, axi2apb_scoreboard) axi_imp;
    uvm_analysis_imp_apb #(apb_seq_item, axi2apb_scoreboard) apb_imp;

    axi_seq_item axi_q[$];
    apb_seq_item apb_q[$];

    int num_checked = 0;
    int num_errors  = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        axi_imp = new("axi_imp", this);
        apb_imp = new("apb_imp", this);
    endfunction

    // ---- Called via uvm_analysis_imp_axi ----
    function void write_axi(axi_seq_item t);
        axi_q.push_back(t);
        try_match();
    endfunction

    // ---- Called via uvm_analysis_imp_apb ----
    function void write_apb(apb_seq_item t);
        apb_q.push_back(t);
        try_match();
    endfunction

    function void try_match();
        axi_seq_item a;
        apb_seq_item p;
        while (axi_q.size() > 0 && apb_q.size() > 0) begin
            a = axi_q.pop_front();
            p = apb_q.pop_front();
            check_pair(a, p);
        end
    endfunction

    // function void check_pair(axi_seq_item a, apb_seq_item p);
    //     num_checked++;
    //     if (a.kind == axi_seq_item::AXI_WRITE) begin
    //         if (p.cap_addr !== a.addr[31:0]) begin
    //             `uvm_error("SCB", $sformatf("WR addr mismatch APB=%h AXI=%h",
    //                        p.cap_addr, a.addr))
    //             num_errors++;
    //         end
    //         if (p.cap_write !== 1'b1) begin
    //             `uvm_error("SCB", "WR: PWRITE not 1")
    //             num_errors++;
    //         end
    //         if (p.cap_wdata !== a.data) begin
    //             `uvm_error("SCB", $sformatf("WR data mismatch APB=%h AXI=%h",
    //                        p.cap_wdata, a.data))
    //             num_errors++;
    //         end
    //         if (a.resp !== 2'b00) begin
    //             `uvm_error("SCB", $sformatf("WR: BRESP=%b expected OKAY", a.resp))
    //             num_errors++;
    //         end
    //     end else begin
    //         if (p.cap_addr !== a.addr[31:0]) begin
    //             `uvm_error("SCB", $sformatf("RD addr mismatch APB=%h AXI=%h",
    //                        p.cap_addr, a.addr))
    //             num_errors++;
    //         end
    //         if (p.cap_write !== 1'b0) begin
    //             `uvm_error("SCB", "RD: PWRITE not 0")
    //             num_errors++;
    //         end
    //         if (a.rdata !== p.prdata) begin
    //             `uvm_error("SCB", $sformatf("RD data mismatch AXI=%h APB=%h",
    //                        a.rdata, p.prdata))
    //             num_errors++;
    //         end
    //         if (a.resp !== 2'b00) begin
    //             `uvm_error("SCB", $sformatf("RD: RRESP=%b expected OKAY", a.resp))
    //             num_errors++;
    //         end
    //         if (a.rlast !== 1'b1) begin
    //             `uvm_error("SCB", "RD: RLAST not asserted")
    //             num_errors++;
    //         end
    //     end
    //     `uvm_info("SCB", $sformatf("Matched pair #%0d: kind=%s addr=%h",
    //               num_checked, a.kind.name(), a.addr), UVM_HIGH)
    // endfunction

    function void check_pair(axi_seq_item a, apb_seq_item p);
        num_checked++;

        if (a.kind == axi_seq_item::AXI_WRITE) begin
            // ---- WRITE ----
            `uvm_info("SCB",
                $sformatf("WRITE #%0d: AXI{AWADDR=%h WDATA=%h WSTRB=%h AWID=%h AWUSER=%h BRESP=%b BID=%h BUSER=%h} | APB{PADDR=%h PWDATA=%h PWRITE=%b}",
                          num_checked,
                          a.addr, a.data, a.strb, a.id, a.user, a.resp, a.rid, a.ruser,
                          p.cap_addr, p.cap_wdata, p.cap_write),
                UVM_LOW)

            if (p.cap_addr !== a.addr[31:0]) begin
                `uvm_error("SCB", $sformatf("WR addr mismatch APB=%h AXI=%h",
                           p.cap_addr, a.addr))
                num_errors++;
            end
            if (p.cap_write !== 1'b1) begin
                `uvm_error("SCB", "WR: PWRITE not 1")
                num_errors++;
            end
            if (p.cap_wdata !== a.data) begin
                `uvm_error("SCB", $sformatf("WR data mismatch APB=%h AXI=%h",
                           p.cap_wdata, a.data))
                num_errors++;
            end
            if (a.resp !== 2'b00) begin
                `uvm_error("SCB", $sformatf("WR: BRESP=%b expected OKAY", a.resp))
                num_errors++;
            end

        end else begin
            // ---- READ ----
            `uvm_info("SCB",
                $sformatf("READ  #%0d: AXI{ARADDR=%h ARID=%h ARUSER=%h RDATA=%h RRESP=%b RID=%h RUSER=%h RLAST=%b} | APB{PADDR=%h PRDATA=%h PWRITE=%b}",
                          num_checked,
                          a.addr, a.id, a.user, a.rdata, a.resp, a.rid, a.ruser, a.rlast,
                          p.cap_addr, p.prdata, p.cap_write),
                UVM_LOW)

            if (p.cap_addr !== a.addr[31:0]) begin
                `uvm_error("SCB", $sformatf("RD addr mismatch APB=%h AXI=%h",
                           p.cap_addr, a.addr))
                num_errors++;
            end
            if (p.cap_write !== 1'b0) begin
                `uvm_error("SCB", "RD: PWRITE not 0")
                num_errors++;
            end
            if (a.rdata !== p.prdata) begin
                `uvm_error("SCB", $sformatf("RD data mismatch AXI=%h APB=%h",
                           a.rdata, p.prdata))
                num_errors++;
            end
            if (a.resp !== 2'b00) begin
                `uvm_error("SCB", $sformatf("RD: RRESP=%b expected OKAY", a.resp))
                num_errors++;
            end
            if (a.rlast !== 1'b1) begin
                `uvm_error("SCB", "RD: RLAST not asserted")
                num_errors++;
            end
        end
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info("SCB", $sformatf("Total checked=%0d errors=%0d",
                  num_checked, num_errors), UVM_LOW)
        if (num_errors == 0 && num_checked > 0)
            `uvm_info("SCB", "*** SCOREBOARD PASS ***", UVM_LOW)
        else if (num_errors > 0)
            `uvm_error("SCB", "*** SCOREBOARD FAIL ***")
    endfunction
endclass