define_design_lib WORK -path ./WORK

set_app_var target_library "../../flow/stdcells.db"
set_app_var link_library "* ../../flow/stdcells.db"

########################################################
# 1. change the verilog file that you want to synthesize
set my_verilog_files [list ../../src/cpu_comp.v]

# 2. change the toplevel module as needed
set my_toplevel cpu

# 3. change the clock frequency in Mega Hertz 
set my_clk_freq_MHz 30
#######################################################
set my_clock_pin clk
set my_input_delay_ns 0.1
set my_output_delay_ns 0.1

set verilogout_show_unconnected_pins "true"
set_ultra_optimization true
set_ultra_optimization -force

analyze -format verilog $my_verilog_files
elaborate $my_toplevel
current_design $my_toplevel
link
uniquify

set my_period [expr 1000 / $my_clk_freq_MHz]

set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}

set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]

compile -ungroup_all -map_effort medium
compile -incremental_mapping -map_effort medium
check_design

report_constraint -all_violators

set filename [format "%s%s" $my_toplevel "-post-syn.v"]
write -format verilog -output $filename
set filename [format "%s%s" $my_toplevel "-post-syn.sdc"]
write_sdc $filename

redirect timing.rep { report_timing }
redirect cell.rep { report_cell }
redirect power.rep { report_power }

quit
