transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/defination.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/ALU.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/PC.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/mux4.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/regfile.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/EXT.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/ram.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/Reg.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/riscv_top.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/Control_E.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/rom.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2 {C:/intelFPGA_lite/quartusprojects/riscv_top2/HazardUnit.v}

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/quartusprojects/riscv_top2/simulation/modelsim {C:/intelFPGA_lite/quartusprojects/riscv_top2/simulation/modelsim/tbriscv.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiv_hssi_ver -L cycloneiv_pcie_hip_ver -L cycloneiv_ver -L rtl_work -L work -voptargs="+acc"  tbriscv

add wave *
view structure
view signals
run -all
