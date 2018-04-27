onerror {resume}
radix define ADSR_FSM {
    "5'b00000" "Reset" -color "yellow",
    "5'b00001" "Ready" -color "green",
    "5'b00010" "Attack" -color "orange",
    "5'b00100" "Decay" -color "magenta",
    "5'b01000" "Sustain" -color "cyan",
    "5'b10000" "Release" -color "medium orchid",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fm_mod_tb/uut/clk
add wave -noupdate /fm_mod_tb/uut/reset_n
add wave -noupdate /fm_mod_tb/uut/Data_Req
add wave -noupdate /fm_mod_tb/uut/Trigger
add wave -noupdate /fm_mod_tb/uut/Pitch
add wave -noupdate /fm_mod_tb/uut/Modulation_Dat
add wave -noupdate /fm_mod_tb/uut/Att_M
add wave -noupdate /fm_mod_tb/uut/Att_D
add wave -noupdate /fm_mod_tb/uut/Dec_M
add wave -noupdate /fm_mod_tb/uut/Dec_D
add wave -noupdate /fm_mod_tb/uut/Sus_D
add wave -noupdate /fm_mod_tb/uut/Rel_M
add wave -noupdate /fm_mod_tb/uut/Rel_D
add wave -noupdate -format Analog-Step -height 74 -max 16384.0 -min -16384.0 -radix decimal /fm_mod_tb/uut/Audio_out
add wave -noupdate -format Analog-Step -height 84 -max 16384.0 -min -16384.0 -radix decimal /fm_mod_tb/uut/audio2ADSR
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/clk
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/reset_n
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/data_req
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/trigger
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Att_M
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Att_D
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Dec_M
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Dec_D
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Sus_D
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Rel_M
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Rel_D
add wave -noupdate -expand -group ADSR -format Analog-Step -height 74 -max 16384.0 -min -16384.0 /fm_mod_tb/uut/ADSR_inst/Audio_in
add wave -noupdate -expand -group ADSR -format Analog-Step -height 74 -max 8182.9999999999991 -min -8192.0 /fm_mod_tb/uut/ADSR_inst/Audio_out
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/CounterReset
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/change_state
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Cnt_Flag
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/Max_Cnt_int
add wave -noupdate -expand -group ADSR -format Analog-Step -height 74 -max 8182.9999999999991 -min -8192.0 /fm_mod_tb/uut/ADSR_inst/audio_mult_out
add wave -noupdate -expand -group ADSR -format Analog-Step -height 74 -max 32767.0 /fm_mod_tb/uut/ADSR_inst/current_slope_int
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/current_slope_inc
add wave -noupdate -expand -group ADSR /fm_mod_tb/uut/ADSR_inst/audio_mult_out_full
add wave -noupdate -expand -group ADSR -radix ADSR_FSM /fm_mod_tb/uut/ADSR_inst/state
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/clk
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/reset_n
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/enable
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/max_count
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/output
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/count_sig
add wave -noupdate -expand -group Counter /fm_mod_tb/uut/ADSR_inst/counter_inst/output_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {95380000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1050 us}
