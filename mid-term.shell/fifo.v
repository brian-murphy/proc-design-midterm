`timescale 1ns/1ps
module fifo
#(  // Parameters
    parameter   DATA_WIDTH          = 64,
    parameter   ADDR_WIDTH          = 4,
    parameter   FIFO_DEPTH          = (1 << ADDR_WIDTH)
)(  // Ports
    input  wire                         clk,
    input  wire                         reset,
    input  wire                         enq,
    input  wire                         deq,
    input  wire [ DATA_WIDTH -1 : 0 ]   data_in,
    output reg  [ DATA_WIDTH -1 : 0 ]   data_out,
    output reg                          empty,
    output reg                          full
);

// ******************************************************************
// your logic here ->
// ******************************************************************

reg [DATA_WIDTH - 1 : 0] data [ADDR_WIDTH - 1 : 0];

reg should_sample_data_in;
reg [ADDR_WIDTH - 1 : 0] in_index;

wire next_in_index;

counter #(ADDR_WIDTH) next_in_counter(clk, reset, enq, next_in_index);

always @(posedge clk) begin 

    if (reset == 1'b1) begin
        should_sample_data_in <= 0;
        in_index <= 0;
        empty = 1'b1;

    end else begin
        if (should_sample_data_in == 1'b1) begin
            data[in_index] <= data_in;
            ///TODO
        if (enq == 1'b1) begin
            should_sample_data_in <= 1'b1;
            in_index <= next_in_index;
        end else
            should_sample_data_in <= 1'b0;
    end
end

// ******************************************************************


endmodule
