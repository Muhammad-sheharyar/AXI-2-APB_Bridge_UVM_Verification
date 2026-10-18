class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)

    virtual apb_if vif;
    uvm_analysis_port #(apb_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
            `uvm_fatal("APB_MON", "No vif found")
    endfunction

    task run_phase(uvm_phase phase);
        apb_seq_item it;
        bit in_xfer = 0;
        bit [31:0] cap_addr, cap_wdata;
        bit cap_write;
        int wait_cycles = 0;

        forever begin
            @(posedge vif.PCLK);

            if (vif.PRESETn !== 1'b1) begin
                in_xfer = 0;
                continue;
            end

            // Pehli dafa transfer detect hone par sirf setup karo, wait count nahi barhao
            if (!in_xfer && vif.PSEL === 1'b1 && vif.PENABLE === 1'b1) begin
                in_xfer = 1;
                wait_cycles = 0;
                cap_addr  = vif.PADDR;
                cap_write = vif.PWRITE;
                cap_wdata = vif.PWDATA;
            end
            // Agle cycles mein PREADY check karo (else if neeche wali condition same cycle mein nahi chalegi)
            else if (in_xfer && vif.PSEL === 1'b1 && vif.PENABLE === 1'b1) begin
                if (vif.PREADY === 1'b1) begin
                    it = apb_seq_item::type_id::create("apb_mon_item");
                    it.cap_addr  = cap_addr;
                    it.cap_write = cap_write;
                    it.cap_wdata = cap_wdata;
                    it.paddr     = cap_addr;
                    it.pwrite    = cap_write;
                    it.pwdata    = cap_wdata;
                    it.prdata    = vif.PRDATA;
                    it.pslverr   = vif.PSLVERR;
                    it.pready_delay = wait_cycles; // Ab imm=0 properly capture hoga
                    ap.write(it);
                    in_xfer = 0;
                end else begin
                    wait_cycles++; // Sirf tab barhao jab waqai wait state ho
                end
            end
        end
    endtask
endclass