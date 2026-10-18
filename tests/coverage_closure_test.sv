class coverage_closure_test extends axi2apb_base_test;
    `uvm_component_utils(coverage_closure_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_one(axi_seq_item::kind_e k, bit [31:0] addr, bit [31:0] data,
                 int bdelay, int rdelay, int apb_delay, bit slverr);
        axi_seq_item        it;
        axi_single_item_seq seq;

        // APB Driver ko exact delay aur PSLVERR batao
        set_apb_default(32'hA5A5_A5A5, apb_delay, slverr);

        it = axi_seq_item::type_id::create("it");
        it.kind = k;
        it.addr = addr;
        it.data = data;
        it.bready_delay = bdelay;
        it.rready_delay = rdelay;

        seq = axi_single_item_seq::type_id::create("seq");
        seq.item = it;
        seq.start(env.axi_agt.sqr);
    endtask

    task run_phase(uvm_phase phase);
        int delays[3];
        int i, j;
        
        delays[0] = 0;
        delays[1] = 1;
        delays[2] = 5;

        phase.raise_objection(this);

        // ========================================================
        // 1. APB Cross Coverage (12 explicit combinations)
        // ========================================================
        
        // --- WRITE Transactions ---
        run_one(axi_seq_item::AXI_WRITE, 32'h1000, 32'h1111_1111, 0, 0, 0, 0); // imm, low
        run_one(axi_seq_item::AXI_WRITE, 32'h1004, 32'h1111_1111, 0, 0, 0, 1); // imm, high
        run_one(axi_seq_item::AXI_WRITE, 32'h1008, 32'h1111_1111, 0, 0, 1, 0); // delay1, low
        run_one(axi_seq_item::AXI_WRITE, 32'h100C, 32'h1111_1111, 0, 0, 1, 1); // delay1, high
        run_one(axi_seq_item::AXI_WRITE, 32'h1010, 32'h1111_1111, 0, 0, 5, 0); // delay_multi, low
        run_one(axi_seq_item::AXI_WRITE, 32'h1014, 32'h1111_1111, 0, 0, 5, 1); // delay_multi, high

        // --- READ Transactions ---
        run_one(axi_seq_item::AXI_READ, 32'h2000, 32'h2222_2222, 0, 0, 0, 0); // imm, low
        run_one(axi_seq_item::AXI_READ, 32'h2004, 32'h2222_2222, 0, 0, 0, 1); // imm, high
        run_one(axi_seq_item::AXI_READ, 32'h2008, 32'h2222_2222, 0, 0, 1, 0); // delay1, low
        run_one(axi_seq_item::AXI_READ, 32'h200C, 32'h2222_2222, 0, 0, 1, 1); // delay1, high
        run_one(axi_seq_item::AXI_READ, 32'h2010, 32'h2222_2222, 0, 0, 5, 0); // delay_multi, low
        run_one(axi_seq_item::AXI_READ, 32'h2014, 32'h2222_2222, 0, 0, 5, 1); // delay_multi, high

        // ========================================================
        // 2. AXI Cross Coverage (BREADY/RREADY variations)
        // ========================================================
        for (i = 0; i < 3; i++) begin
            for (j = 0; j < 3; j++) begin
                run_one(axi_seq_item::AXI_WRITE, 32'h3000 + (i*10), 32'h3333_3333, delays[i], delays[j], 0, 0);
                run_one(axi_seq_item::AXI_READ,  32'h4000 + (i*10), 32'h4444_4444, delays[i], delays[j], 0, 0);
            end
        end

        // ========================================================
        // 3. Address & Data Coverage Bins
        // ========================================================
        run_one(axi_seq_item::AXI_WRITE, 32'h0000_0000, 32'h0000_0000, 0, 0, 0, 0);
        run_one(axi_seq_item::AXI_READ,  32'hFFFF_FFFC, 32'hFFFF_FFFF, 0, 0, 0, 0);
        run_one(axi_seq_item::AXI_WRITE, 32'h8000_0000, 32'hAAAA_AAAA, 0, 0, 0, 0);
        run_one(axi_seq_item::AXI_READ,  32'h7FFF_FFFC, 32'h5555_5555, 0, 0, 0, 0);
        run_one(axi_seq_item::AXI_WRITE, 32'h0000_0004, 32'h0000_0001, 0, 0, 0, 0); // walking 1

        #2000ns;
        phase.drop_objection(this);
    endtask
endclass