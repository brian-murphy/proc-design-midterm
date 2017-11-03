`timescale 1ns/1ps
module processor
#(  // Parameters
  parameter   DATA_WIDTH          = 4,      // Width of data for ALUs and FIFOs
  parameter   INST_WIDTH          = 8,      // Width of instruction FIFO
  parameter   FIFO_ADDR_WIDTH     = 8,      // Width of FIFO address

  parameter   OPCODE_WIDTH        = 2,      // Width of op code
  parameter   SRC0_IDX_WIDTH      = 2,      // Width of src0 of operation
  parameter   SRC1_IDX_WIDTH      = 2,      // Width of src1 of operation
  parameter   DST0_IDX_WIDTH      = 1,      // Width of dst0 of operation
  parameter   DST1_IDX_WIDTH      = 1       // Width of dst1 of operation
)(  // Ports

  // clk and reset
  input  wire                               clk,
  input  wire                               reset,

  // For testbench only. DO NOT TOUCH -------------
  input  wire                               ctrl_fifo_enq,
  input  wire [ INST_WIDTH      -1 : 0 ]    ctrl_fifo_data_in,
  output wire                               ctrl_fifo_full,

  input  wire                               int_fifo_enq,
  input  wire [ DATA_WIDTH      -1 : 0 ]    int_fifo_data_in,
  output wire                               int_fifo_full,

  input  wire                               nin_fifo_enq,
  input  wire [ DATA_WIDTH      -1 : 0 ]    nin_fifo_data_in,
  output wire                               nin_fifo_full,

  input  wire                               nout_fifo_deq,
  output wire [ DATA_WIDTH      -1 : 0 ]    nout_fifo_data_out,
  output wire                               nout_fifo_empty,

  input  wire                               bus_fifo_deq,
  output wire [ DATA_WIDTH      -1 : 0 ]    bus_fifo_data_out,
  output wire                               bus_fifo_empty
  // For testbench only. end ----------------------
);

// ******************************************************************
// Internal variables
// ******************************************************************
  wire                               ctrl_fifo_deq;
  wire [ INST_WIDTH      -1 : 0 ]    ctrl_fifo_data_out;
  wire                               ctrl_fifo_empty;

  wire                               int_fifo_deq;
  wire [ DATA_WIDTH      -1 : 0 ]    int_fifo_data_out;
  wire                               int_fifo_empty;

  wire                               nin_fifo_deq;
  wire [ DATA_WIDTH      -1 : 0 ]    nin_fifo_data_out;
  wire                               nin_fifo_empty;

  wire                               nout_fifo_enq;
  wire [ DATA_WIDTH      -1 : 0 ]    nout_fifo_data_in;
  wire                               nout_fifo_full;

  wire                               bus_fifo_enq;
  wire [ DATA_WIDTH      -1 : 0 ]    bus_fifo_data_in;
  wire                               bus_fifo_full;

// ******************************************************************
// INSTANTIATIONS
// ******************************************************************

// =================================================================
// Control FIFO:
// This fifo holds the instructions for the processor
// =================================================================
  fifo #(
    .DATA_WIDTH               ( INST_WIDTH               ),
    .ADDR_WIDTH               ( FIFO_ADDR_WIDTH          )
  ) control_fifo (
    .clk                      ( clk                      ),  //input
    .reset                    ( reset                    ),  //input
    .enq                      ( ctrl_fifo_enq            ),  //input
    .deq                      ( ctrl_fifo_deq            ),  //input
    .data_in                  ( ctrl_fifo_data_in        ),  //input
    .data_out                 ( ctrl_fifo_data_out       ),  //output
    .full                     ( ctrl_fifo_full           ),  //output
    .empty                    ( ctrl_fifo_empty          )   //output
  );
// =================================================================

// =================================================================
// Internal FIFO
// =================================================================
  fifo #(
    .DATA_WIDTH               ( DATA_WIDTH               ),
    .ADDR_WIDTH               ( FIFO_ADDR_WIDTH           )
  ) internal_fifo (
    .clk                      ( clk                      ),  //input
    .reset                    ( reset                    ),  //input
    .enq                      ( int_fifo_enq             ),  //input
    .deq                      ( int_fifo_deq             ),  //input
    .data_in                  ( int_fifo_data_in         ),  //input
    .data_out                 ( int_fifo_data_out        ),  //output
    .full                     ( int_fifo_full            ),  //output
    .empty                    ( int_fifo_empty           )   //output
  );
// =================================================================

// =================================================================
// Neighbor FIFO in
// =================================================================
  fifo #(
    .DATA_WIDTH               ( DATA_WIDTH               ),
    .ADDR_WIDTH               ( FIFO_ADDR_WIDTH           )
  ) neighbor_in_fifo (
    .clk                      ( clk                      ),  //input
    .reset                    ( reset                    ),  //input
    .enq                      ( nin_fifo_enq             ),  //input
    .deq                      ( nin_fifo_deq             ),  //input
    .data_in                  ( nin_fifo_data_in         ),  //input
    .data_out                 ( nin_fifo_data_out        ),  //output
    .full                     ( nin_fifo_full            ),  //output
    .empty                    ( nin_fifo_empty           )   //output
  );
// =================================================================

// =================================================================
// Neighbor FIFO out
// =================================================================
  fifo #(
    .DATA_WIDTH               ( DATA_WIDTH               ),
    .ADDR_WIDTH               ( FIFO_ADDR_WIDTH          )
  ) neighbor_out_fifo (
    .clk                      ( clk                      ),  //input
    .reset                    ( reset                    ),  //input
    .enq                      ( nout_fifo_enq            ),  //input
    .deq                      ( nout_fifo_deq            ),  //input
    .data_in                  ( nout_fifo_data_in        ),  //input
    .data_out                 ( nout_fifo_data_out       ),  //output
    .full                     ( nout_fifo_full           ),  //output
    .empty                    ( nout_fifo_empty          )   //output
  );
// =================================================================

// =================================================================
// Bus FIFO
// =================================================================
  fifo #(
    .DATA_WIDTH               ( DATA_WIDTH               ),
    .ADDR_WIDTH               ( FIFO_ADDR_WIDTH           )
  ) bus_fifo (
    .clk                      ( clk                      ),  //input
    .reset                    ( reset                    ),  //input
    .enq                      ( bus_fifo_enq             ),  //input
    .deq                      ( bus_fifo_deq             ),  //input
    .data_in                  ( bus_fifo_data_in         ),  //input
    .data_out                 ( bus_fifo_data_out        ),  //output
    .full                     ( bus_fifo_full            ),  //output
    .empty                    ( bus_fifo_empty           )   //output
  );
// =================================================================

// =================================================================
// ALU: Combinational logic only
// =================================================================
  alu #(
    .DATA_WIDTH               ( DATA_WIDTH               )
  ) processor_alu0 (
    .clk                      ( clk                      ),  //input
    .reset                    ( reset                    ),  //input
    .enable                   ( alu_enable               ),  //input
    .op_code                  ( alu_op_code              ),  //input
    .op0                      ( alu_op0                  ),  //input
    .op1                      ( alu_op1                  ),  //input
    .out                      ( alu_out                  )   //output
  );
// =================================================================

// ******************************************************************
// your logic here ->
// ******************************************************************

wire [SRC0_IDX_WIDTH - 1 : 0] src0;
wire [SRC1_IDX_WIDTH - 1 : 0] src1;

// instruction decoding
assign src0 = ctrl_fifo_data_out[INST_WIDTH - OPCODE_WIDTH - 1 : INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH];
assign src1 = ctrl_fifo_data_out[INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH - 1 : INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH - SRC1_IDX_WIDTH];

reg [OPCODE_WIDTH - 1 : 0] op;
reg [DST0_IDX_WIDTH - 1 : 0] dst0;
reg [DST1_IDX_WIDTH - 1 : 0] dst1;


assign ctrl_fifo_deq = ~ctrl_fifo_empty;

reg should_write;


assign nout_fifo_enq = should_write && (dst0 == 0 || dst1 == 0);
assign nout_fifo_data_in = alu_out;

assign bus_fifo_enq = should_write && (dst0 == 1 || dst1 == 1);
assign bus_fifo_data_in = alu_out;

assign alu_op0 = src0 == 0 ? int_fifo_data_out : nin_fifo_data_out;
assign alu_op1 = src1 == 0 ? int_fifo_data_out : nin_fifo_data_out;

assign int_fifo_deq = ~ctrl_fifo_empty && (src0 == 0 || src1 == 0);
assign nin_fifo_deq = ~ctrl_fifo_empty && (src0 == 1 || src1 == 1);

assign alu_op_code = op;


always @(posedge clk) begin
  op <= ctrl_fifo_data_out[INST_WIDTH - 1 : INST_WIDTH - OPCODE_WIDTH];
  dst0 <= ctrl_fifo_data_out[INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH - SRC1_IDX_WIDTH - 1 : INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH - SRC1_IDX_WIDTH - DST0_IDX_WIDTH];
  dst1 <= ctrl_fifo_data_out[INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH - SRC1_IDX_WIDTH - DST0_IDX_WIDTH - 1 : INST_WIDTH - OPCODE_WIDTH - SRC0_IDX_WIDTH - SRC1_IDX_WIDTH - DST0_IDX_WIDTH - DST1_IDX_WIDTH];

  should_write <= ctrl_fifo_deq;
end

// ******************************************************************

endmodule
