class APB_M_SEQR #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_sequencer #(APB_M_TXN #(ADDR_WIDTH,DATA_WIDTH), APB_M_TXN #(ADDR_WIDTH,DATA_WIDTH));
  
  `uvm_component_param_utils(APB_M_SEQR#(ADDR_WIDTH,DATA_WIDTH))
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass