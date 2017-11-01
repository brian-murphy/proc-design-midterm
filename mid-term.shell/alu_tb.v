`timescale 1ns/1ps
module alu_tb();

    localparam OPCODE_WIDTH = 2;
    localparam DATA_WIDTH = 4;


    reg clk, reset, enable;
    reg [OPCODE_WIDTH - 1 : 0] op_code;
    reg [DATA_WIDTH - 1 : 0] op0;
    reg [DATA_WIDTH - 1 : 0] op1;
    wire [DATA_WIDTH - 1 : 0] out;

    alu #(DATA_WIDTH, OPCODE_WIDTH) test_alu (clk, reset, enable, op_code, op0, op1, out); 

    initial begin

        op_code = 0;
        op0 = 2;
        op1 = 2;
        #2;
        $display("2 + 2 = %d", out);

        op_code = 1;
        #2;
        $display("2 - 2 = %d", out);

        op_code = 2;
        #2;
        $display("2 * 2 = %d", out);
    end

endmodule