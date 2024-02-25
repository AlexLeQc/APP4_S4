library ieee;
use ieee.std_logic_1164.all;
use work.MIPS32_package.all;

entity alu_tb is
end entity alu_tb;

architecture testbench of alu_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';

    signal a, b, result : std_logic_vector(31 downto 0);
    signal alu_funct : std_logic_vector(3 downto 0);
    signal shamt : std_logic_vector(4 downto 0);
    signal zero : std_logic;
    signal multRes : std_logic_vector(63 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the ALU
    UUT: entity work.alu
        port map (
            i_a => a,
            i_b => b,
            i_alu_funct => alu_funct,
            i_shamt => shamt,
            o_result => result,
            o_multRes => multRes,
            o_zero => zero
        );

    -- Clock process
    process
    begin
        while now < 1000 us loop
            clk <= not clk;
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        wait for 2 * CLK_PERIOD; -- Initial wait for stability

       -- Test ALU_ADDV
        a <= X"01020304"; -- Vector [1, 2, 3, 4]
        b <= X"04030201"; -- Vector [4, 3, 2, 1]
        shamt <= (others => '0');
        wait for CLK_PERIOD;
        assert result = X"05050505" report "ALU_ADDV Test Failed" severity error;

        -- Test ALU_MIV
        a <= X"01020304"; -- Vector [1, 2, 3, 4]
        b <= X"00000003"; -- Vector [4, 3, 2, 1]
        shamt <= (others => '0');
        wait for CLK_PERIOD;
        assert result = X"00000001" report "ALU_VMIN Test Failed" severity error;

        wait;
    end process;

end architecture testbench;