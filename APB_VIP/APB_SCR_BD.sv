class APB_SCR_BD#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_scoreboard;
  `uvm_component_param_utils(APB_SCR_BD#(ADDR_WIDTH,DATA_WIDTH))
  
  `uvm_analysis_imp_decl(_exp)
  `uvm_analysis_imp_decl(_act)
  
  uvm_analysis_imp_exp#(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH),APB_SCR_BD#(ADDR_WIDTH,DATA_WIDTH)) exp_imp;
  
  uvm_analysis_imp_act#(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH),APB_SCR_BD#(ADDR_WIDTH,DATA_WIDTH)) act_imp;
  
  int pass_count;
  int fail_count;
  
  
  APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) act_que[$];
  APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH) exp_que[$];

  
  bit[7:0]mem[bit[31:0]];

  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    exp_imp = new("exp_imp",this);
    act_imp = new("act_imp",this);
  endfunction
  
  function void write_exp(APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH) exp_txn);
    ref_model(exp_txn);
    exp_que.push_back(exp_txn);
  endfunction
  
  function void write_act(APB_M_TXN#(ADDR_WIDTH,DATA_WIDTH) act_txn);
    act_que.push_back(act_txn);
  endfunction
  
//   function void extract_phase(uvm_phase phase);
//     super.extract_phase(phase);
//     `uvm_info(get_full_name(),$sformatf("THE SIZE OF ACTUAL QUE IS = %0d",act_que.size()),UVM_NONE);
//     `uvm_info(get_full_name(),$sformatf("THE SIZE OF EXPECTED QUE IS = %0d",exp_que.size()),UVM_NONE);
    
//     $display("printing the actual transcations");
//     foreach(act_que[i])
//       begin
//         act_que[i].print();
//       end
    
//     $display("printing the expected transcations");
//     foreach(exp_que[i])
//       begin
//         exp_que[i].print();
//       end
    
//   endfunction
  
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    foreach(act_que[i])
      begin
        if((act_que[i].paddr == exp_que[i].paddr) && (act_que[i].prdata == exp_que[i].prdata))
          pass_count++;
        else
          fail_count++;
      end
//     $display("printing the mem = %p",mem);
  endfunction
  
  
  
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    if((pass_count>0) && (fail_count==0))
      begin
         $display("******* ******* ******* *******");
         $display("*     * *     * *       *      ");
         $display("*     * *     * *       *      ");
         $display("******* ******* ******* *******");
         $display("*       *     *       *       *");
         $display("*       *     *       *       *");
         $display("*       *     * ******* *******");
      end
    else
      begin
        $display("******* ******* ******* *      ");
        $display("*       *     *    *    *      ");
        $display("*       *     *    *    *      ");
        $display("*****   *******    *    *       ");
        $display("*       *     *    *    *      ");
        $display("*       *     *    *    *      ");
        $display("*       *     * ******* ********");
      end
    $display("TOTAL PASS COUNT = %0d ",pass_count);
    $display("TOTAL FAIL COUNT = %0d ",fail_count);

  endfunction
 
  
   
  function void ref_model (ref APB_S_TXN#(ADDR_WIDTH,DATA_WIDTH) s_txn);
    if(s_txn.pwrite)
      mem_write(s_txn);
    else
      mem_read(s_txn);
    
  endfunction
  
  
  
  
  
    function void mem_write( ref APB_S_TXN s_txn);
      logic[31:0] base_addr;
    
    if((s_txn.paddr inside {52,56,60,64})) //WRITE ACCESS TO READ ONLY REGISTER 
      begin
        s_txn.pslverr = 1;
      end
    else if(s_txn.paddr inside{84,88,92,96,100,104,108,112}) //WRITE ACCESS STORED THE CORRUPTED DATA IN REGISTERS
      begin
        s_txn.pwdata = BIN_TO_GRE(s_txn.pwdata);
        base_addr = s_txn.paddr;
    	for(int i=0;i<DATA_WIDTH/8;i++)
      	    begin
        	  mem[base_addr+i] = s_txn.pwdata[i*8 +: 8];
      		end
        s_txn.pslverr = 1;
      end
    else  //WRITE ACCESS TO WRITABLE MEMORY
      begin
         base_addr = s_txn.paddr;
    	 for(int i=0;i<DATA_WIDTH/8;i++)
      	    begin
        	  mem[base_addr+i] = s_txn.pwdata[i*8 +: 8];
      		end
         s_txn.pslverr = 0;
      end
  endfunction
  
  
  
  
  
   function void mem_read(ref APB_S_TXN s_txn);
     logic[31:0] base_addr;
    if((s_txn.paddr inside {20,24,28,32})) //READ ACCESS TO WRITE ONLY REGISTER
      begin
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
        	  s_txn.prdata[j*8 +: 8] = mem[base_addr+j];
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
  