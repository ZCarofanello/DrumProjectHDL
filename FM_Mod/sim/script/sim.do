vlib work
vcom -93 -work work ../../FM_Mod.vhd
vcom -93 -work work ../../Freq2Steps/Freq2Steps.vhd
vcom -93 -work work ../../Freq2Steps/Freq2StepsMult.vhd
vcom -93 -work work ../../SineRom/SineRom.vhd
vcom -93 -work work ../../SineRom/SineRomMem.vhd
vcom -93 -work work ../../../ADSR/ADSR.vhd
vcom -93 -work work ../../../ADSR/FSM_ADSR.vhd
vcom -93 -work work ../../../ADSR/Generic_Counter.vhd
vcom -93 -work work ../../../ADSR/mult.vhd
vcom -93 -work work ../src/FM_Mod_tb.vhd
vsim -novopt FM_Mod_tb
do wave.do
run 1000 us
