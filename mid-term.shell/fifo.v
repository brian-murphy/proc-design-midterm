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

reg [DATA_WIDTH - 1 : 0] data [0 : ADDR_WIDTH - 1];


wire next_in_index;
counter #(ADDR_WIDTH) next_in_counter(clk, reset, enq, next_in_index);

wire next_out_index;
counter #(ADDR_WIDTH) next_out_counter(clk, reset, deq, next_out_index);


always @(posedge clk) begin 

    if (reset == 1'b1) begin
        empty <= 1'b1;
        full <=1'b0;
        data_out <= 0;

    end else begin
        if (enq == 1'b1)
            data[next_in_index] <= data_in;
        
        if (deq == 1'b1)
            data_out <= data[next_out_index];
    end
end

// ******************************************************************


endmodule
