vlib work
vcom -93 -work work ../../SineRom.vhd
vcom -93 -work work ../../SineRomMem.vhd
vcom -93 -work work ../../../Freq2Steps/Freq2StepsMult.vhd
vcom -93 -work work ../../../Freq2Steps/Freq2StepsMult.vhd
vcom -93 -work work ../src/SineRom_tb.vhd
vsim -novopt SineRom_tb
do wave.do
run 1000 ns
