#!/bin/csh -f

vcs -kdb -full64 -debug_all +tetramax -debug_access+dmptf -notice -timescale=1ns/10ps +define+tmax_diag=0 +define+tmax_msg=4 \
	+delay_mode_zero +notimingcheck \
	-v ../libs/vlg/saed32nm.v \
	-v ../libs/sms_sim_model/sadsls0c4l2p2048x32m8b1w0c0p0d0r1s2z1rw00.v \
	-v ../libs/sms_sim_model/std_cells.v \
	../syn/output/core_scan.v \
	./patterns/core_SAF_comp_parallel.v \
         -l ./logs/core_SAF_comp_parallel.log  
	#./output/core_SAF_comp_parallel.v \
  #       -l ./logs/core_SAF_comp_parallel.log

./simv | tee logs/core_SAF_comp_parallel.log

