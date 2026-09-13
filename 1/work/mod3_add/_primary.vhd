library verilog;
use verilog.vl_types.all;
entity mod3_add is
    port(
        X               : in     vl_logic_vector(1 downto 0);
        Y               : in     vl_logic_vector(1 downto 0);
        Z               : out    vl_logic_vector(1 downto 0)
    );
end mod3_add;
