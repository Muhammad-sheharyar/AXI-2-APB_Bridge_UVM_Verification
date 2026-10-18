class axi_write_seq extends uvm_sequence #(axi_seq_item);
    `uvm_object_utils(axi_write_seq)

    rand int unsigned num_writes = 1;
    rand bit [31:0]  base_addr    = 32'h0000_1000;
    rand int         bready_delay = 0;

    function new(string name="axi_write_seq");
        super.new(name);
    endfunction

    task body();
        axi_seq_item it;
        repeat (num_writes) begin
            it = axi_seq_item::type_id::create("wr");
            start_item(it);
            if (!it.randomize() with {
                kind == axi_seq_item::AXI_WRITE;
                addr == base_addr;
                bready_delay == local::bready_delay;
            }) `uvm_error("SEQ", "Randomize failed")
            finish_item(it);
            base_addr += 4;
        end
    endtask
endclass