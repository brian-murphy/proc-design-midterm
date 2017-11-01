library verilog;
use verilog.vl_types.all;
entity alu is
    generic(
        DATA_WIDTH      : integer := 4;
        OPCODE_WIDTH    : integer := 2
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        op_code         : in     vl_logic_vector;
        op0             : in     vl_logic_vector;
        op1             : in     vl_logic_vector;
        \out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DATA_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of OPCODE_WIDTH : constant is 1;
end alu;
