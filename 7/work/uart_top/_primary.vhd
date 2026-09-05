library verilog;
use verilog.vl_types.all;
entity uart_top is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        data_in         : in     vl_logic_vector(6 downto 0);
        data_out        : out    vl_logic_vector(7 downto 0);
        done            : out    vl_logic
    );
end uart_top;
