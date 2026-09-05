library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        q_eval          : in     vl_logic_vector(2 downto 0);
        load            : out    vl_logic;
        add_sub_en      : out    vl_logic;
        sub_en          : out    vl_logic;
        sel_2m          : out    vl_logic;
        shift           : out    vl_logic;
        ready           : out    vl_logic
    );
end controller;
