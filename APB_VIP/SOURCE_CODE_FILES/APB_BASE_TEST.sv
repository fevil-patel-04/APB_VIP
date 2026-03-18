class APB_BASE_TEST extends uvm_test;
  
  `uvm_component_utils(APB_BASE_TEST)
  
  parameter ADDR_WIDTH = 32, DATA_WIDTH = 32;
  
  APB_M_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH) m_seq;
  APB_S_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH) s_seq;
  APB_ENV#(ADDR_WIDTH,DATA_WIDTH) env;
  uvm_event reset_ev; 
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = APB_ENV#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("env",this);
    reset_ev = uvm_event_pool::get_global("reset_ev");
  endfunction
 
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
  
  task apply_reset();
	$display("TEST: Triggering mid-reset");
  	reset_ev.trigger();
  endtask
  
 
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    fork
      begin
        s_seq = APB_S_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("s_seq");
        s_seq.start(env.s_agnt.s_seqr);
        `uvm_info(get_type_name(),"Slave sequence started successfully",UVM_LOW)
      end
    join_none
//      m_seq = APB_M_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_seq");
//      m_seq.start(env.m_agnt.m_seqr);
//      `uvm_info(get_type_name(),"Master sequence started successfully",UVM_LOW)
    phase.phase_done.set_drain_time(this,20ns);
    phase.drop_objection(this);
  endtask
  
endclass