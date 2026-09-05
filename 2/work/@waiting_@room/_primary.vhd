library verilog;
use verilog.vl_types.all;
entity Waiting_Room is
    port(
        Clk             : in     vl_logic;
        Clr             : in     vl_logic;
        IN_sensor       : in     vl_logic;
        OUT_sensor      : in     vl_logic;
        Ent             : in     vl_logic;
        T               : in     vl_logic;
        \Open\          : out    vl_logic;
        Close           : out    vl_logic;
        Count           : out    vl_logic_vector(3 downto 0)
    );
end Waiting_Room;
