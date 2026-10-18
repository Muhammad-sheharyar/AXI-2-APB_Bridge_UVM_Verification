class axi2apb_env extends uvm_env;
    `uvm_component_utils(axi2apb_env)

    axi_agent           axi_agt;
    apb_agent           apb_agt;
    axi2apb_scoreboard  scb;
    axi2apb_coverage    cov;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_agt = axi_agent::type_id::create("axi_agt", this);
        apb_agt = apb_agent::type_id::create("apb_agt", this);
        scb     = axi2apb_scoreboard::type_id::create("scb", this);
        cov     = axi2apb_coverage::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        axi_agt.mon.ap.connect(scb.axi_imp); //write_axi
        axi_agt.mon.ap.connect(cov.axi_imp); //axi_coverage
        apb_agt.mon.ap.connect(scb.apb_imp); //write_apb
        apb_agt.mon.ap.connect(cov.apb_imp); //apb_coverage
    endfunction
endclass