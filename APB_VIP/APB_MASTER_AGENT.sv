class APB_M_AGNT #(parameter ADDR_WIDTH = 32,DATA_WIDTH = 32)extends uvm_agent;
  `uvm_component_param_utils(APB_M_AGNT#(ADDR_WIDTH,DATA_WIDTH))
  
  APB_M_SEQR#(ADDR_WIDTH,DATA_WIDTH) m_seqr;
  APB_M_DRV#(ADDR_WIDTH,DATA_WIDTH) m_drv;
  APB_M_MON#(ADDR_WIDTH,DATA_WIDTH) m_mon;
  virtual master_interface#(ADDR_WIDTH,DATA_WIDTH) m_vif;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_seqr = APB_M_SEQR#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_seqr",this);
    m_drv = APB_M_DRV#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_drv",this);
    m_mon = APB_M_MON#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_mon",this);
  endfunction
  
   function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    m_drv.seq_item_port.connect(m_seqr.seq_item_export);
     if(!uvm_config_db#(virtual master_interface#(ADDR_WIDTH,DATA_WIDTH))::get(null,"*","m_vif",m_vif))
       `uvm_fatal(get_full_name(),"Cannot find virtual interface for master")
    m_drv.m_vif = m_vif;
    m_mon.m_vif = m_vif;
  endfunction 
  
endclass