////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	pixel_generator.v
//
// Purpose:	Transform some data points into 
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2018, Gisselquist Technology, LLC
// Copyright (C) 2022, Jan Braun
//
// This program is free software (firmware): you can redistribute it and/or
// modify it under the terms of  the GNU General Public License as published
// by the Free Software Foundation, either version 3 of the License, or (at
// your option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
// target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
//
// License:	GPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/gpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype	none
//
module	pixel_generator(i_pixclk, i_reset,
		// External connections
		i_width, i_height,
		i_rd, i_newline, i_newframe,
		// VGA connections
		o_pixel);
	parameter	BITS_PER_COLOR = 4,
			HW=12, VW=12;
		//HW=13,VW=11;
	localparam	BPC = BITS_PER_COLOR,
			BITS_PER_PIXEL = 3 * BPC,
			BPP = BITS_PER_PIXEL,
			TETRIS_ROWS = 16;
	//
	input	wire			i_pixclk, i_reset;
	input	wire	[HW-1:0]	i_width;
	input	wire	[VW-1:0]	i_height;
	//
	input	wire		i_rd, i_newline, i_newframe;
	//
	output	reg	[(BPP-1):0]	o_pixel;

	wire	[HW-1:0]	tblock_size = i_height / TETRIS_ROWS;
	wire	[HW-1:0]	outer_space = ( i_width - (10 * tblock_size) ) / 2;

	wire	[BPP-1:0]	white, black;

	assign	white = {(BPP){1'b1}};
	assign	black = {(BPP){1'b0}};

	reg	[HW-1:0]	hpos, hedge;
	reg	[VW-1:0]	ypos, yedge;
	reg	[3:0]		yline, hbar, mycount;

	
	reg	dline;
	always @(posedge i_pixclk)
	if ((i_reset)||(i_newframe)||(i_newline))
		dline <= 1'b0;
	else if (i_rd)
		dline <= 1'b1;
	
	// vertical
	always @(posedge i_pixclk)
	if ((i_reset)||(i_newframe))
	begin
		ypos  <= 0;
		yline <= 0;
		yedge <= { 4'h0, i_height[(VW-1):4] };
	end else if (i_newline)
	begin
		ypos <= ypos + { {(VW-1){1'h0}}, dline };
		if (ypos >= yedge)
		begin
			yline <= yline + 1'b1;
			yedge <= yedge + { 4'h0, i_height[(VW-1):4] };
		end
	end

	// horizontal
	initial	hpos  = 0;
	initial	hbar  = 0;
	initial	hedge = 0; // { 4'h0, i_width[(HW-1):4] };
	always @(posedge i_pixclk)
	if ((i_reset)||(i_newline))
	begin
		hpos <= 0;
		hbar <= 0;
		hedge <= outer_space + tblock_size;
	end else if (i_rd)
	begin
		hpos <= hpos + 1'b1;
		if (hpos >= hedge)
		begin
			hbar <= hbar + 1'b1;
			hedge <= hedge + tblock_size;
		end
	end

	reg	[BPP-1:0]	pattern;

	tetris #(.TETRIS_ROWS(TETRIS_ROWS), .BPP(BPP), .BPC(BPC))
    	tetris_box(.i_pixclk(i_pixclk), .i_newframe(i_newframe),
			.i_x(hbar), .i_y(yline),
			.o_pixel(pattern));

	// pixel generator
	always @(posedge i_pixclk)
	if (i_rd)
	begin
		if ((hpos == outer_space) || (hpos == i_width - outer_space))
			o_pixel <= white;
		else if ((hpos < outer_space) || (hpos > i_width - outer_space))
			o_pixel <= black;
		else if ((ypos == 0) || (ypos == i_height-1))
			o_pixel <= white;
		else
			o_pixel <= pattern;
	end

endmodule
