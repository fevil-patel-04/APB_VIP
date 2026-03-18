class APB_ERROR_SEQ#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32, N = 20) extends APB_M_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH);
 
  `uvm_object_param_utils(APB_ERROR_SEQ#(ADDR_WIDTH,DATA_WIDTH,N))
  
  function new(string name = "");
    super.new(name);
  endfunction
  
  task body();
    repeat(N)
      begin
        `uvm_do_with(txn,{pwrite==1; (paddr inside{[52:64],[84:112]});});
        `uvm_do_with(txn,{pwrite==1; !(paddr inside{[52:64],[84:112]});});
      end
    repeat(N)
      begin
        `uvm_do_with(txn,{pwrite ==0; (paddr inside{[20:32],[84:112]});});
        `uvm_do_with(txn,{pwrite==0; !(paddr inside{[20:32],[84:112]});});
      end
    wait(trans_count == 4*N);
    trans_count=0;    
  endtask
  
endclass