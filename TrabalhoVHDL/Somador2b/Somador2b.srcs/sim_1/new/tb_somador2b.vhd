library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_somador2b is
end tb_somador2b;

architecture sim of tb_somador2b is
    component somador2b
        Port (
            a    : in  STD_LOGIC_VECTOR (1 downto 0);
            b    : in  STD_LOGIC_VECTOR (1 downto 0);
            soma : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    signal a_tb    : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal b_tb    : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal soma_tb : STD_LOGIC_VECTOR(2 downto 0);
begin
    uut: somador2b port map (
        a => a_tb,
        b => b_tb,
        soma => soma_tb
    );

    stim_proc: process
    begin
        a_tb <= "00"; b_tb <= "00"; wait for 10 ns;
        a_tb <= "01"; b_tb <= "01"; wait for 10 ns;
        a_tb <= "10"; b_tb <= "11"; wait for 10 ns;
        a_tb <= "11"; b_tb <= "11"; wait for 10 ns;
        wait;
    end process;
end sim;