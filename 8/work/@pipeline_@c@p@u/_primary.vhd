library verilog;
use verilog.vl_types.all;
entity Pipeline_CPU is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        data_Ar         : in     vl_logic_vector(7 downto 0);
        data_Ai         : in     vl_logic_vector(7 downto 0);
        data_Br         : in     vl_logic_vector(7 downto 0);
        data_Bi         : in     vl_logic_vector(7 downto 0);
        result_r        : out    vl_logic_vector(15 downto 0);
        result_i        : out    vl_logic_vector(15 downto 0);
        done            : out    vl_logic;
        current_pc      : out    vl_logic_vector(4 downto 0)
    );
end Pipeline_CPU;
