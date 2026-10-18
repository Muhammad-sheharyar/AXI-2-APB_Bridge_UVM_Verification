class axi_write_wait_test extends axi2apb_base_test;
    `uvm_component_utils(axi_write_wait_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_write_seq seq;
        phase.raise_objection(this);
        set_apb_default(32'hCAFE_0002, 3, 0);  // 3 wait states

        seq = axi_write_seq::type_id::create("seq");
        seq.num_writes = 2;
        seq.base_addr  = 32'h0000_3000;
        seq.start(env.axi_agt.sqr);

        #500ns;
        phase.drop_objection(this);
    endtask
endclass