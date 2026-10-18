class axi2apb_vseq extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(axi2apb_vseq)

    `uvm_declare_p_sequencer(uvm_sequencer_base)

    // Handles set by test
    axi_sequencer axi_sqr;
    apb_sequencer apb_sqr;

    function new(string name="axi2apb_vseq");
        super.new(name);
    endfunction

    // Subclasses override this
    virtual task body();
    endtask

    // Helper: run a write transaction
    task do_write(bit [31:0] addr, bit [31:0] data,
                  bit [15:0] id = 16'h0, bit [9:0] user = 10'h0,
                  int bready_delay = 0);
        axi_seq_item it = axi_seq_item::type_id::create("wr");
        start_item(it, -1, axi_sqr);
        it.kind = axi_seq_item::AXI_WRITE;
        it.addr = addr; it.data = data; it.id = id; it.user = user;
        it.bready_delay = bready_delay;
        finish_item(it);
    endtask

    task do_read(bit [31:0] addr,
                 bit [15:0] id = 16'h0, bit [9:0] user = 10'h0,
                 int rready_delay = 0);
        axi_seq_item it = axi_seq_item::type_id::create("rd");
        start_item(it, -1, axi_sqr);
        it.kind = axi_seq_item::AXI_READ;
        it.addr = addr; it.id = id; it.user = user;
        it.rready_delay = rready_delay;
        finish_item(it);
    endtask

    // Configure APB driver's default response (through config_db)
    function void set_apb_default(bit [31:0] prdata, int delay, bit slverr);
        uvm_config_db#(bit [31:0])::set(null, "*apb_agt*drv*", "default_prdata", prdata);
        uvm_config_db#(int)::set(null, "*apb_agt*drv*", "default_delay", delay);
        uvm_config_db#(bit)::set(null, "*apb_agt*drv*", "default_pslverr", slverr);
    endfunction
endclass