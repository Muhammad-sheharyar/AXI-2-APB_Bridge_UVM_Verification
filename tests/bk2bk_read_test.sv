class bk2bk_read_test extends axi2apb_base_test;
    `uvm_component_utils(bk2bk_read_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_read_seq seq;
        phase.raise_objection(this);
        set_apb_default(32'hA000_0000, 1, 0);

        seq = axi_read_seq::type_id::create("seq");
        seq.num_reads = 4;
        seq.base_addr = 32'h0000_8000;
        seq.start(env.axi_agt.sqr);

        #1500ns;
        phase.drop_objection(this);
    endtask
endclass