library verilog;
use verilog.vl_types.all;
entity processor is
    generic(
        DATA_WIDTH      : integer := 4;
        INST_WIDTH      : integer := 8;
        FIFO_ADDR_WIDTH : integer := 8;
        OPCODE_WIDTH    : integer := 2;
        SRC0_IDX_WIDTH  : integer := 2;
        SRC1_IDX_WIDTH  : integer := 2;
        DST0_IDX_WIDTH  : integer := 1;
        DST1_IDX_WIDTH  : integer := 1
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        ctrl_fifo_enq   : in     vl_logic;
        ctrl_fifo_data_in: in     vl_logic_vector;
        ctrl_fifo_full  : out    vl_logic;
        int_fifo_enq    : in     vl_logic;
        int_fifo_data_in: in     vl_logic_vector;
        int_fifo_full   : out    vl_logic;
        nin_fifo_enq    : in     vl_logic;
        nin_fifo_data_in: in     vl_logic_vector;
        nin_fifo_full   : out    vl_logic;
        nout_fifo_deq   : in     vl_logic;
        nout_fifo_data_out: out    vl_logic_vector;
        nout_fifo_empty : out    vl_logic;
        bus_fifo_deq    : in     vl_logic;
        bus_fifo_data_out: out    vl_logic_vector;
        bus_fifo_empty  : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of INST_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of FIFO_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OPCODE_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SRC0_IDX_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of SRC1_IDX_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DST0_IDX_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of DST1_IDX_WIDTH : constant is 1;
end processor;
