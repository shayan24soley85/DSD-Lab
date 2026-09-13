library verilog;
use verilog.vl_types.all;
entity bcd_mod3 is
    port(
        \in\            : in     vl_logic_vector(3 downto 0);
        r               : out    vl_logic_vector(1 downto 0)
    );
end bcd_mod3;
