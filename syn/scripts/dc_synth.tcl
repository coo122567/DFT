
###### Synthesis Script #######

lappend search_path .
## Define the library location
set search_path [concat ../src ../../libs/db  ${search_path}]
set target_library [list saed32rvt_tt1p05v125c.db   ]
set synthetic_library dw_foundation.sldb
set link_library [concat {*} ${target_library} ${synthetic_library} saed32rvt_tt1p05v125c.db ]
## Give the path to the verilog files and define the WORK directory
define_design_lib WORK -path "work"

## read the verilog files
#
set DESIGN core
analyze -format sverilog -vcs "-f ../src/sources.f"

elaborate $DESIGN
link


set compile_enable_constant_propagation_with_no_boundary_opt false
set compile_preserve_subdesign_interfaces true

## Create Constraints 
create_clock CLK -name clock1 -period 4
set_input_delay 1.0 [ remove_from_collection [all_inputs] clock ] -clock clock1
set_output_delay 1.0 [all_outputs ] -clock clock1


compile -scan

#set_max_area 0 
#set_max_leakage_power 0.0
set uniquify_naming_style "${DESIGN}_%s_%d"
uniquify -force

## Below commands report area , cell, qor, resources, and timing information needed to analyze the design. 

report_area                          > ../reports/synth_area.rpt
report_design                        > ../reports/synth_design.rpt
report_cell                          > ../reports/synth_cells.rpt
report_qor                           > ../reports/synth_qor.rpt
report_resources                     > ../reports/synth_resources.rpt
report_timing -max_paths 10          > ../reports/synth_timing.rpt
report_power -analysis_effort medium > ../reports/synth_power.rpt

## Dump out the constraints in an SDC file
write_sdc ../const/${DESIGN}.syn.sdc -version 1.9

## Dump out the synthesized database and gate-level-netlist
#
change_names -rules verilog -hierarchy
write -f ddc -hierarchy -output ../output/${DESIGN}.post.ddc

write -hierarchy -format verilog -output  ../output/${DESIGN}_HDL.v

exit
