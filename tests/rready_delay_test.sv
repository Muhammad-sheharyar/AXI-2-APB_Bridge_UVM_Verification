class rready_delay_test extends axi2apb_base_test;
    `uvm_component_utils(rready_delay_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_read_seq seq;
        phase.raise_objection(this);
        set_apb_default(32'hBEEF_0003, 0, 0);

        seq = axi_read_seq::type_id::create("seq");
        seq.num_reads    = 1;
        seq.base_addr    = 32'h0000_6000;
        seq.rready_delay = 5;
        seq.start(env.axi_agt.sqr);

        #400ns;
        phase.drop_objection(this);
    endtask
endclass