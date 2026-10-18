class apb_seq_item extends uvm_sequence_item;
    rand bit [31:0] paddr;
    rand bit        pwrite;
    rand bit [31:0] pwdata;
    rand bit [31:0] prdata;
    rand bit        pslverr;
    rand int        pready_delay;    // 0..N wait states

    // Captured by monitor
    bit [31:0] cap_addr;
    bit        cap_write;
    bit [31:0] cap_wdata;

    `uvm_object_utils_begin(apb_seq_item)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(prdata, UVM_ALL_ON)
        `uvm_field_int(pslverr, UVM_ALL_ON)
        `uvm_field_int(pready_delay, UVM_ALL_ON)
        `uvm_field_int(cap_addr, UVM_ALL_ON)
        `uvm_field_int(cap_write, UVM_ALL_ON)
        `uvm_field_int(cap_wdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="apb_seq_item");
        super.new(name);
        paddr=0; pwrite=0; pwdata=0; prdata=0; pslverr=0; pready_delay=0;
    endfunction

    constraint c_delay { pready_delay inside {[0:5]}; }
endclass