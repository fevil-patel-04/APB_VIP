class APB_S_DRV #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_driver #(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH),APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_component_param_utils(APB_S_DRV #(ADDR_WIDTH,DATA_WIDTH));
  
  virtual slave_interface#(ADDR_WIDTH,DATA_WIDTH) s_vif;
  
  
  function new(string name , uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    s_vif.S_mp_drv.pready <= 1;
    forever
      begin
        @(posedge s_vif.pclk iff s_vif.pready)
        seq_item_port.get_next_item(req);
//         $display("transaction reveived in Slave Driver at to %0t",$time);
//         req.print();
        if(!req.pwrite)
          s_vif.S_mp_drv.prdata <= req.prdata;
        else
          s_vif.S_mp_drv.prdata <= 'bz;
        s_vif.S_mp_drv.pslverr <= req.pslverr;
        seq_item_port.item_done();
      end   
  endtask
  
//   task run_phase(uvm_phase phase);
//     super.run_phase(phase);
//     s_vif.S_mp_drv.pready = 1;
//   endtask
  
  
  
endclass  