library verilog;
use verilog.vl_types.all;
entity booth_mult is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        M_in            : in     vl_logic_vector(7 downto 0);
        Q_in            : in     vl_logic_vector(7 downto 0);
        result          : out    vl_logic_vector(15 downto 0);
        ready           : out    vl_logic
    );
end booth_mult;
