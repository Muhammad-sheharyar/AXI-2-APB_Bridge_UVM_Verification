class reset_test extends axi2apb_base_test;
    `uvm_component_utils(reset_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("TEST", "reset_test: idle for 100ns", UVM_LOW)
        #100ns;
        `uvm_info("TEST", "reset_test DONE", UVM_LOW)
        phase.drop_objection(this);
    endtask
endclass