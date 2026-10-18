class rd_wr_priority_test extends axi2apb_base_test;
    `uvm_component_utils(rd_wr_priority_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_read_seq  rseq;
        axi_write_seq wseq;
        phase.raise_objection(this);
        set_apb_default(32'hF00D_0001, 0, 0);

        rseq = axi_read_seq::type_id::create("rseq");
        wseq = axi_write_seq::type_id::create("wseq");
        rseq.num_reads = 1;
        wseq.num_writes = 1;
        rseq.base_addr = 32'h0000_7000;
        wseq.base_addr = 32'h0000_7004;

        fork
            rseq.start(env.axi_agt.sqr);
            wseq.start(env.axi_agt.sqr);
        join

        #600ns;
        phase.drop_objection(this);
    endtask
endclass