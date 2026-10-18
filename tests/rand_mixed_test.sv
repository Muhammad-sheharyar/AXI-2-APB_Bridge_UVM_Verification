class rand_mixed_test extends axi2apb_base_test;
    `uvm_component_utils(rand_mixed_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_random_seq seq_low;
        axi_random_seq seq_high;
        phase.raise_objection(this);

        env.apb_agt.drv.random_response_mode = 1;
        env.apb_agt.drv.rand_delay_max       = 8;

        `uvm_info("TEST", "rand_mixed_test: 2x50 random transactions in two address regions", UVM_LOW)

        seq_low  = axi_random_seq::type_id::create("seq_low");
        seq_high = axi_random_seq::type_id::create("seq_high");
        seq_low.num_txns    = 50;
        seq_low.addr_region = 0;   // low
        seq_high.num_txns    = 50;
        seq_high.addr_region = 2;  // high

        fork
            seq_low.start(env.axi_agt.sqr);
            seq_high.start(env.axi_agt.sqr);
        join

        #20000ns;
        phase.drop_objection(this);
    endtask
endclass