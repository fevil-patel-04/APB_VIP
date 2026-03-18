#!/bin/bash

# --- 1. SETUP AND COMPILATION ---
vlib work

# Manually compile UVM 1.2 package from the tool's source directory
# This ensures all base classes like uvm_sequence_item are recognized
vlog -sv +incdir+$QUESTA_HOME/verilog_src/uvm-1.2/src $QUESTA_HOME/verilog_src/uvm-1.2/src/uvm_pkg.sv

# Compile design and testbench with full coverage instrumentation
# +cover=bcesxt enables: Branch, Condition, Expression, Statement, Extended-branch, and Toggle coverage
vlog -sv +incdir+$QUESTA_HOME/verilog_src/uvm-1.2/src +cover=bcesxt design.sv testbench.sv

# --- 2. REGRESSION CONFIGURATION ---
REPORT="regression_report.txt"
TESTS=("APB_SANITY_TEST" "APB_WRITE_TEST" "APB_READ_TEST" "APB_B2B_TEST" "APB_ERROR_TEST" "APB_DIRECTED_TEST")

echo "====================================================" > $REPORT
echo "           UVM REGRESSION SUMMARY REPORT            " >> $REPORT
echo "           Date: $(date)                            " >> $REPORT
echo "====================================================" >> $REPORT

# --- 3. TEST EXECUTION LOOP ---
for TEST in "${TESTS[@]}"
do
    echo "----------------------------------------------------"
    echo "RUNNING TEST: $TEST"
    
    # -uvmcontrol=all: Mandatory for Questa 2025.2
    # -sv_lib: Loads UVM DPI libraries to avoid "Function not found" warnings
    # coverage save -onexit: Creates a unique UCDB file for merging later
    vsim -c -uvmcontrol=all -coverage -voptargs="+acc" \
         -sv_lib $QUESTA_HOME/uvm-1.2/linux_x86_64/uvm_dpi \
         work.top +UVM_TESTNAME=$TEST \
         -do "coverage save -onexit ${TEST}.ucdb; run -all; quit" | tee last_run.log
    
    # Analyze log for Pass/Fail status
    if grep -q "UVM_ERROR :    0" last_run.log && grep -q "UVM_FATAL :    0" last_run.log; then
        printf "%-25s : PASSED\n" "$TEST" >> $REPORT
    else
        printf "%-25s : FAILED\n" "$TEST" >> $REPORT
    fi
done

# --- 4. COVERAGE MERGING & REPORTING ---
echo "Merging coverage results..."
# Merge all individual test databases into one master file
vcover merge final_coverage.ucdb *.ucdb

# Generate a text summary in the regression report
echo "" >> $REPORT
echo "--- COVERAGE SUMMARY ---" >> $REPORT
vcover report -summary final_coverage.ucdb >> $REPORT

# Generate a full HTML web-page report for detailed analysis
# This allows you to see which specific lines or covergroups were hit
vcover report -html -htmldir cov_html -details -annotate -cvg -code bcesxt final_coverage.ucdb

# Print report to console for immediate viewing
cat $REPORT
