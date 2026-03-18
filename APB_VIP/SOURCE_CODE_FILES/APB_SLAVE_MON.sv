class APB_S_MON #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32)extends uvm_monitor;
  `uvm_component_param_utils(APB_S_MON#(ADDR_WIDTH,DATA_WIDTH))
 
  virtual slave_interface#(ADDR_WIDTH,DATA_WIDTH) s_vif;
  APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH) s_txn;
  uvm_analysis_port#(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH)) an_port;

  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    an_port = new("an_port",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever
      begin
        @(posedge s_vif.pclk iff (s_vif.psel && s_vif.penb))
        s_txn = APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_txn");
        s_txn.paddr = s_vif.S_mp_mon.paddr;
        s_txn.pwrite = s_vif.S_mp_mon.pwrite;
        if(s_txn.pwrite)
           s_txn.pwdata = s_vif.S_mp_mon.pwdata;
        else
           s_txn.pwdata = 'bz;
        an_port.write(s_txn);
//         `uvm_info(get_type_name(),$sformatf("Transaction Received in slave monitor at t =%0t ",$time), UVM_MEDIUM)
//         s_txn.print();
      end
  endtask
endclass