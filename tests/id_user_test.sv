class id_user_test extends axi2apb_base_test;
    `uvm_component_utils(id_user_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_seq_item        it;
        axi_single_item_seq seq;

        phase.raise_objection(this);
        set_apb_default(32'h1D_1234, 0, 0);

        // ---- Write with id=16'hABCD, user=10'h3FF ----
        it = axi_seq_item::type_id::create("w");
        it.kind = axi_seq_item::AXI_WRITE;
        it.addr = 32'h0000_C000;
        it.data = 32'hDEAD_BEEF;
        it.id   = 16'hABCD;
        it.user = 10'h3FF;
        it.bready_delay = 0;

        seq = axi_single_item_seq::type_id::create("w_seq");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // ---- Read with different id/user ----
        it = axi_seq_item::type_id::create("r");
        it.kind = axi_seq_item::AXI_READ;
        it.addr = 32'h0000_C004;
        it.id   = 16'h1234;
        it.user = 10'h155;
        it.rready_delay = 0;

        seq = axi_single_item_seq::type_id::create("r_seq");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        #400ns;
        phase.drop_objection(this);
    endtask
endclass