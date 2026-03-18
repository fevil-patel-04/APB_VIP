class APB_M_MON #(parameter ADDR_WIDTH = 32, DATA_WIDTH =32) extends uvm_monitor;
  `uvm_component_param_utils(APB_M_MON #(ADDR_WIDTH,DATA_WIDTH))
  
  virtual master_interface#(ADDR_WIDTH,DATA_WIDTH) m_vif;
  uvm_analysis_port#(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH)) an_port;
  APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) m_txn;
  APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) m_txn_1;

  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    an_port = new("an_port",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever
      begin
        @(posedge m_vif.pclk iff (m_vif.M_mp_mon.penb && m_vif.M_mp_mon.pready));
          m_txn = APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH)::type_id::create("m_txn",this);
          m_txn.paddr = m_vif.M_mp_mon.paddr;
          m_txn.pwrite = m_vif.M_mp_mon.pwrite;
          m_txn.pwdata = m_vif.M_mp_mon.pwdata;
          if(!m_txn.pwrite) 
            begin
//               $display("Printing Read data = %0d at t= %0t",m_vif.prdata,$time);
              m_txn_1 = new m_txn;
              fork
                begin
                 @(posedge m_vif.pclk)
                 m_txn_1.prdata = m_vif.M_mp_mon.prdata;
                 m_txn_1.pslverr = m_vif.M_mp_mon.pslverr;
                 an_port.write(m_txn_1); 
                end
              join_none
            end
          else
            begin
              an_port.write(m_txn);
            end
      end
  endtask
  
  
endclass