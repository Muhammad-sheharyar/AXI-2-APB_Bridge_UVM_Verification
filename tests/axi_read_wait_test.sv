class axi_read_wait_test extends axi2apb_base_test;
    `uvm_component_utils(axi_read_wait_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_read_seq seq;
        phase.raise_objection(this);
        set_apb_default(32'hBEEF_0002, 4, 0);  // 4 wait states

        seq = axi_read_seq::type_id::create("seq");
        seq.num_reads = 2;
        seq.base_addr = 32'h0000_4000;
        seq.start(env.axi_agt.sqr);

        #600ns;
        phase.drop_objection(this);
    endtask
endclass