class APB_M_TXN #(parameter ADDR_WIDTH = 32,DATA_WIDTH = 32) extends uvm_sequence_item;
  
  //signal which can randomized
  rand bit pwrite;
  rand bit[ADDR_WIDTH-1:0]paddr;
  rand bit[DATA_WIDTH-1:0]pwdata;
  
  //signal which cannot be randomized(driven by slave sampled by master)
  bit[DATA_WIDTH-1:0]prdata;
  bit pslverr;
  
  `uvm_object_param_utils_begin(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH))
  `uvm_field_int(pwrite, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(pslverr, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(paddr, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(pwdata, UVM_ALL_ON | UVM_DEC)
  `uvm_field_int(prdata, UVM_ALL_ON | UVM_DEC)
  `uvm_object_utils_end
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  constraint c1 {paddr%(DATA_WIDTH/8) == 0;}
    constraint c2 {paddr inside {[0:32'hFFFF_FFFC]};}
  
endclass