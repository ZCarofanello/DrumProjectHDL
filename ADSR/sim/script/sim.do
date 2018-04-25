vlib work
vcom -93 -work work ../../ADSR.vhd
vcom -93 -work work ../../FSM_ADSR.vhd
vcom -93 -work work ../../mult.vhd
vcom -93 -work work ../../Generic_Counter.vhd
vcom -93 -work work ../src/ADSR_tb.vhd
vsim -novopt ADSR_tb
do wave.do
run 50 us
