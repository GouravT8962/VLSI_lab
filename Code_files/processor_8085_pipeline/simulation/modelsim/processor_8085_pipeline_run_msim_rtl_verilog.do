transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/adder_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/RF_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/flag.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/ALU_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/controller_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/ACC_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/alucontrol_8085_single.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/processor_8085_pipeline.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/DM_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/hazard_control_8085.v}
vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/IM_8085.v}

vlog -vlog01compat -work work +incdir+/home/alex/verilog_codes/processor_8085_pipeline {/home/alex/verilog_codes/processor_8085_pipeline/generic_testbench_pipeline_8085.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  generic_testbench_pipeline_8085

add wave *
view structure
view signals
run -all
