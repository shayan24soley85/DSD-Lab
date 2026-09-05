library verilog;
use verilog.vl_types.all;
entity Memory_32 is
    port(
        clk             : in     vl_logic;
        addr            : in     vl_logic_vector(4 downto 0);
        data_out        : out    vl_logic_vector(15 downto 0)
    );
end Memory_32;
