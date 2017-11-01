`timescale 1ns/1ps
module alu
#(  // Parameters
    parameter   DATA_WIDTH          = 4,                  // Width of data
    parameter   OPCODE_WIDTH        = 2                   // Width of op code
)(  // Ports
    input  wire                           clk,
    input  wire                           reset,
    input  wire                           enable,
    input  wire [ OPCODE_WIDTH  -1 : 0 ]  op_code,
    input  wire [ DATA_WIDTH    -1 : 0 ]  op0,
    input  wire [ DATA_WIDTH    -1 : 0 ]  op1,
    output wire [ DATA_WIDTH    -1 : 0 ]  out
);

// ******************************************************************
// Your logic here ->
// ******************************************************************


// ******************************************************************


endmodule
