class APB_M_BASE_SEQ#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_sequence#(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_object_param_utils(APB_M_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH))
  
  int trans_count;
  function new(string name="");
    super.new(name);
  endfunction
  
  APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) txn;
  
  
  task pre_start();
    fork
      collect_response();
    join_none
  endtask
  
  virtual task body();
    `uvm_do_with(txn,{paddr==4;pwdata==45;pwrite==1;});
    `uvm_do_with(txn,{paddr==4;pwrite==0;});
    `uvm_do_with(txn,{paddr==8;pwdata==35;pwrite==1;});
    `uvm_do_with(txn,{paddr==8;pwrite==0;});
    wait(trans_count==4);
  endtask
  
  task collect_response();
    forever 
      begin
        get_response(rsp);
        `uvm_info(get_full_name(),$sformatf("the value of Pslverr is %0d",rsp.pslverr),UVM_NONE);
        trans_count++;
      end
  endtask
  
  
endclass