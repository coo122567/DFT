#!/bin/csh -f 
#############################################################################
##        Copyright (c) 1988 - 2023 Synopsys, Inc. All rights reserved.     #
##                                                                          #
##  This Synopsys TestMAX product and all associated documentation are      #
##  proprietary to Synopsys, Inc. and may only be used pursuant to the      #
##  terms and conditions of a written license agreement with Synopsys, Inc. #
##  All other use, reproduction, modification, or distribution of the       #
##  Synopsys Testmax product or associated documentation is                 #
##  strictly prohibited.                                                    #
##                                                                          #
#############################################################################
##                                                                          #
##  Version    : U-2022.12-SP5                                              #
##  Created on : Mon Jul 31 10:00:00 IST 2023                               #
##                                                                          #
#############################################################################



cd WORK


# DC run to Synthesize RTL 
 dc_shell -64 -f ../scripts/dc_scan.tcl  | tee -i ../logs/dc_scan.log

cd ..
