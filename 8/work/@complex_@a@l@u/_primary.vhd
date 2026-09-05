library verilog;
use verilog.vl_types.all;
entity Complex_ALU is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        op              : in     vl_logic_vector(1 downto 0);
        Ar              : in     vl_logic_vector(7 downto 0);
        Ai              : in     vl_logic_vector(7 downto 0);
        Br              : in     vl_logic_vector(7 downto 0);
        Bi              : in     vl_logic_vector(7 downto 0);
        Cr              : out    vl_logic_vector(15 downto 0);
        Ci              : out    vl_logic_vector(15 downto 0);
        ready           : out    vl_logic
    );
end Complex_ALU;
