class bready_delay_test extends axi2apb_base_test;
    `uvm_component_utils(bready_delay_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_write_seq seq;
        phase.raise_objection(this);
        set_apb_default(32'hCAFE_0003, 0, 0);

        seq = axi_write_seq::type_id::create("seq");
        seq.num_writes    = 1;
        seq.base_addr     = 32'h0000_5000;
        seq.bready_delay  = 5;
        seq.start(env.axi_agt.sqr);

        #400ns;
        phase.drop_objection(this);
    endtask
endclass