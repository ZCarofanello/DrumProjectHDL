onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sinerom_tb/uut/clk
add wave -noupdate /sinerom_tb/uut/reset_n
add wave -noupdate /sinerom_tb/uut/Dat_Req
add wave -noupdate /sinerom_tb/uut/i_Frequency
add wave -noupdate /sinerom_tb/uut/Modulation_Dat
add wave -noupdate /sinerom_tb/uut/SineOut
add wave -noupdate /sinerom_tb/uut/CurrentCount
add wave -noupdate /sinerom_tb/uut/Pitch
add wave -noupdate /sinerom_tb/uut/Phase
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
WaveRestoreZoom {141 ns} {1046 ns}
