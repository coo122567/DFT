
# stuck-at
#tmax2q -nogui scripts/tmax_atpg_parametrize.tcl -env syn $syn -env sim $sim -env fmodel sa  -env spf sccomp -env lp 100 -env drc_only n
#tmax2 -nogui tmax_saf_comp.tcl  -env fmodel sa  -env spf sccomp  -env drc_only n

tmax2 -s tmax_saf_comp.tcl
tmax2 -s tmax_saf_int.tcl
