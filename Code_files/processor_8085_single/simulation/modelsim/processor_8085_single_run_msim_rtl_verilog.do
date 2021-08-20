transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/flag.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/ALU_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/alucontrol_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/processor_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/RF_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/adder_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/DM_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/ACC_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/controller_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single/db {/home/alex/verilog_codes/processor_8085_single/db/pll_8085_altpll.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/IM_8085.v}
vcom -93 -work work {/home/alex/verilog_codes/processor_8085_single/pll_8085.vhd}

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_single {/home/alex/verilog_codes/processor_8085_single/generic_testbench_single_8085.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  generic_testbench_single_8085

add wave *
view structure
view signals
run -all
