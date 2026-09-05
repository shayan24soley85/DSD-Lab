library verilog;
use verilog.vl_types.all;
entity uart_tx is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        tx_start        : in     vl_logic;
        data_in         : in     vl_logic_vector(6 downto 0);
        tx_out          : out    vl_logic;
        tx_busy         : out    vl_logic
    );
end uart_tx;
