`include "APB_MASTER_INF.sv"
`include "APB_SLAVE_INF.sv"

package APB_PKG;

 `include "uvm_macros.svh"
  import uvm_pkg::*;


//MASTER AGENT FILES
 `include "APB_MASTER_TXN.sv"
 `include "APB_MASTER_SEQR.sv"
 `include "APB_MASTER_BASE_SEQ.sv"
 `include "APB_SANITY_SEQUENCE.sv"
 `include "APB_WRITE_SEQ.sv"
 `include "APB_READ_SEQ.sv"
 `include "APB_ERROR_SEQ.sv"
 `include "APB_DIR_SEQ.sv"
 `include "APB_MASTER_DRV.sv"
 `include "APB_MASTER_MON.sv"
 `include "APB_MASTER_AGENT.sv"
//AD SEQUENCE FILE

// SLAVE AGENT  FILES
 `include "APB_SLAVE_TXN.sv"
 `include "APB_SLAVE_SEQR.sv"
 `include "APB_SLAVE_BASE_SEQ.sv"
 `include "APB_SLAVE_DRV.sv"
 `include "APB_SLAVE_MON.sv"
 `include "APB_SLAVE_AGENT.sv"
// ADD SEQUENDE OF SLAVE 


//ENV AND TEST
 `include "APB_SCR_BD.sv"
 `include "APB_COVERAGE_COLLECTOR.sv"
 `include "APB_ENV.sv"
 `include "APB_BASE_TEST.sv"
 `include "APB_SANITY_TEST.sv"
 `include "APB_WRITE_TEST.sv"
 `include "APB_READ_TEST.sv"
 `include "APB_B2B_TEST.sv"
 `include "APB_ERROR_TEST.sv"
 `include "APB_DIRECTED_TEST.sv"


endpackage