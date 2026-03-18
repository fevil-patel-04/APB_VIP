class APB_S_TXN#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_sequence_item;
  
  bit pwrite;
  bit pslverr;
  bit[ADDR_WIDTH-1:0]paddr;
  bit[DATA_WIDTH-1:0]pwdata;
  bit[DATA_WIDTH-1:0]prdata;
  
  `uvm_object_param_utils_begin(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH))
  `uvm_field_int(pwrite, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(pslverr, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(paddr, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(pwdata, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(prdata, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end
  
  function new(string name = "");
    super.new(name);
  endfunction
  
endclass