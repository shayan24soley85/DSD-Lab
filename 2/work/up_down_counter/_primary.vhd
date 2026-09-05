library verilog;
use verilog.vl_types.all;
entity up_down_counter is
    port(
        U               : in     vl_logic;
        Clk             : in     vl_logic;
        Clr             : in     vl_logic;
        Enable          : in     vl_logic;
        Count           : out    vl_logic_vector(3 downto 0)
    );
end up_down_counter;
