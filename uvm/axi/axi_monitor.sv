class axi_monitor extends uvm_monitor;
    `uvm_component_utils(axi_monitor)

    virtual axi_if vif;
    uvm_analysis_port #(axi_seq_item) ap;
    axi_seq_item aw_q[$];
    axi_seq_item w_q[$];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("AXI_MON", "No vif found")
    endfunction

    task run_phase(uvm_phase phase);
        fork
            capture_aw();
            capture_w();
            capture_b_and_match();
            capture_read();
        join
    endtask

    task capture_aw();
        axi_seq_item it;
        forever begin
            @(posedge vif.ACLK);
            if (vif.ARESETn === 1'b1 && vif.AWVALID === 1'b1 && vif.AWREADY === 1'b1) begin
                it = axi_seq_item::type_id::create("aw_item");
                it.kind  = axi_seq_item::AXI_WRITE;
                it.addr  = vif.AWADDR;
                it.id    = vif.AWID;
                it.user  = vif.AWUSER;
                aw_q.push_back(it);
            end
        end
    endtask

    task capture_w();
        axi_seq_item it;
        forever begin
            @(posedge vif.ACLK);
            if (vif.ARESETn === 1'b1 && vif.WVALID === 1'b1 && vif.WREADY === 1'b1) begin
                it = axi_seq_item::type_id::create("w_item");
                it.data = vif.WDATA;
                it.strb = vif.WSTRB;
                it.last = vif.WLAST;
                w_q.push_back(it);
            end
        end
    endtask

    task capture_b_and_match();
        axi_seq_item aw;
        axi_seq_item w;
        int bdelay;
        forever begin
            wait (aw_q.size() > 0 && w_q.size() > 0);
            aw = aw_q.pop_front();
            w  = w_q.pop_front();
            aw.data = w.data; aw.strb = w.strb; aw.last = w.last;

            bdelay = 0;
            do @(posedge vif.ACLK); while (vif.BVALID !== 1'b1);
            
            // BREADY delay count karo
            while (vif.BVALID === 1'b1 && vif.BREADY !== 1'b1) begin
                bdelay++;
                @(posedge vif.ACLK);
            end
            
            if (vif.BVALID === 1'b1 && vif.BREADY === 1'b1) begin
                aw.resp  = vif.BRESP;
                aw.rid   = vif.BID;
                aw.ruser = vif.BUSER;
                aw.bready_delay = bdelay; // <--- Actual delay capture hui
                ap.write(aw);
            end
        end
    endtask

    task capture_read();
        axi_seq_item it;
        int rdelay;
        forever begin
            @(posedge vif.ACLK);
            if (vif.ARESETn === 1'b1 && vif.ARVALID === 1'b1 && vif.ARREADY === 1'b1) begin
                it = axi_seq_item::type_id::create("ar_item");
                it.kind  = axi_seq_item::AXI_READ;
                it.addr  = vif.ARADDR;
                it.id    = vif.ARID;
                it.user  = vif.ARUSER;

                rdelay = 0;
                do @(posedge vif.ACLK); while (vif.RVALID !== 1'b1);
                
                // RREADY delay count karo
                while (vif.RVALID === 1'b1 && vif.RREADY !== 1'b1) begin
                    rdelay++;
                    @(posedge vif.ACLK);
                end
                
                if (vif.RVALID === 1'b1 && vif.RREADY === 1'b1) begin
                    it.rdata = vif.RDATA;
                    it.resp  = vif.RRESP;
                    it.rid   = vif.RID;
                    it.ruser = vif.RUSER;
                    it.rlast = vif.RLAST;
                    it.rready_delay = rdelay; // <--- Actual delay capture hui
                    ap.write(it);
                end
            end
        end
    endtask
endclass