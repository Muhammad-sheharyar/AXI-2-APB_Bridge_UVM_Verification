class axi_seq_item extends uvm_sequence_item;
    typedef enum {AXI_WRITE, AXI_READ} kind_e;

    rand kind_e     kind;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit [15:0] id;
    rand bit [9:0]  user;
    rand bit [7:0]  len;
    rand bit [2:0]  size;
    rand bit [1:0]  burst;
    rand bit [3:0]  strb;
    rand bit        last;

    // Response fields (filled by monitor)
    bit [31:0] rdata;
    bit [1:0]  resp;
    bit [15:0] rid;
    bit [9:0]  ruser;
    bit        rlast;

    // Backpressure controls (used by tests)
    rand int bready_delay;
    rand int rready_delay;

    `uvm_object_utils_begin(axi_seq_item)
        `uvm_field_enum(kind_e, kind, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(id,   UVM_ALL_ON)
        `uvm_field_int(user, UVM_ALL_ON)
        `uvm_field_int(len,  UVM_ALL_ON)
        `uvm_field_int(size, UVM_ALL_ON)
        `uvm_field_int(burst,UVM_ALL_ON)
        `uvm_field_int(strb, UVM_ALL_ON)
        `uvm_field_int(last, UVM_ALL_ON)
        `uvm_field_int(bready_delay, UVM_ALL_ON)
        `uvm_field_int(rready_delay, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="axi_seq_item");
        super.new(name);
        kind = AXI_WRITE;
        addr = 0; data = 0; id = 0; user = 0;
        len = 0; size = 3'b010; burst = 2'b01; strb = 4'hF; last = 1;
        bready_delay = 0;
        rready_delay = 0;
    endfunction

    constraint c_align { addr[1:0] == 2'b00; }

    // M9 — bias data toward interesting patterns
    constraint c_data_pattern {
        data dist {
            32'h0000_0000 := 5,
            32'hFFFF_FFFF := 5,
            32'hAAAA_AAAA := 5,
            32'h5555_5555 := 5,
            32'h0000_0001 := 3,
            32'h8000_0000 := 3,
            [32'h0000_0002 : 32'h7FFF_FFFF] :/ 37,
            [32'h8000_0001 : 32'hAAAA_AAA9] :/ 19,
            [32'hAAAA_AAAB : 32'hFFFF_FFFE] :/ 23
        };
    }

    // M9 — bias ID and USER values
    constraint c_id_user_pattern {
        id dist {
            16'h0000 := 20,
            16'hFFFF := 10,
            16'h0001 := 10,
            [16'h0002 : 16'hFFFE] :/ 60
        };
        user dist {
            10'h000 := 20,
            10'h3FF := 10,
            10'h001 := 10,
            [10'h002 : 10'h3FE] :/ 60
        };
    }

endclass