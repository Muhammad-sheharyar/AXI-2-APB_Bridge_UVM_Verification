class axi_read_seq extends uvm_sequence #(axi_seq_item);
    `uvm_object_utils(axi_read_seq)

    rand int unsigned num_reads    = 1;
    rand bit [31:0]  base_addr     = 32'h0000_2000;
    rand int         rready_delay  = 0;

    function new(string name="axi_read_seq");
        super.new(name);
    endfunction

    task body();
        axi_seq_item it;
        repeat (num_reads) begin
            it = axi_seq_item::type_id::create("rd");
            start_item(it);
            if (!it.randomize() with {
                kind == axi_seq_item::AXI_READ;
                addr == base_addr;
                rready_delay == local::rready_delay;
            }) `uvm_error("SEQ", "Randomize failed")
            finish_item(it);
            base_addr += 4;
        end
    endtask
endclass