library verilog;
use verilog.vl_types.all;
entity uart_rx is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rx_in           : in     vl_logic;
        data_out        : out    vl_logic_vector(7 downto 0);
        rx_done         : out    vl_logic
    );
end uart_rx;
