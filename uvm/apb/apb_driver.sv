class apb_driver extends uvm_driver #(apb_seq_item);
    `uvm_component_utils(apb_driver)

    virtual apb_if vif;

    bit [31:0] default_prdata  = 32'hA5A5_A5A5;
    int        default_delay   = 0;
    bit        default_pslverr = 0;

    bit        random_response_mode = 0;
    int        rand_delay_max       = 5;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
            `uvm_fatal("APB_DRV", "No vif found")
    endfunction

    task run_phase(uvm_phase phase);
        apb_seq_item it;
        bit [31:0]   cap_addr;
        bit          cap_write;
        bit [31:0]   cap_wdata;

        vif.PRDATA  <= 0;
        vif.PREADY  <= 0;
        vif.PSLVERR <= 0;

        wait (vif.PRESETn === 1'b1);
        @(posedge vif.PCLK);

        forever begin
            // Wait for APB transfer start
            do @(posedge vif.PCLK);
            while (!(vif.PSEL === 1'b1 && vif.PENABLE === 1'b1));

            cap_addr  = vif.PADDR;
            cap_write = vif.PWRITE;
            cap_wdata = vif.PWDATA;

            if (seq_item_port.has_do_available()) begin
                seq_item_port.get_next_item(it);
            end else begin
                it = apb_seq_item::type_id::create("default_apb");
                if (random_response_mode) begin
                    it.prdata       = $urandom();
                    it.pready_delay = $urandom_range(0, rand_delay_max);
                    it.pslverr      = ($urandom_range(0,9) < 3) ? 1'b1 : 1'b0;
                end else begin
                    it.prdata       = default_prdata;
                    it.pready_delay = default_delay;
                    it.pslverr      = default_pslverr;
                end
            end

            // Insert wait states
            repeat (it.pready_delay) begin
                vif.PREADY <= 0;
                @(posedge vif.PCLK);
            end

            // Complete transfer
            vif.PRDATA  <= it.prdata;
            vif.PSLVERR <= it.pslverr;
            vif.PREADY  <= 1;
            @(posedge vif.PCLK);

            vif.PREADY  <= 0;
            vif.PRDATA  <= 0;
            vif.PSLVERR <= 0;

            it.cap_addr  = cap_addr;
            it.cap_write = cap_write;
            it.cap_wdata = cap_wdata;

            if (seq_item_port.has_do_available())
                seq_item_port.item_done();
        end
    endtask
endclass