class rand_test extends axi2apb_base_test;
    `uvm_component_utils(rand_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        axi_seq_item        it;
        axi_single_item_seq seq;

        phase.raise_objection(this);
        set_apb_default(32'hFFFF_0000, 1, 0);

        repeat (10) begin
            it = axi_seq_item::type_id::create("rand");
            if (!it.randomize() with {
                addr[1:0] == 2'b00;
                bready_delay inside {[0:3]};
                rready_delay inside {[0:3]};
            }) `uvm_error("TEST", "Randomize failed")

            seq = axi_single_item_seq::type_id::create("s");
            seq.item = it;
            seq.start(env.axi_agt.sqr);
        end

        #3000ns;
        phase.drop_objection(this);
    endtask
endclass