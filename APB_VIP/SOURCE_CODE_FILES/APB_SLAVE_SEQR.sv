class APB_S_SEQR #(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32)extends uvm_sequencer #(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH), APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH));
  `uvm_component_param_utils(APB_S_SEQR #(ADDR_WIDTH,DATA_WIDTH))
  
  uvm_tlm_analysis_fifo#(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH)) m_req_fifo;
  APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH) txn;
  
  bit[7:0]ref_mem[bit[31:0]];
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_req_fifo = new("m_req_fifo",this);
  endfunction
  
 
  function void mem_write( ref APB_S_TXN s_txn);
    int base_addr;
    
    if((s_txn.paddr inside {52,56,60,64})) //WRITE ACCESS TO READ ONLY REGISTER 
      begin
        `uvm_error("APB_SLAVE","ERROR : TRYING TO WRITE READ-ONLY REGISTERS ");
        s_txn.pslverr = 1;
      end
    else if(s_txn.paddr inside{84,88,92,96,100,104,108,112}) //WRITE ACCESS STORED THE CORRUPTED DATA IN REGISTERS
      begin
        s_txn.pwdata = BIN_TO_GRE(s_txn.pwdata);
        base_addr = s_txn.paddr;
    	for(int i=0;i<DATA_WIDTH/8;i++)
      	    begin
        	  ref_mem[base_addr+i] = s_txn.pwdata[i*8 +: 8];
      		end
        s_txn.pslverr = 1;
      end
    else  //WRITE ACCESS TO WRITABLE MEMORY
      begin
         base_addr = s_txn.paddr;
    	 for(int i=0;i<DATA_WIDTH/8;i++)
      	    begin
        	  ref_mem[base_addr+i] = s_txn.pwdata[i*8 +: 8];
      		end
         s_txn.pslverr = 0;
      end
  endfunction
  
  function void mem_read(ref APB_S_TXN s_txn);
    int base_addr;
    if((s_txn.paddr inside {20,24,28,32})) //READ ACCESS TO WRITE ONLY REGISTER
      begin
        `uvm_error("APB_SLAVE","ERROR : TRYING TO READ WRITE-ONLY REGISTERS ");
        s_txn.pslverr = 1;
      end
    else if(s_txn.paddr inside{84,88,92,96,100,104,108,112}) //READ ACCESS TO REGISTERS WHICH STORES CORRUPTED DATA
      begin
        s_txn.prdata  = 'bx;
        s_txn.pslverr = 1;
      end
    else  //READ ACCESS TO READABLE MEMORY LOCATION
      begin
         base_addr = s_txn.paddr;
    	 for(int j=0;j<DATA_WIDTH/8;j++)
      		begin
              s_txn.prdata[j*8 +: 8] = ref_mem[base_addr+j];
      		end
         s_txn.pslverr = 0;
      end
  endfunction
  
  function logic [DATA_WIDTH-1:0] BIN_TO_GRE(input logic[DATA_WIDTH-1:0] bin);
    logic[DATA_WIDTH-1:0] grey;
    grey = bin ^ (bin >> 1);
    return grey;
  endfunction

   
        
  
endclass
  