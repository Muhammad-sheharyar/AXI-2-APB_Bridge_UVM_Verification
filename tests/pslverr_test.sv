class pslverr_test extends axi2apb_base_test;
    `uvm_component_utils(pslverr_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_write_seq wseq;
        axi_read_seq  rseq;
        phase.raise_objection(this);
        // PSLVERR=1 — DUT should still return OKAY (documented behavior)
        set_apb_default(32'hDEAD_0000, 0, 1);

        wseq = axi_write_seq::type_id::create("wseq");
        wseq.num_writes = 1;
        wseq.base_addr  = 32'h0000_D000;
        wseq.start(env.axi_agt.sqr);

        rseq = axi_read_seq::type_id::create("rseq");
        rseq.num_reads = 1;
        rseq.base_addr = 32'h0000_D004;
        rseq.start(env.axi_agt.sqr);

        `uvm_info("TEST", "PSLVERR=1 was driven. Scoreboard expects OKAY (DUT ignores PSLVERR).", UVM_LOW)
        #400ns;
        phase.drop_objection(this);
    endtask
endclass