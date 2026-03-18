class APB_ERROR_TEST extends APB_BASE_TEST;
  `uvm_component_utils(APB_ERROR_TEST)
  
  function new(string name ,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  APB_ERROR_SEQ#(ADDR_WIDTH,DATA_WIDTH,3) e_seq;
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    e_seq = APB_ERROR_SEQ#(ADDR_WIDTH,DATA_WIDTH,3)::type_id::create("e_seq");
    e_seq.start(env.m_agnt.m_seqr);
    apply_reset();
    e_seq.start(env.m_agnt.m_seqr);
    phase.drop_objection(this);
  endtask
  
  
endclass