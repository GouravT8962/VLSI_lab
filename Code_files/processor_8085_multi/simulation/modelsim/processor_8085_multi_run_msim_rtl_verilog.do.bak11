transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/RF1.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/flag.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/ALU_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/temp.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/ir.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/processor_8085_multi.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/alu_control_8085_multi.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/controller_8085_multi.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/MEM_8085_multi.v}

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_multi {/home/alex/verilog_codes/processor_8085_multi/generic_testbench_multi_8085.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  generic_testbench_multi_8085

add wave *
view structure
view signals
run -all
