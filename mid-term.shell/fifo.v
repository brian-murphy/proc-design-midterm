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
wire next_in_index;

counter #(ADDR_WIDTH) next_in_counter(clk, reset, enq, next_in_index);

// ******************************************************************


endmodule
