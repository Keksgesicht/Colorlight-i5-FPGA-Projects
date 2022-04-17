# HDMI Tetris

I've taken the idea of a low-level video generator from Dan Gisselquist's
[llvga.v](https://github.com/ZipCPU/vgasim/blob/master/rtl/llvga.v) module
and also the
[HDMI code from Emard](https://github.com/DoctorWkt/Verilog_tic-tac-toe/tree/master/HDMI), and I've created a _llhdmi.v_ video generating module.

I have also taken Dan Gisselquist's
[vgatestsrc.v](https://github.com/ZipCPU/vgasim/blob/master/rtl/vgatestsrc.v)
test pattern generator, and built a ULX3S project that displays the test
pattern on the HDMI output.

Project structure inspired by
[hdmi_test_pattern](https://github.com/wuxx/Colorlight-FPGA-Projects/tree/master/src/i5/hdmi_test_pattern)

Play Tetris on the HDMI output of the Colorlight i5 Development Board.

Gerenate the bitstream with: ```make```.
