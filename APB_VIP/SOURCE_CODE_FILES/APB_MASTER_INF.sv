 `include "uvm_macros.svh"
import uvm_pkg::*;
interface master_interface#(parameter ADDR_WIDTH = 32, DATA_WIDTH =32)(input logic pclk, prstn);
  
  logic psel;
  logic penb;
  logic pready;
  logic pwrite;
  logic pslverr;
  logic [ADDR_WIDTH-1:0] paddr;
  logic [DATA_WIDTH-1:0] pwdata;
  logic [DATA_WIDTH-1:0] prdata;
  
  clocking M_cb_drv@(posedge pclk);
    default input #1 output #1;
    output psel,penb,pwrite,paddr,pwdata;
    input pready,prdata,pslverr;
  endclocking
  
  clocking M_cb_mon@(posedge pclk);
    default input #1 output #1;
    input psel,penb,pwrite,paddr,pwdata,prdata,pready,pslverr;
  endclocking
  
  modport M_mp_drv(input pclk,prstn, clocking M_cb_drv);
  modport M_mp_mon(input pclk,prstn, clocking M_cb_mon);
  
  
     
  property p1;
    @(posedge pclk) disable iff(!prstn)
    (!pready && psel && penb && pwrite) |-> $stable(paddr) && $stable(pwdata) && $stable(pwrite) throughout (!pready[*0:15]);
  endproperty
    
  property p2;
    @(posedge pclk) disable iff(!prstn)
    (!pready && psel && penb && !pwrite) |-> (!pready && !pwrite)[*0:15] ##1 (pready && !$isunknown(prdata));
  endproperty
    
  property p3;
    @(posedge pclk) disable iff(!prstn)
    (psel && !penb) |=> penb;
  endproperty
    
  property p4;
    @(posedge pclk) disable iff(!prstn)
    (!psel && !penb && !pready) |-> !pslverr;
  endproperty
    
  property p5;
    @(posedge pclk) disable iff(!prstn)
    (psel && penb && !pready) |-> !pready[*0:15] ##1 (pready && !$isunknown(pslverr)); 
  endproperty
    
    assert property (p1)
      else
        `uvm_error("PROP P1:","P1 PROPERTY GET FAILED");
      
    assert property (p2)
      else
        `uvm_error("PROP P2:","P2 PROPERTY GET FAILED");
    
    assert property (p3)
      else
        `uvm_error("PROP P3:","P3 PROPERTY GET FAILED");

    assert property (p4)
      else
        `uvm_error("PROP P4:","P4 PROPERTY GET FAILED");

    assert property (p5)
      else
        `uvm_error("PROP P5:","P5 PROPERTY GET FAILED");
    
    
                                                                                                             
    
  
endinterface