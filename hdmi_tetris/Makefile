YOSYS=yosys
NEXTPNR=nextpnr-ecp5
ECPPACK=ecppack
HDMICODE=llhdmi.v vgatestsrc.v
ENCODER=TMDS_encoder.v

.PHONY: all
all: hdmi_tetris.bit

hdmi_tetris.ys: hdmi_tetris.v $(HDMICODE) $(ENCODER) clock.v OBUFDS.v
	chmod +x ysgen.sh
	./ysgen.sh hdmi_tetris.v  $(HDMICODE) $(ENCODER) clock.v OBUFDS.v > hdmi_tetris.ys
	echo "hierarchy -top hdmi_tetris" >> hdmi_tetris.ys
	echo "synth_ecp5 -json hdmi_tetris.json" >> hdmi_tetris.ys

hdmi_tetris.json: hdmi_tetris.ys
	$(YOSYS) -q hdmi_tetris.ys

hdmi_tetris.config: hdmi_tetris.json
	$(NEXTPNR) --25k --package CABGA381 --lpf ulx3s_v20_segpdi.lpf \
	           --textcfg hdmi_tetris.config --json hdmi_tetris.json

hdmi_tetris.bit: hdmi_tetris.config
	$(ECPPACK) --input hdmi_tetris.config --bit hdmi_tetris.bit
        
.PHONY: clean
clean:
	rm -f hdmi_tetris.ys hdmi_tetris.json hdmi_tetris.config hdmi_tetris.bit
