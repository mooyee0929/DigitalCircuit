`timescale 1ns/1ps
module sort_mem_simple_tb;

real CYCLE=100; //You can change this to 10 to achieve fast simulation.

// Input signals
reg clk;
reg reset;
reg start_input;

// Output signals
wire done_out;
// Input/Output signals to sram
wire sram_en;
wire sram_we;
wire [3:0] sram_addr;
wire [7:0] data_sram2sort;
wire [7:0] data_sort2sram;

// Testbench signals declarations
wire sram_correct;
integer i, pat, aa, case_num;
reg [7:0]  new_data [0:15]; 
reg [7:0]  new_ans [0:15];
reg [7:0] temp;


mem_sort
#(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(4)
)
DUT
(
	.clk(clk),
	.reset(reset),
	.start(start_input),
	.done(done_out),

	.en(sram_en),
	.we(sram_we),
	.addr(sram_addr),

	.data_i(data_sram2sort),
	.data_o(data_sort2sram)
);

sram
#(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(4)
)
SRAM
(
	.clk(clk),
	.en(sram_en), // Enable the memory device.
	.we(sram_we), // we == 1 for write operation.
	.addr(sram_addr),
	.data_i(data_sort2sram),
	.data_o(data_sram2sort),
	.correct(sram_correct)
);

initial clk = 0;
always #(CYCLE/2.0) clk = ~clk;


initial begin
    // Setup the signal dump file.
    $dumpfile("sort_simple.vcd"); // Set the name of the dump file.
    $dumpvars;                   // Save all signals to the dump file.

    for (i = 0 ; i < 16 ; i = i + 1) begin
        //You can dump the array signals by this way
        // SRAM.RAM means the RAM signal in the module SRAM
        // answer is another array in the module SRAM
        // However, it cause warning, which you can ignore it.
        // more reference about dumpvars:
        // http://referencedesigner.com/tutorials/verilog/verilog_62.php
        // https://iverilog.fandom.com/wiki/Verilog_Portability_Notes#Dumping_array_words_.28.24dumpvars.29

        $dumpvars(0,SRAM.RAM[i]);
        $dumpvars(0,SRAM.answer[i]);
    end

    // Initialize the input signals
	start_input = 0;
	clk = 0;
	reset = 0;

	@(posedge clk);	//Initialize reset
	#1;				//Simulate flip-flop delay
	reset = 1;		//positive reset
	@(posedge clk);	//Initialize reset
	#1;				//Simulate flip-flop delay
	reset = 0;
	@(posedge clk);	//Initialize reset
	#1;				//Simulate flip-flop delay

	@(posedge clk);	//Initialize reset
	#1;				//Simulate flip-flop delay
	start_input = 1;
	@(posedge clk);	//Initialize reset
	#1;				//Simulate flip-flop delay
	start_input = 0;

	@(posedge clk);	//Initialize reset
	#1;				//Simulate flip-flop delay
	//Note: Your program should not finish this case in one cycle.

	while (!done_out) begin
		@(posedge clk);	//Initialize reset
		#1;				//Simulate flip-flop delay
	end
	if (sram_correct) begin
		$display("=========================");
        $display("Congratulations!!! Case %d pass", 1);
        $display("=========================");
		@(posedge clk);
    end else begin
        $display("Case %d failed", 1);
        $display("some errors happened!!!");
		for (i = 0 ; i < 16 ; i = i + 1) begin
			$display("sram[%d] = %d, correct[%d] = %d",i, SRAM.RAM[i] , i , SRAM.answer[i]);
		end
		@(posedge clk);
        // $finish;
	end

	//----------------------- test case --------------------------------------------	
	case_num = 2;
	pat = $fopen("input.txt", "r");

	while(!$feof(pat)) begin
		@(posedge clk);
		
		for(i = 0; i < 32; i = i + 1) begin
			aa = $fscanf(pat, "%d\n", temp);
			if(i<16) new_data[i] = temp;
			else new_ans[i%16] = temp;  
		end

		for(i = 0; i < 16; i = i + 1) begin
			SRAM.RAM[i] = new_data[i];
			SRAM.answer[i] = new_ans[i];
		end
		
		@(posedge clk);	//Initialize reset
		#1;				//Simulate flip-flop delay
		start_input = 1;
		@(posedge clk);	//Initialize reset
		#1;				//Simulate flip-flop delay
		start_input = 0;

		@(posedge clk);	//Initialize reset
		#1;				//Simulate flip-flop delay
		//Note: Your program should not finish this case in one cycle.

		while (!done_out) begin
			@(posedge clk);	//Initialize reset
			#1;				//Simulate flip-flop delay
		end
		if (sram_correct) begin
			$display("=========================");
			$display("Congratulations!!! Case %d pass", case_num);
			$display("=========================");
			@(posedge clk);
		end else begin
			$display("Case %d failed", case_num);
			$display("some errors happened!!!");
			for (i = 0 ; i < 16 ; i = i + 1) begin
				$display("sram[%d] = %d, correct[%d] = %d",i, SRAM.RAM[i] , i , SRAM.answer[i]);
			end
			@(posedge clk);
			// $finish;
		end

		case_num = case_num + 1;
	end
	
	//--------------------------------------------------------------------------------
	$finish;
end

endmodule






