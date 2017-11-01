`timescale 1ns/1ps
module processor_tb;

// ******************************************************************
// Parameters -- Do not change
// ******************************************************************
  parameter   DATA_WIDTH          = 8;          // Width of data for ALU inputs and outputs
  parameter   FIFO_ADDR_WIDTH     = 10;         // Width of FIFO address

  parameter   INST_WIDTH          = 8;          // Width of instruction

  parameter   OPCODE_WIDTH        = 2;          // Width of op code
  parameter   SRC0_IDX_WIDTH      = 2;          // Width of src0 of operation
  parameter   SRC1_IDX_WIDTH      = 2;          // Width of src1 of operation
  parameter   DST0_IDX_WIDTH      = 1;          // Width of dst0 of operation
  parameter   DST1_IDX_WIDTH      = 1;          // Width of dst1 of operation

  parameter   NUM_INSTRUCTIONS    = 1024;       // number of instructions

// ******************************************************************
// Wires and Regs
// ******************************************************************
  // clk and reset
  reg                                clk;
  reg                                reset;

  reg                                tb_ctrl_fifo_enq;
  reg  [ INST_WIDTH      -1 : 0 ]    tb_ctrl_fifo_data_in;
  wire                               tb_ctrl_fifo_full;

  reg                                tb_int_fifo_enq;
  reg  [ DATA_WIDTH      -1 : 0 ]    tb_int_fifo_data_in;
  wire                               tb_int_fifo_full;

  reg                                tb_nin_fifo_enq;
  reg  [ DATA_WIDTH      -1 : 0 ]    tb_nin_fifo_data_in;
  wire                               tb_nin_fifo_full;

  reg                                tb_nout_fifo_deq;
  wire [ DATA_WIDTH      -1 : 0 ]    tb_nout_fifo_data_out;
  wire                               tb_nout_fifo_empty;

  reg                                tb_ext_fifo_deq;
  wire [ DATA_WIDTH      -1 : 0 ]    tb_ext_fifo_data_out;
  wire                               tb_ext_fifo_empty;

  reg                                tb_bus_fifo_deq;
  wire [ DATA_WIDTH      -1 : 0 ]    tb_bus_fifo_data_out;
  wire                               tb_bus_fifo_empty;

  reg  [ DATA_WIDTH      -1 : 0 ]    nout_mem [ 0 : (1<<FIFO_ADDR_WIDTH) - 1];
  reg  [ DATA_WIDTH      -1 : 0 ]    bus_mem  [ 0 : (1<<FIFO_ADDR_WIDTH) - 1];

  reg  [ INST_WIDTH      -1 : 0 ]    ctrl_mem [ 0 : (1<<FIFO_ADDR_WIDTH) - 1];
  reg  [ DATA_WIDTH      -1 : 0 ]    nin_mem  [ 0 : (1<<FIFO_ADDR_WIDTH) - 1];
  reg  [ DATA_WIDTH      -1 : 0 ]    int_mem  [ 0 : (1<<FIFO_ADDR_WIDTH) - 1];

  reg  [ 32              -1 : 0 ]    num_outputs  [ 0 : (1<<FIFO_ADDR_WIDTH) - 1];
// ******************************************************************
// INSTANTIATIONS
// ******************************************************************

  processor
  #(  // Parameters
    .DATA_WIDTH             ( DATA_WIDTH              ),      // Width of data for ALUs and FIFOs
    .INST_WIDTH             ( INST_WIDTH              ),      // Width of instructions
    .FIFO_ADDR_WIDTH        ( FIFO_ADDR_WIDTH         ),      // Width of FIFO address
    .OPCODE_WIDTH           ( OPCODE_WIDTH            ),      // Width of op code
    .SRC0_IDX_WIDTH         ( SRC0_IDX_WIDTH          ),      // Width of src0 of operation
    .SRC1_IDX_WIDTH         ( SRC1_IDX_WIDTH          ),      // Width of src1 of operation
    .DST0_IDX_WIDTH         ( DST0_IDX_WIDTH          ),      // Width of dst0 of operation
    .DST1_IDX_WIDTH         ( DST1_IDX_WIDTH          )       // Width of dst1 of operation
  ) processor_dut (  // Ports
    .clk                    ( clk                     ),
    .reset                  ( reset                   ),

    .ctrl_fifo_enq          ( tb_ctrl_fifo_enq        ),
    .ctrl_fifo_data_in      ( tb_ctrl_fifo_data_in    ),
    .ctrl_fifo_full         ( tb_ctrl_fifo_full       ),

    .int_fifo_enq           ( tb_int_fifo_enq         ),
    .int_fifo_data_in       ( tb_int_fifo_data_in     ),
    .int_fifo_full          ( tb_int_fifo_full        ),

    .nin_fifo_enq           ( tb_nin_fifo_enq         ),
    .nin_fifo_data_in       ( tb_nin_fifo_data_in     ),
    .nin_fifo_full          ( tb_nin_fifo_full        ),

    .nout_fifo_deq          ( tb_nout_fifo_deq        ),
    .nout_fifo_data_out     ( tb_nout_fifo_data_out   ),
    .nout_fifo_empty        ( tb_nout_fifo_empty      ),

    .bus_fifo_deq           ( tb_bus_fifo_deq         ),
    .bus_fifo_data_out      ( tb_bus_fifo_data_out    ),
    .bus_fifo_empty         ( tb_bus_fifo_empty       )
  );

  // initial begin
  //  $dumpfile("processor_tb.vcd");
  //  $dumpvars(0,processor_tb);
  // end

  // Initialize memory -- Do not touch
  initial begin
    $readmemb("./instructions/ctrl_mem.txt", ctrl_mem);
    $readmemb("./instructions/int_mem.txt" , int_mem);
    $readmemb("./instructions/nin_mem.txt" , nin_mem);
    $readmemb("./instructions/nout_mem.txt", nout_mem);
    $readmemb("./instructions/bus_mem.txt" , bus_mem);

    $readmemb("./instructions/num_outputs.txt" , num_outputs, 0, 1);
  end

  integer i, num_errors, num_mismatch;
  initial begin

    num_errors = 0;
    num_mismatch = 0;
    clk = 0;
    reset = 1;

    tb_ctrl_fifo_enq = 0;
    tb_int_fifo_enq = 0;
    tb_nin_fifo_enq = 0;

    tb_int_fifo_data_in = 0;
    tb_nin_fifo_data_in = 0;

    tb_nout_fifo_deq = 0;
    tb_ext_fifo_deq = 0;
    tb_bus_fifo_deq = 0;

    @(negedge clk);
    @(negedge clk);
    reset = 0;
    @(negedge clk);
    @(negedge clk);

    // Enqueue the data and instructions to FIFOs
    for (i=0; i < NUM_INSTRUCTIONS; i=i+1)
    begin
      tb_ctrl_fifo_enq = 1'b1;
      tb_int_fifo_enq = 1'b1;
      tb_nin_fifo_enq = 1'b1;
      tb_ctrl_fifo_data_in = ctrl_mem[i];
      tb_int_fifo_data_in = int_mem[i];
      tb_nin_fifo_data_in = nin_mem[i];
      // $display(ctrl_mem[i]);
      @(negedge clk);
    end
    tb_ctrl_fifo_enq = 0;
    tb_int_fifo_enq = 0;
    tb_nin_fifo_enq = 0;

    // Wait to finish all operations
    for (i=0; i < NUM_INSTRUCTIONS+100; i=i+1) begin
      @(negedge clk);
    end

    // Check NOUT
    i = 0;
    $display("Checking NOUT");
    while (!tb_nout_fifo_empty)
    begin
      tb_nout_fifo_deq = 1;
      @(negedge clk);
      if (nout_mem[i] !== tb_nout_fifo_data_out) begin
        $display("Expected output: %d", nout_mem[i]);
        $display("Got output     : %d", tb_nout_fifo_data_out);
        num_mismatch = num_mismatch + 1;
      end
      tb_nout_fifo_deq = 0;
      i = i+1;
    end

    if (i < num_outputs[0])
    begin
      $display("Got %d outputs in Neighbor out FIFO, Expected %d", i, num_outputs[0]);
      num_errors += 1;
    end
    else if (num_mismatch !== 0)
    begin
      $display("Reading the correct number of outputs from NOUT, but data does not match expected");
      num_errors += 1;
    end
    else
      $display("No errors in Neighbor out FIFO");

    num_mismatch = 0;

    // Check Bus
    i = 0;
    $display("Checking Bus");
    while (!tb_bus_fifo_empty)
    begin
      tb_bus_fifo_deq = 1;
      @(negedge clk);
      if (bus_mem[i] !== tb_bus_fifo_data_out) begin
        $display("Expected output: %d", bus_mem[i]);
        $display("Got output     : %d", tb_bus_fifo_data_out);
        num_mismatch = num_mismatch + 1;
      end
      tb_bus_fifo_deq = 0;
      i = i+1;
    end

    if (i < num_outputs[1])
    begin
      $display("Got %d outputs in Bus FIFO, Expected %d", i, num_outputs[0]);
      num_errors += 1;
    end
    else if (num_mismatch !== 0)
    begin
      $display("Reading the correct number of outputs from Bus, but data does not match expected");
      num_errors += 1;
    end
    else
      $display("No errors in Bus FIFO");

    if (num_errors == 0) begin
      $display("No errors found");
      $display("Your processor works!!");
    end
    else begin
      $display("Errors found in your design");
    end

    $finish;

  end

  always #2 clk = ~clk;

endmodule
