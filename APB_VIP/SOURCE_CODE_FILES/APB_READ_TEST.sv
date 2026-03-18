class APB_READ_TEST extends APB_BASE_TEST;
  `uvm_component_utils(APB_READ_TEST)
  
  APB_WRITE_SEQ#(ADDR_WIDTH,DATA_WIDTH,20) w_seq;
  APB_READ_SEQ#(ADDR_WIDTH,DATA_WIDTH,20) r_seq;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction

  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    r_seq = APB_READ_SEQ#(ADDR_WIDTH,DATA_WIDTH,20)::type_id::create("r_seq");
    w_seq = APB_WRITE_SEQ#(ADDR_WIDTH,DATA_WIDTH,20)::type_id::create("w_seq");
    r_seq.start(env.m_agnt.m_seqr);
    w_seq.start(env.m_agnt.m_seqr);
    apply_reset();
    r_seq.start(env.m_agnt.m_seqr);
    phase.drop_objection(this);
  endtask
    
  
endclass