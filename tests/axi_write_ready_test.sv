class axi_write_ready_test extends axi2apb_base_test;
    `uvm_component_utils(axi_write_ready_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_write_seq seq;
        phase.raise_objection(this);
        set_apb_default(32'hCAFE_0001, 0, 0);

        seq = axi_write_seq::type_id::create("seq");
        seq.num_writes = 1;
        seq.base_addr  = 32'h0000_1000;
        seq.start(env.axi_agt.sqr);

        #200ns;
        phase.drop_objection(this);
    endtask
endclass