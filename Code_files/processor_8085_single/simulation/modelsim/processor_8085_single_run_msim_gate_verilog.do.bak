transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {processor_8085_single_6_1200mv_85c_slow.vo}

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/processor_8085_single_tb5.v}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  processor_8085_single_tb5

add wave *
view structure
view signals
run -all
