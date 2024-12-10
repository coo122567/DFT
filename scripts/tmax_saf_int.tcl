
set_messages -log tmax_saf_int.log -replace

#--------------------------------------------------------------
# Read Design and run_build
#--------------------------------------------------------------
read_netlist -lib ../libs/vlg/saed32nm.v
#read_netlist -lib ../libs/tmaxlib/sad*max
read_netlist ../libs/tmaxlib/sad*v
#read_netlist -lib ../libs/tmaxlib/std_cells.max

set DESIGN core 

read_netlist ../syn/output/${DESIGN}_scan.v

report_modules -summary

set_build -nodelete_unused_gates

run_build ${DESIGN}

#--------------------------------------------------------------
# Run Design Rule Checks
#--------------------------------------------------------------
add_po_masks -all
add_slow_bidis -all
add_nofault -module   sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00

set_drc -disturb_clock_grouping

report_clocks -matrix > ./reports/SAF_int_report_clock_matrix.rpt
report_clocks -verbose > ./reports/SAF_int_report_clock_verbose.rpt
report_pi_constraints > ./reports/SAF_int_report_pi_cons.rpt

run_drc ../syn/output/${DESIGN}_comp.spf

write_image ./patterns/compression_dc.img.gz -replace -netlist_data -violations -compress gzip

report_rules -fail > ./reports/SAF_int_report_nonscan_cells.rpt
report_nonscan_cells -summary > ./reports/SAF_int_report_nonscan.rpt

report_scan_chains -verbose > ./reports/SAF_int_report_scan_chains.rpt
report_scan_cells -all -verbose > ./reports/SAF_int_report_scan_cells.rpt

#--------------------------------------------------------------
# Add Faults for Stuck-AT and Transition ATPG
#--------------------------------------------------------------
set_faults -model stuck
set_faults -fault_coverage
add_faults -all 

report_faults -summary
#--------------------------------------------------------------
# Run Transition ATPG
#--------------------------------------------------------------

set_atpg -coverage 100

set_sim -nopipeline_cells

report_setting atpg > ./reports/SAF_int_report_atpg_setting.rpt
report_settings simulation > ./reports/SAF_int_report_simulation_setting.rpt
run_atpg -auto

report_summaries > ./reports/SAF_int_report_summaries.rpt
report_patterns -all -type > ./reports/SAF_int_report_patterns.rpt

#--------------------------------------------------------------
# Write Transition Patterns
#--------------------------------------------------------------
write_patterns ./patterns/core_SAF_int_serial.stil -serial -format stil -replace
write_patterns ./patterns/core_SAF_int_parallel.stil -parallel -format stil -replace
write_patterns ./patterns/core_SAF.wgl -serial -format wgl -replace

#2024.12.10  modified by jamie
#write_testbench -input ./patterns/core_SAF_int_parallel.stil -output ./output/core_SAF_int_parallel -replace


