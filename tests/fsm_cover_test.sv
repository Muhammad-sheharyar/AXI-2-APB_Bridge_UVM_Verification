class fsm_cover_test extends axi2apb_base_test;
    `uvm_component_utils(fsm_cover_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_seq_item        it;
        axi_single_item_seq seq;
        
        phase.raise_objection(this);

        `uvm_info("TEST", "fsm_cover_test: Hitting all FSM transitions", UVM_LOW)

        // 1. IDLE -> SEND_B_RESP (Write with immediate APB ready)
        set_apb_default(32'h1111_1111, 0, 0);
        it = axi_seq_item::type_id::create("w_direct");
        it.kind = axi_seq_item::AXI_WRITE; 
        it.addr = 32'h0000_1000; 
        it.bready_delay = 0;
        seq = axi_single_item_seq::type_id::create("seq1");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 2. IDLE -> WAIT_W_PREADY -> SEND_B_RESP (Write with delayed APB)
        set_apb_default(32'h2222_2222, 3, 0);
        it = axi_seq_item::type_id::create("w_wait");
        it.kind = axi_seq_item::AXI_WRITE; 
        it.addr = 32'h0000_1004; 
        it.bready_delay = 0;
        seq = axi_single_item_seq::type_id::create("seq2");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 3. IDLE -> DONE_SINGLE_RD (Read with immediate APB ready)
        set_apb_default(32'h3333_3333, 0, 0);
        it = axi_seq_item::type_id::create("r_direct");
        it.kind = axi_seq_item::AXI_READ; 
        it.addr = 32'h0000_2000; 
        it.rready_delay = 0;
        seq = axi_single_item_seq::type_id::create("seq3");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 4. IDLE -> WAIT_R_PREADY -> DONE_SINGLE_RD (Read with delayed APB)
        set_apb_default(32'h4444_4444, 3, 0);
        it = axi_seq_item::type_id::create("r_wait");
        it.kind = axi_seq_item::AXI_READ; 
        it.addr = 32'h0000_2004; 
        it.rready_delay = 0;
        seq = axi_single_item_seq::type_id::create("seq4");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 5. SEND_B_RESP self-loop (Write with BREADY delayed)
        set_apb_default(32'h5555_5555, 0, 0);
        it = axi_seq_item::type_id::create("w_bdelay");
        it.kind = axi_seq_item::AXI_WRITE; 
        it.addr = 32'h0000_1008; 
        it.bready_delay = 3; // BREADY low for 3 cycles
        seq = axi_single_item_seq::type_id::create("seq5");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 6. DONE_SINGLE_RD self-loop (Read with RREADY delayed)
        set_apb_default(32'h6666_6666, 0, 0);
        it = axi_seq_item::type_id::create("r_rdelay");
        it.kind = axi_seq_item::AXI_READ; 
        it.addr = 32'h0000_2008; 
        it.rready_delay = 3; // RREADY low for 3 cycles
        seq = axi_single_item_seq::type_id::create("seq6");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 7. WAIT_W_PREADY self-loop + SEND_B_RESP (APB delay 5 + BREADY delay 2)
        set_apb_default(32'h7777_7777, 5, 0);
        it = axi_seq_item::type_id::create("w_full_wait");
        it.kind = axi_seq_item::AXI_WRITE; 
        it.addr = 32'h0000_100C; 
        it.bready_delay = 2;
        seq = axi_single_item_seq::type_id::create("seq7");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        // 8. WAIT_R_PREADY self-loop + DONE_SINGLE_RD (APB delay 5 + RREADY delay 2)
        set_apb_default(32'h8888_8888, 5, 0);
        it = axi_seq_item::type_id::create("r_full_wait");
        it.kind = axi_seq_item::AXI_READ; 
        it.addr = 32'h0000_200C; 
        it.rready_delay = 2;
        seq = axi_single_item_seq::type_id::create("seq8");
        seq.item = it;
        seq.start(env.axi_agt.sqr);

        #2000ns;
        phase.drop_objection(this);
    endtask
endclass