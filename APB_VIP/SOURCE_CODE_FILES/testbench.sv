
/*
FUNCTIONALITY OF THE SLAVE 
ADDR - [20:32] -> WRITE_ONLY REGISTERS
ADDR - [52:64] -> READ_ONLY REGISTERS
ADDR - [84:112] -> CURREPTED REGISTERS
*/

`include "uvm_macros.svh"
`include "APB_PKG.sv"
import uvm_pkg::*;
import APB_PKG::*;
module top;
  parameter ADDR_WIDTH = 32, DATA_WIDTH = 32;
  
  logic clk,rstn;
  
  uvm_event reset_ev;

  
  slave_interface#(ADDR_WIDTH,DATA_WIDTH) s_if(clk,rstn);
  master_interface#(ADDR_WIDTH,DATA_WIDTH) m_if(clk,rstn);
  
  initial
    begin
      clk = 0;
      forever
        begin
          #5 clk = !clk;
        end
    end
  
  // Master → Slave connections
  assign s_if.psel   = m_if.psel;
  assign s_if.penb   = m_if.penb;
  assign s_if.pwrite = m_if.pwrite;
  assign s_if.paddr  = m_if.paddr;
  assign s_if.pwdata = m_if.pwdata;

  // Slave → Master connections
  assign m_if.pready  = s_if.pready;
  assign m_if.prdata  = s_if.prdata;
  assign m_if.pslverr = s_if.pslverr;
  
  initial
    begin
      uvm_config_db#(virtual master_interface#(ADDR_WIDTH,DATA_WIDTH))::set(null,"*","m_vif",m_if);
      uvm_config_db#(virtual slave_interface#(ADDR_WIDTH,DATA_WIDTH))::set(null,"*","s_vif",s_if);
      run_test("APB_ERROR_TEST");
    end
  
  initial
    begin
      rstn = 0;
      repeat(2) @(posedge clk);
      rstn=1;
    end
  
  initial
    begin
      reset_ev = uvm_event_pool::get_global("reset_ev");
      forever
        begin
          reset_ev.wait_trigger();
          rstn = 0;
          repeat(2) @(posedge clk);
          rstn = 1;
          reset_ev.reset();
        end
    end
    
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
    end
endmodule