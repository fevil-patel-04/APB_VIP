class APB_DIR_SEQ#(parameter ADDR_WIDTH = 32, DATA_WIDTH= 32) extends APB_M_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH);
  `uvm_object_utils(APB_DIR_SEQ#(ADDR_WIDTH,DATA_WIDTH))
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  task body();    
    `uvm_do_with(txn,{paddr==0;pwdata==32'hFFFF_FFFF;pwrite==1;});
    `uvm_do_with(txn,{paddr==0;pwrite==0;});
    `uvm_do_with(txn,{paddr==32'hFFFF_FFFC;pwdata==0;pwrite==1;});
    `uvm_do_with(txn,{paddr==32'hFFFF_FFFC;pwrite==0;});
    wait(trans_count==4);
  endtask

endclass