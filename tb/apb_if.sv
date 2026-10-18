`ifndef APB_IF_SV
`define APB_IF_SV

interface apb_if #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32
) (input logic PCLK, input logic PRESETn);

    logic                    PSEL;
    logic                    PENABLE;
    logic                    PWRITE;
    logic [ADDR_WIDTH-1:0]   PADDR;
    logic [DATA_WIDTH-1:0]   PWDATA;
    logic [DATA_WIDTH-1:0]   PRDATA;
    logic                    PREADY;
    logic                    PSLVERR;

    clocking drv_cb @(posedge PCLK);
        default input #1step output #1step;
        output PRDATA, PREADY, PSLVERR;
        input  PSEL, PENABLE, PWRITE, PADDR, PWDATA;
    endclocking

    clocking mon_cb @(posedge PCLK);
        default input #1step;
        input PSEL, PENABLE, PWRITE, PADDR, PWDATA, PRDATA, PREADY, PSLVERR;
    endclocking

endinterface
`endif