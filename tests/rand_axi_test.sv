class rand_axi_test extends axi2apb_base_test;
    `uvm_component_utils(rand_axi_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_random_seq seq;
        phase.raise_objection(this);

        // Enable per-transaction APB randomization
        env.apb_agt.drv.random_response_mode = 1;
        env.apb_agt.drv.rand_delay_max       = 5;

        `uvm_info("TEST", "rand_axi_test: 100 random AXI transactions", UVM_LOW)

        seq = axi_random_seq::type_id::create("seq");
        seq.num_txns    = 100;
        seq.addr_region = 3;    // wide
        seq.start(env.axi_agt.sqr);

        // Allow tail transactions to drain
        #20000ns;
        phase.drop_objection(this);
    endtask
endclass