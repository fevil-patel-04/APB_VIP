class APB_S_AGNT #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_agent;
  `uvm_component_param_utils(APB_S_AGNT#(ADDR_WIDTH,DATA_WIDTH))
  
  APB_S_SEQR#(ADDR_WIDTH,DATA_WIDTH) s_seqr;
  APB_S_DRV#(ADDR_WIDTH,DATA_WIDTH) s_drv;
  APB_S_MON#(ADDR_WIDTH,DATA_WIDTH) s_mon;
  virtual slave_interface#(ADDR_WIDTH,DATA_WIDTH) s_vif;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s_seqr = APB_S_SEQR#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_seqr",this);
    s_drv = APB_S_DRV#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_drv",this);
    s_mon = APB_S_MON#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_mon",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    s_drv.seq_item_port.connect(s_seqr.seq_item_export);
    s_mon.an_port.connect(s_seqr.m_req_fifo.analysis_export);
    if(!uvm_config_db#(virtual slave_interface#(ADDR_WIDTH,DATA_WIDTH))::get(null,"*","s_vif",s_vif))
      `uvm_fatal(get_full_name(),"Cannot find virtual interface for slave")
    s_drv.s_vif = s_vif;
    s_mon.s_vif = s_vif;
  endfunction 
endclass