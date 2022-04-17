
module	tetris(i_pixclk, i_newframe,
                i_x, i_y,
                o_pixel);

    parameter	TETRIS_ROWS = 16,
                BPP = 24, BPC = 8;

    input   wire    i_pixclk, i_newframe;
	input	wire	[3:0]    i_x,  i_y;
    output  wire	[BPP-1:0]   o_pixel;

    reg [7:0]	Tetris_level;
	initial		Tetris_level = 0;
	wire[7:0]	move_clock_count = 100 - Tetris_level;

    reg [BPP-1:0] pixel_map [0:10-1][0:TETRIS_ROWS-1];

    always @(posedge i_pixclk)
    begin
        o_pixel <= pixel_map[i_x][i_y];
    end

    reg [3:0] m = 0;
    reg [7:0] n;

    always @(posedge i_newframe)
    begin
        n <= n + 1;
        if (n == 0)
        begin
            m <= m + 1;
            pixel_map[5][m] <= { 16'b0, 2'b1, 6'b0 };
        end
    end

endmodule
