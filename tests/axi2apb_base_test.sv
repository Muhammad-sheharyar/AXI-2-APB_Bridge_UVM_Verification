class axi2apb_base_test extends uvm_test;
    `uvm_component_utils(axi2apb_base_test)

    axi2apb_env env;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = axi2apb_env::type_id::create("env", this);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

    // Helper to set APB response defaults
    function void set_apb_default(bit [31:0] prdata, int delay, bit slverr);
        env.apb_agt.drv.default_prdata  = prdata;
        env.apb_agt.drv.default_delay   = delay;
        env.apb_agt.drv.default_pslverr = slverr;
    endfunction
endclass