class axi_driver extends uvm_driver #(axi_seq_item);
    `uvm_component_utils(axi_driver)

    virtual axi_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi_if)::get(this, "", "vif", vif))
            `uvm_fatal("AXI_DRV", "No vif found")
    endfunction

    task run_phase(uvm_phase phase);
        // Idle
        vif.AWVALID <= 0; vif.WVALID <= 0; vif.ARVALID <= 0;
        vif.BREADY  <= 0; vif.RREADY <= 0;
        vif.AWID <= 0; vif.AWADDR <= 0; vif.AWLEN <= 0;
        vif.AWSIZE <= 3'b010; vif.AWBURST <= 2'b01; vif.AWLOCK <= 0;
        vif.AWCACHE <= 0; vif.AWPROT <= 0; vif.AWREGION <= 0;
        vif.AWUSER <= 0; vif.AWQOS <= 0;
        vif.WDATA <= 0; vif.WSTRB <= 4'hF; vif.WLAST <= 1; vif.WUSER <= 0;
        vif.ARID <= 0; vif.ARADDR <= 0; vif.ARLEN <= 0;
        vif.ARSIZE <= 3'b010; vif.ARBURST <= 2'b01; vif.ARLOCK <= 0;
        vif.ARCACHE <= 0; vif.ARPROT <= 0; vif.ARREGION <= 0;
        vif.ARUSER <= 0; vif.ARQOS <= 0;

        wait (vif.ARESETn === 1'b1);
        repeat (2) @(posedge vif.ACLK);

        forever begin
            seq_item_port.get_next_item(req);
            if (req.kind == axi_seq_item::AXI_WRITE) drive_write(req);
            else                                     drive_read(req);
            seq_item_port.item_done();
        end
    endtask

    task drive_write(axi_seq_item it);
    `uvm_info("AXI_DRV",
    $sformatf("Driving WRITE: addr=%h data=%h id=%h user=%h bready_delay=%0d",
              it.addr, it.data, it.id, it.user, it.bready_delay),
    UVM_LOW)
        fork
            begin : aw_chan
                @(posedge vif.ACLK);
                vif.AWID     <= it.id;
                vif.AWADDR   <= it.addr;
                vif.AWLEN    <= it.len;
                vif.AWSIZE   <= it.size;
                vif.AWBURST  <= it.burst;
                vif.AWLOCK   <= 0;
                vif.AWCACHE  <= 0;
                vif.AWPROT   <= 0;
                vif.AWREGION <= 0;
                vif.AWUSER   <= it.user;
                vif.AWQOS    <= 0;
                vif.AWVALID  <= 1;
                do @(posedge vif.ACLK);
                while (vif.AWREADY !== 1'b1);
                vif.AWVALID  <= 0;
            end
            begin : w_chan
                @(posedge vif.ACLK);
                vif.WDATA  <= it.data;
                vif.WSTRB  <= it.strb;
                vif.WLAST  <= it.last;
                vif.WUSER  <= it.user;
                vif.WVALID <= 1;
                do @(posedge vif.ACLK);
                while (vif.WREADY !== 1'b1);
                vif.WVALID <= 0;
            end
        join

        repeat (it.bready_delay) @(posedge vif.ACLK);
        vif.BREADY <= 1;
        do @(posedge vif.ACLK);
        while (vif.BVALID !== 1'b1);
        vif.BREADY <= 0;
    endtask

    task drive_read(axi_seq_item it);
    `uvm_info("AXI_DRV",
    $sformatf("Driving READ : addr=%h id=%h user=%h rready_delay=%0d",
              it.addr, it.id, it.user, it.rready_delay),
    UVM_LOW)
        @(posedge vif.ACLK);
        vif.ARID     <= it.id;
        vif.ARADDR   <= it.addr;
        vif.ARLEN    <= it.len;
        vif.ARSIZE   <= it.size;
        vif.ARBURST  <= it.burst;
        vif.ARLOCK   <= 0;
        vif.ARCACHE  <= 0;
        vif.ARPROT   <= 0;
        vif.ARREGION <= 0;
        vif.ARUSER   <= it.user;
        vif.ARQOS    <= 0;
        vif.ARVALID  <= 1;
        do @(posedge vif.ACLK);
        while (vif.ARREADY !== 1'b1);
        vif.ARVALID  <= 0;

        repeat (it.rready_delay) @(posedge vif.ACLK);
        vif.RREADY <= 1;
        do @(posedge vif.ACLK);
        while (vif.RVALID !== 1'b1);
        vif.RREADY <= 0;
    endtask
endclass