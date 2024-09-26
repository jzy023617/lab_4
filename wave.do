onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/top_inst/ack
add wave -noupdate /tb_top/top_inst/cur_state
add wave -noupdate /tb_top/YC
add wave -noupdate /tb_top/led
add wave -noupdate /tb_top/segH
add wave -noupdate /tb_top/segL
add wave -noupdate /tb_top/sys_clk
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4950000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {3076789 ps} {10202467 ps}
