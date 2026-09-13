library verilog;
use verilog.vl_types.all;
entity mult11_bcd16 is
    port(
        BCD             : in     vl_logic_vector(15 downto 0);
        Y               : out    vl_logic
    );
end mult11_bcd16;
