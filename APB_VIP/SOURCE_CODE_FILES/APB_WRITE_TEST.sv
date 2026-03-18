class APB_WRITE_TEST extends APB_BASE_TEST;
  
  `uvm_component_utils(APB_WRITE_TEST)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  APB_WRITE_SEQ#(ADDR_WIDTH,DATA_WIDTH,25) w_seq;
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    w_seq = APB_WRITE_SEQ#(ADDR_WIDTH,DATA_WIDTH,25)::type_id::create("w_seq");
    w_seq.start(env.m_agnt.m_seqr);
    apply_reset();
    w_seq.start(env.m_agnt.m_seqr);
    phase.drop_objection(this);
  endtask
  
endclass