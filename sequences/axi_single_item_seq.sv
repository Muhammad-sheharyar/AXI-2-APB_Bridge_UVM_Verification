// Wrapper sequence that drives exactly one axi_seq_item.
// Use this when a test wants to send a pre-configured item
// (instead of randomizing inside a full sequence).
class axi_single_item_seq extends uvm_sequence #(axi_seq_item);
    `uvm_object_utils(axi_single_item_seq)

    axi_seq_item item;

    function new(string name="axi_single_item_seq");
        super.new(name);
    endfunction

    task body();
        if (item == null) begin
            `uvm_fatal("SINGLE_SEQ", "item not set before start()")
        end
        start_item(item);
        finish_item(item);
    endtask
endclass