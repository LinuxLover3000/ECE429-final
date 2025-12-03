set init_mmmc_file "../../flow/setup-timing.tcl"

#############################################
# 1. change the synthesized verilog file name
set init_verilog "cpu-post-syn.v"
# 2. change the top cell name 
set init_top_cel "cpu"
#############################################

set init_lef_file "../../flow/rtk-tech.lef ../../flow/stdcells.lef"
set init_gnd_net "gnd"
set init_pwr_net "vdd"

init_design

setAnalysisMode -analysisType onChipVariation -cppr both

globalNetConnect vdd -type pgpin -pin vdd -inst * -verbose
globalNetConnect gnd -type pgpin -pin gnd -inst * -verbose

sroute -nets {vdd gnd}

floorplan -r 1.0 0.7 4.0 4.0 4.0 4.0

addRing -nets {vdd gnd} -width 0.6 -spacing 0.5 \
            -layer [list top 7 bottom 7 left 6 right 6]

addStripe -nets {gnd vdd} -layer 6 -direction vertical \
            -width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5

addStripe -nets {gnd vdd} -layer 7 -direction horizontal \
            -width 0.4 -spacing 0.5 -set_to_set_distance 5 -start 0.5

place_design

assignIoPins -pin *

ccopt_design

setOptMode -holdFixingCells {BUF_X1}
setOptMode -holdTargetSlack 0.013 -setupTargetSlack 0.044;
optDesign -postCTS -outDir timingReports -prefix postCTS_hold -hold

routeDesign 
optDesign -postRoute -outDir timingReports -prefix postRoute_hold -hold


setFillerMode -corePrefix FILL -core "FILLCELL_X4 FILLCELL_X2 FILLCELL_X1"
addFiller

verifyConnectivity
verify_drc

saveNetlist final.v

streamOut final.gds \
            -merge "../../flow/stdcells.gds" \
            -mapFile "../../flow/rtk-stream-out.map"

puts "**************************************"
puts "* Innovus script finished            *"
puts "*                                    *"
puts "* Results:                           *"
puts "* --------                           *"
puts "* Layout:  final.gds2                *"
puts "* Netlist: final.v                   *"
puts "* Timing:  report_timing	           *"
puts "* Area:    report_area               *"
puts "* Power:   report_power              *"
puts "*                                    *"
puts "**************************************"
