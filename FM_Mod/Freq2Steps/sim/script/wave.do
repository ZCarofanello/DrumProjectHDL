onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /freq2steps_tb/uut/i_clk
add wave -noupdate /freq2steps_tb/uut/i_reset_n
add wave -noupdate -radix unsigned /freq2steps_tb/uut/i_Frequency
add wave -noupdate -radix unsigned /freq2steps_tb/uut/o_Steps
add wave -noupdate /freq2steps_tb/uut/Mult_Out_Full
add wave -noupdate /freq2steps_tb/uut/Mult_Out_Concat
add wave -noupdate /freq2steps_tb/uut/Freq_In_Ext
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {141 ns} 0}
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
WaveRestoreZoom {8 ns} {913 ns}
