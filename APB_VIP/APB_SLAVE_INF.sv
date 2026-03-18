interface slave_interface#(parameter ADDR_WIDTH = 32, DATA_WIDTH =32)(input logic pclk, prstn);
  
  logic psel;
  logic penb;
  logic pready;
  logic pwrite;
  logic pslverr;
  logic [ADDR_WIDTH-1:0] paddr;
  logic [DATA_WIDTH-1:0] pwdata;
  logic [DATA_WIDTH-1:0] prdata;
  
  clocking S_cb_drv@(posedge pclk);
    default input #1 output #1;
    input psel,penb,pwrite,paddr,pwdata;
    output pready,prdata,pslverr;
  endclocking
  
  clocking S_cb_mon@(posedge pclk);
    default input #1 output #1;
    input psel,penb,pwrite,paddr,pwdata,prdata,pready,pslverr;
  endclocking
  
  modport S_mp_drv(input pclk,prstn, clocking S_cb_drv);
  modport S_mp_mon(input pclk,prstn, clocking S_cb_mon);
  
  
  
endinterface