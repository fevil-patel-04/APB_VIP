class APB_ENV #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_env;
  `uvm_component_param_utils(APB_ENV#(ADDR_WIDTH,DATA_WIDTH))
  
  APB_M_AGNT#(ADDR_WIDTH,DATA_WIDTH) m_agnt;
  APB_S_AGNT#(ADDR_WIDTH,DATA_WIDTH) s_agnt;
  APB_SCR_BD#(ADDR_WIDTH,DATA_WIDTH) scr_bd;
  APB_COVERAGE_COLLECTOR#(ADDR_WIDTH,DATA_WIDTH) apb_cov;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_agnt = APB_M_AGNT#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_agnt",this);
    s_agnt = APB_S_AGNT#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_agnt",this);
    scr_bd = APB_SCR_BD#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("scr_bd",this);
    apb_cov = APB_COVERAGE_COLLECTOR#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("apb_cov",this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    s_agnt.s_mon.an_port.connect(scr_bd.exp_imp);
    m_agnt.m_mon.an_port.connect(scr_bd.act_imp);
    m_agnt.m_mon.an_port.connect(apb_cov.analysis_export);
  endfunction
  
  
endclass