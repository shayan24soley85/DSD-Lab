library verilog;
use verilog.vl_types.all;
entity stack is
    port(
        Clk             : in     vl_logic;
        RstN            : in     vl_logic;
        Data_In         : in     vl_logic_vector(3 downto 0);
        Push            : in     vl_logic;
        Pop             : in     vl_logic;
        Data_Out        : out    vl_logic_vector(3 downto 0);
        Full            : out    vl_logic;
        Empty           : out    vl_logic
    );
end stack;
