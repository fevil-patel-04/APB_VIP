class APB_M_DRV #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_driver #(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH), APB_M_TXN #(ADDR_WIDTH,DATA_WIDTH));
  
  `uvm_component_param_utils(APB_M_DRV#(ADDR_WIDTH,DATA_WIDTH))
  
  virtual master_interface#(ADDR_WIDTH,DATA_WIDTH) m_vif;
  APB_M_TXN master_txn_que[$];
  bit[1:0] state;
  event ev;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      forever
        begin
          wait(m_vif.prstn);
          seq_item_port.get(req);
          master_txn_que.push_back(req);
        end
    join_none
    fork
      reset_handler();
    join_none
    drive();
  endtask
  
  task drive();
    APB_M_TXN txn;
    forever
      begin
        @(posedge m_vif.pclk iff m_vif.prstn)
        case(state)
          2'b00: begin
             		m_vif.M_mp_drv.psel <= 0;
                    m_vif.M_mp_drv.penb <= 0;
                    m_vif.M_mp_drv.paddr <= 'bz;
            		m_vif.M_mp_drv.pwrite <= 'bz;
                    m_vif.M_mp_drv.pwdata <= 'bz;
            		m_vif.M_mp_drv.prdata <= 'bz;
            		wait(master_txn_que.size()>0);
            		txn = master_txn_que.pop_front;
            		if(m_vif.prstn)
                       state <= 2'b01;
                    else
                        state <= 2'b00;
          		 end
          2'b01 : begin
                    if(txn==null)
              		  txn = master_txn_que.pop_front;
//             		$display("printing inside Master driver at t= %0t",$time);
//             		txn.print();
            		m_vif.M_mp_drv.psel <= 1;
            		m_vif.M_mp_drv.penb <= 0;
                    m_vif.M_mp_drv.paddr <= txn.paddr;
            		m_vif.M_mp_drv.pwrite <= txn.pwrite;
            		if(txn.pwrite)
                      m_vif.M_mp_drv.pwdata <= txn.pwdata;
            		else
                      m_vif.M_mp_drv.pwdata <= 'bz;
            		if(m_vif.prstn)
            		  state <= 2'b11;
            		else
                      state <= 2'b00;
          		  end
          2'b11 : begin
                   m_vif.M_mp_drv.psel <= 1;
            	   m_vif.M_mp_drv.penb <= 1;
            	   if(m_vif.pready)
                     begin
                       txn.pslverr = m_vif.M_mp_drv.pslverr;
                       seq_item_port.put(txn);
                       txn = null;
                       if(master_txn_que.size()==0 || (m_vif.prstn==0))
                         state <= 2'b00;
                       else
                         state <= 2'b01;
                     end
            		else
                      begin
                        state <= 2'b11;
                      end
          		  end
          default : begin
            		  state <= 2'b00;
          			end
        endcase
        
      end
  endtask
  
  task reset_handler();
    forever
      begin
         @(negedge m_vif.prstn);

    	  // Force driver to idle immediately
   		  state = 2'b00;

    	  // Drive default values
    	  m_vif.M_mp_drv.psel   <= 0;
    	  m_vif.M_mp_drv.penb   <= 0;
    	  m_vif.M_mp_drv.paddr  <= 'bx;
    	  m_vif.M_mp_drv.pwrite <= 'bx;
    	  m_vif.M_mp_drv.pwdata <= 'bx;
    	  m_vif.M_mp_drv.prdata <= 'bx;


    	  // Wait until reset is released
    	  @(posedge m_vif.prstn);
      end
  endtask
    
endclass