library verilog;
use verilog.vl_types.all;
entity eq_cmp5 is
    port(
        A               : in     vl_logic_vector(4 downto 0);
        B               : in     vl_logic_vector(4 downto 0);
        eq              : out    vl_logic
    );
end eq_cmp5;
