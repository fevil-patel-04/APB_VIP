class APB_DIRECTED_TEST extends APB_BASE_TEST;
  `uvm_component_utils(APB_DIRECTED_TEST)
  
  APB_DIR_SEQ#(ADDR_WIDTH,DATA_WIDTH) dir_seq;

  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    dir_seq = APB_DIR_SEQ#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("dir_seq");
    dir_seq.start(env.m_agnt.m_seqr);
    phase.drop_objection(this);
  endtask
  
endclass