library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        M_in            : in     vl_logic_vector(7 downto 0);
        Q_in            : in     vl_logic_vector(7 downto 0);
        load            : in     vl_logic;
        shift           : in     vl_logic;
        add_sub_en      : in     vl_logic;
        sub_en          : in     vl_logic;
        sel_2m          : in     vl_logic;
        q_eval          : out    vl_logic_vector(2 downto 0);
        result          : out    vl_logic_vector(15 downto 0)
    );
end datapath;
