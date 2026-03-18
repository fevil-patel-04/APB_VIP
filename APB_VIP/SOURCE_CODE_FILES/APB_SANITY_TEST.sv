class APB_SANITY_TEST extends APB_BASE_TEST;
  `uvm_component_utils(APB_SANITY_TEST)
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  APB_SANITY_SEQ#(ADDR_WIDTH,DATA_WIDTH,25) seq;
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    seq = APB_SANITY_SEQ#(ADDR_WIDTH,DATA_WIDTH,25)::type_id::create("seq");
    seq.start(env.m_agnt.m_seqr);
    apply_reset();
    seq.start(env.m_agnt.m_seqr);
    phase.drop_objection(this);
  endtask
  
endclass