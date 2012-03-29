vlog alu.v
vlog cpu.v
vlog cpu_tb.v
vlog instr_decode.v
vlog instr_mem.v
vlog reg_file.v
vlog program_counter.v

vsim -novopt cpu_tb

add wave -radix 16 -group {cpu} cpu/*
add wave -radix 16 -group {pc} cpu/program_counter/*
add wave -radix 16 -group {instr dec} cpu/instr_decode/*
add wave -radix 16 -group {alu} cpu/alu/*
add wave -radix 16 -group {reg f} cpu/reg_file/*
add wave -radix 16 -group {reg f} cpu/reg_file/fregs

run -all