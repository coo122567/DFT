
lappend search_path .
## Define the library location
set search_path [concat ../src ../../libs/db  ${search_path}]
set target_library [list saed32rvt_tt1p05v125c.db   ]
set synthetic_library dw_foundation.sldb
set link_library [concat {*} ${target_library} ${synthetic_library} saed32rvt_tt1p05v125c.db]
## Give the path to the verilog files and define the WORK directory
define_design_lib WORK -path "work"

set test_stil_netlist_format  verilog
set test_default_bidir_delay  0
set_app_var test_default_delay 0.000000
set_app_var test_default_period 100.000000
set_app_var test_default_strobe 40.000000

set DESIGN core
read_verilog -netlist ../output/${DESIGN}_HDL.v
current_design ${DESIGN}
#Read ctl model of memory macro
#read_test_model -design sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00 -format ctl  ../../libs/ctl/sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00.ctl

current_design ${DESIGN}
link


set test_keep_connected_scan_en true

# DFT Constraints
set_dft_drc_configuration -internal_pins enable



set_scan_configuration  -chain_count 3  -style multiplexed_flip_flop
set_scan_compression_configuration -chain 20
set_dft_configuration -scan_compression enable

create_port -direction in ScanEnable
create_port -direction in COMP_MODE
create_port -direction in SI0
create_port -direction in SI1
create_port -direction in SI2
create_port -direction out SO0
create_port -direction out SO1
create_port -direction out SO2

set_dft_signal -view existing_dft -type ScanClock -timing {45 55} -port CLK
set_dft_signal -type Reset -view exiting_dft -port RST -active_state 0
set_dft_signal -view existing -type ScanEnable  -port ScanEnable
set_dft_signal -view spec -type ScanEnable      -port ScanEnable
set_dft_signal -view spec -type ScanDataIn -port SI0 
set_dft_signal -view spec -type ScanDataIn -port SI1 
set_dft_signal -view spec -type ScanDataIn -port SI2 
set_dft_signal -view spec -type ScanDataOut -port SO0
set_dft_signal -view spec -type ScanDataOut -port SO1
set_dft_signal -view spec -type ScanDataOut -port SO2

######################################################################
###        TESTPOINT INSERTION DEFINITION ############################
######################################################################
#set_dft_configuration -testability enable
#set_dft_signal -view spec -type TestMode -port test_mode -test_mode all
#
#set_testability_configuration -target { random_resistant }   \
#                              -control_signal test_mode \
#                              -effort high
#set_testability_configuration -target { untestable_logic } \
#                              -control_signal test_mode \
#                              -max_test_points 1000


######################################################################



create_test_protocol -infer_clock
dft_drc -pre_dft      > ../reports/predft_drc.rpt

# run advisor to get test report for preview_dft & insert_dft 
#run_test_point_analysis

preview_dft -show all > ../reports/preview_dft.rpt
insert_dft            > ../reports/insert_dft.rpt
dft_drc               > ../reports/postdft_drc.rpt

report_scan_path -view existing -chain all > ../reports/scan_path.rpt
report_scan_chain                          > ../reports/scan_chain.rpt

change_names -rules verilog -hierarchy
write -format verilog -hierarchy -output ../output/${DESIGN}_scan.v
write -format ddc -hierarchy -output ../output/${DESIGN}_scan.ddc
write_test_protocol -output ../output/${DESIGN}_comp.spf -test_mode ScanCompression_mode
write_test_protocol -output ../output/${DESIGN}_scan.spf -test_mode Internal_scan

write_scan_def -output ../output/${DESIGN}_scan.scandef

exit
