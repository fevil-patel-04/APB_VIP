class APB_S_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH)extends uvm_sequence#(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_object_param_utils(APB_S_BASE_SEQ#(ADDR_WIDTH,DATA_WIDTH))
  
  function new(string name ="");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(APB_S_SEQR#(ADDR_WIDTH,DATA_WIDTH));
  
  task body();
    APB_S_TXN txn;
  	forever
      begin
        p_sequencer.m_req_fifo.get(txn);
        if(txn.pwrite)
          begin
            p_sequencer.mem_write(txn);
            `uvm_send(txn);
          end
        else
          begin
            p_sequencer.mem_read(txn);
            `uvm_send(txn);
          end
      end
  endtask
    
endclass