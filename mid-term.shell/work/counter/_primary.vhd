library verilog;
use verilog.vl_types.all;
entity counter is
    generic(
        SIZE            : integer := 4;
        MAX_VALUE       : vl_notype
    );
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        count           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
    attribute mti_svvh_generic_type of MAX_VALUE : constant is 3;
end counter;
