`ifndef AXI_IF_SV
`define AXI_IF_SV

interface axi_if #(
    parameter int ADDR_WIDTH = 32,
    parameter int DATA_WIDTH = 32,
    parameter int ID_WIDTH   = 16,
    parameter int USER_WIDTH = 10,
    parameter int STRB_WIDTH = DATA_WIDTH/8
) (input logic ACLK, input logic ARESETn);

    // Write Address
    logic [ID_WIDTH-1:0]     AWID;
    logic [ADDR_WIDTH-1:0]   AWADDR;
    logic [7:0]              AWLEN;
    logic [2:0]              AWSIZE;
    logic [1:0]              AWBURST;
    logic                    AWLOCK;
    logic [3:0]              AWCACHE;
    logic [2:0]              AWPROT;
    logic [3:0]              AWREGION;
    logic [USER_WIDTH-1:0]   AWUSER;
    logic [3:0]              AWQOS;
    logic                    AWVALID;
    logic                    AWREADY;

    // Write Data
    logic [DATA_WIDTH-1:0]   WDATA;
    logic [STRB_WIDTH-1:0]   WSTRB;
    logic                    WLAST;
    logic [USER_WIDTH-1:0]   WUSER;
    logic                    WVALID;
    logic                    WREADY;

    // Write Response
    logic [ID_WIDTH-1:0]     BID;
    logic [1:0]              BRESP;
    logic                    BVALID;
    logic [USER_WIDTH-1:0]   BUSER;
    logic                    BREADY;

    // Read Address
    logic [ID_WIDTH-1:0]     ARID;
    logic [ADDR_WIDTH-1:0]   ARADDR;
    logic [7:0]              ARLEN;
    logic [2:0]              ARSIZE;
    logic [1:0]              ARBURST;
    logic                    ARLOCK;
    logic [3:0]              ARCACHE;
    logic [2:0]              ARPROT;
    logic [3:0]              ARREGION;
    logic [USER_WIDTH-1:0]   ARUSER;
    logic [3:0]              ARQOS;
    logic                    ARVALID;
    logic                    ARREADY;

    // Read Data
    logic [ID_WIDTH-1:0]     RID;
    logic [DATA_WIDTH-1:0]   RDATA;
    logic [1:0]              RRESP;
    logic                    RLAST;
    logic [USER_WIDTH-1:0]   RUSER;
    logic                    RVALID;
    logic                    RREADY;

    clocking drv_cb @(posedge ACLK);
        default input #1step output #1step;
        output AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWLOCK, AWCACHE, AWPROT,
               AWREGION, AWUSER, AWQOS, AWVALID, WDATA, WSTRB, WLAST, WUSER,
               WVALID, BREADY, ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARLOCK,
               ARCACHE, ARPROT, ARREGION, ARUSER, ARQOS, ARVALID, RREADY;
        input  AWREADY, WREADY, BID, BRESP, BVALID, BUSER,
               ARREADY, RID, RDATA, RRESP, RLAST, RUSER, RVALID;
    endclocking

    clocking mon_cb @(posedge ACLK);
        default input #1step;
        input AWID, AWADDR, AWLEN, AWSIZE, AWBURST, AWLOCK, AWCACHE, AWPROT,
              AWREGION, AWUSER, AWQOS, AWVALID, AWREADY,
              WDATA, WSTRB, WLAST, WUSER, WVALID, WREADY,
              BID, BRESP, BVALID, BUSER, BREADY,
              ARID, ARADDR, ARLEN, ARSIZE, ARBURST, ARLOCK, ARCACHE, ARPROT,
              ARREGION, ARUSER, ARQOS, ARVALID, ARREADY,
              RID, RDATA, RRESP, RLAST, RUSER, RVALID, RREADY;
    endclocking

endinterface
`endif