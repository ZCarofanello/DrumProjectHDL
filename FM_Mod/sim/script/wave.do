onerror {resume}
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
add wave -noupdate /fm_mod_tb/uut/Audio_out
add wave -noupdate /fm_mod_tb/uut/audio2ADSR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {905 ns}
