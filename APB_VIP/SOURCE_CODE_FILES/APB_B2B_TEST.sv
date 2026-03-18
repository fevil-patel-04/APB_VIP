class APB_B2B_TEST extends APB_BASE_TEST;
  `uvm_component_utils(APB_B2B_TEST)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  APB_WRITE_SEQ#(ADDR_WIDTH,DATA_WIDTH,5) w_seq;
  APB_READ_SEQ#(ADDR_WIDTH,DATA_WIDTH,5) r_seq;
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    w_seq = APB_WRITE_SEQ#(ADDR_WIDTH,DATA_WIDTH,5)::type_id::create("w_seq");
    r_seq = APB_READ_SEQ#(ADDR_WIDTH,DATA_WIDTH,5)::type_id::create("r_seq");
    repeat(5)
      begin
    	w_seq.start(env.m_agnt.m_seqr);
        apply_reset();
    	r_seq.start(env.m_agnt.m_seqr);
      end
    phase.drop_objection(this);
  endtask
  
endclass