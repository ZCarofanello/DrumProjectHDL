vlib work
vcom -93 -work work ../../Freq2Steps.vhd
vcom -93 -work work ../../Freq2StepsMult.vhd
vcom -93 -work work ../src/Freq2Steps_tb.vhd
vsim -novopt Freq2Steps_tb
do wave.do
run 1000 ns
