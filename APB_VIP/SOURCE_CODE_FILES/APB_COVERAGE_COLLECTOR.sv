class APB_COVERAGE_COLLECTOR #(parameter ADDR_WIDTH = 32,DATA_WIDTH = 32)extends uvm_subscriber#(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_component_utils(APB_COVERAGE_COLLECTOR#(ADDR_WIDTH,DATA_WIDTH))
  
  APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) m_txn;
  
  covergroup cvg();
    
    ADDR:coverpoint m_txn.paddr{
    bins low_range  = {[32'h00000001 : 32'h55555554]};
    bins mid_range  = {[32'h55555555 : 32'hAAAAAAAB]};
    bins high_range = {[32'hAAAAAAAC : 32'hFFFFFFFE]};}
    
    WDATA:coverpoint m_txn.pwdata{
    bins low_range  = {[32'h00000001 : 32'h55555554]};
    bins mid_range  = {[32'h55555555 : 32'hAAAAAAAB]};
    bins high_range = {[32'hAAAAAAAC : 32'hFFFFFFFE]};}
    
    RDATA:coverpoint m_txn.prdata{
    bins low_range  = {[32'h00000001 : 32'h55555554]};
    bins mid_range  = {[32'h55555555 : 32'hAAAAAAAB]};
    bins high_range = {[32'hAAAAAAAC : 32'hFFFFFFFE]};}
    
    
    PWRITE:coverpoint m_txn.pwrite{
      bins b1 = {0,1};
      bins b2 = (0=>1);
      bins b3 = (1=>0);}
    
    PSLVERR:coverpoint m_txn.pslverr{
      bins b1 = {0,1};
      bins b2 = (0=>1);
      bins b3 = (1=>0);}
    
    CROSS_1:cross ADDR,PWRITE;
    
    CROSS_2: cross ADDR,WDATA;
    
    CROSS_3: cross ADDR,RDATA;
    
  endgroup
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    cvg = new();
  endfunction
  
  function void write(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) t);
    m_txn = t;
    $display("Printing Read data = %0d at t= %0t",t.prdata,$time);
    cvg.sample();
  endfunction
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_name(),$sformatf("THE TEST HAS BEEN PASSED SUCCESSFULLY NOW PRINTING THE COVERAGE INFORMATION BELOW "),UVM_NONE);
    
    `uvm_info(get_name,$sformatf("THE COVERAGE PERCENTAGE IS %0F",cvg.get_coverage()),UVM_NONE);    
  endfunction
  
  
    
endclass