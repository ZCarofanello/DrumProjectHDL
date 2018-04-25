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
add wave -noupdate /adsr_tb/uut/clk
add wave -noupdate /adsr_tb/uut/reset_n
add wave -noupdate /adsr_tb/uut/data_req
add wave -noupdate /adsr_tb/uut/trigger
add wave -noupdate /adsr_tb/uut/Att_M
add wave -noupdate /adsr_tb/uut/Att_D
add wave -noupdate /adsr_tb/uut/Dec_M
add wave -noupdate /adsr_tb/uut/Dec_D
add wave -noupdate /adsr_tb/uut/Sus_D
add wave -noupdate /adsr_tb/uut/Rel_M
add wave -noupdate /adsr_tb/uut/Rel_D
add wave -noupdate -format Analog-Step -height 84 -max 416.0 -min 336.0 -radix decimal /adsr_tb/uut/Audio_in
add wave -noupdate -format Analog-Step -height 84 -max 32592.0 -min -32624.0 -radix decimal /adsr_tb/uut/Audio_out
add wave -noupdate /adsr_tb/uut/CounterReset
add wave -noupdate /adsr_tb/uut/change_state
add wave -noupdate /adsr_tb/uut/Cnt_Flag
add wave -noupdate /adsr_tb/uut/Max_Cnt_int
add wave -noupdate /adsr_tb/uut/audio_mult_out
add wave -noupdate -radix decimal /adsr_tb/uut/current_slope_int
add wave -noupdate -radix decimal /adsr_tb/uut/current_slope_inc
add wave -noupdate /adsr_tb/uut/audio_mult_out_full
add wave -noupdate -radix ADSR_FSM /adsr_tb/uut/state
add wave -noupdate -group Counter /adsr_tb/uut/counter_inst/clk
add wave -noupdate -group Counter /adsr_tb/uut/counter_inst/reset_n
add wave -noupdate -group Counter /adsr_tb/uut/counter_inst/enable
add wave -noupdate -group Counter -radix unsigned /adsr_tb/uut/counter_inst/max_count
add wave -noupdate -group Counter /adsr_tb/uut/counter_inst/output
add wave -noupdate -group Counter -radix unsigned /adsr_tb/uut/counter_inst/count_sig
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/clk
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/reset_n
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/data_req
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/trig_sig
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/timer_sig
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/change_state
add wave -noupdate -expand -group FSM -radix ADSR_FSM /adsr_tb/uut/FSM_ADSR_inst/current_state
add wave -noupdate -expand -group FSM -radix ADSR_FSM /adsr_tb/uut/FSM_ADSR_inst/current_state_int
add wave -noupdate -expand -group FSM -radix ADSR_FSM /adsr_tb/uut/FSM_ADSR_inst/next_state
add wave -noupdate -expand -group FSM /adsr_tb/uut/FSM_ADSR_inst/change_state_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12020000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
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
WaveRestoreZoom {0 ps} {52500 ns}
