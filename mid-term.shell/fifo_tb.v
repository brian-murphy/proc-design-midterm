`timescale 1ns/1ps
module fifo_tb();

localparam DATA_WIDTH = 8;
localparam ADDR_WIDTH = 4;
localparam FIFO_DEPTH = (1 << ADDR_WIDTH);


reg clk, reset, enq, deq;
reg [DATA_WIDTH - 1 : 0] data_in;

wire [DATA_WIDTH - 1 : 0] data_out;
wire empty, full;

fifo
#(
    .DATA_WIDTH (DATA_WIDTH),
    .ADDR_WIDTH (ADDR_WIDTH)
) test_fifo (clk, reset, enq, deq, data_in, data_out, empty, full);


integer i;

initial begin
    clk = 1'b0;
    reset = 1'b1;
    enq = 1'b1;
    deq = 1'b1;
    #4
    @(posedge clk);

    data_in = 0;
    enq = 1'b1;
    deq = 1'b0;
    reset = 1'b0;
    @(posedge clk);

    $display("isEmpty expected 1, actual %d", empty);

    while (full == 1'b0) begin
        $display("data_in: %d", data_in);
        data_in = data_in + 1;
        @(posedge clk);
    end

    $display("isFull=%d, isEmpty=%d", full, empty);

    enq = 1'b0;
    deq = 1'b1;
    @(posedge clk);

    while (empty == 1'b0) begin
        @(posedge clk);
        $display("data_out=%d", data_out);
    end

    $display("isFull=%d, isEmpty=%d", full, empty);
end


always #2 clk = ~clk;

endmodule