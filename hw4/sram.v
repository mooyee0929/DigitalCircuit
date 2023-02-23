//
// This module implements an 8-bit synchronous SRAM device with
// 32 memory cells. Note that the memory device can be read anytime,
// but only writable when 'we' is set to 1.
//

module sram
#(parameter DATA_WIDTH = 8, ADDR_WIDTH = 4)
 (input clk,
  input en, // Enable the memory device.
  input we, // we == 1 for write operation.
  input  [ADDR_WIDTH-1 : 0] addr,
  input  [DATA_WIDTH-1 : 0] data_i,
  output reg [DATA_WIDTH-1 : 0] data_o,
  output correct);

localparam RAM_SIZE = 2**ADDR_WIDTH;

// Declareation of the memory cells
reg [DATA_WIDTH-1 : 0] RAM [RAM_SIZE-1 : 0];

// Declareation of the answer array
reg [DATA_WIDTH-1 : 0] answer [RAM_SIZE-1 : 0];

// ------------------------------------
// RAM cell initialization
// ------------------------------------
initial begin
    RAM[ 0] = 8'd34;
    RAM[ 1] = 8'd215;
    RAM[ 2] = 8'd122;
    RAM[ 3] = 8'd17;
    RAM[ 4] = 8'd77;
    RAM[ 5] = 8'd67;
    RAM[ 6] = 8'd63;
    RAM[ 7] = 8'd194;
    RAM[ 8] = 8'd139;
    RAM[ 9] = 8'd24;
    RAM[10] = 8'd71;
    RAM[11] = 8'd244;
    RAM[12] = 8'd246;
    RAM[13] = 8'd40;
    RAM[14] = 8'd247;
    RAM[15] = 8'd66;

    answer[ 0] = 8'd247;
    answer[ 1] = 8'd246;
    answer[ 2] = 8'd244;
    answer[ 3] = 8'd215;
    answer[ 4] = 8'd194;
    answer[ 5] = 8'd139;
    answer[ 6] = 8'd122;
    answer[ 7] = 8'd77;
    answer[ 8] = 8'd71;
    answer[ 9] = 8'd67;
    answer[10] = 8'd66;
    answer[11] = 8'd63;
    answer[12] = 8'd40;
    answer[13] = 8'd34;
    answer[14] = 8'd24;
    answer[15] = 8'd17;
end

assign correct = (RAM[ 0] == answer[ 0]) &&
                 (RAM[ 1] == answer[ 1]) &&
                 (RAM[ 2] == answer[ 2]) &&
                 (RAM[ 3] == answer[ 3]) &&
                 (RAM[ 4] == answer[ 4]) &&
                 (RAM[ 5] == answer[ 5]) &&
                 (RAM[ 6] == answer[ 6]) &&
                 (RAM[ 7] == answer[ 7]) &&
                 (RAM[ 8] == answer[ 8]) &&
                 (RAM[ 9] == answer[ 9]) &&
                 (RAM[10] == answer[10]) &&
                 (RAM[11] == answer[11]) &&
                 (RAM[12] == answer[12]) &&
                 (RAM[13] == answer[13]) &&
                 (RAM[14] == answer[14]) &&
                 (RAM[15] == answer[15]);

// ------------------------------------
// RAM data output port
// ------------------------------------
always@(posedge clk)
begin
  if (en & we)
    data_o <= data_i;
  else
    data_o <= RAM[addr];
end

// -------------------------------------------------
// RAM data input port (only for write operations)
// -------------------------------------------------
always@(posedge clk)
begin
  if (en & we)
    RAM[addr] <= data_i;
end

endmodule

