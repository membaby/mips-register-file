library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile_Testbench is
end RegisterFile_Testbench;

architecture Behavioral of RegisterFile_Testbench is
    constant CLK_PERIOD : time := 10 ns;

    signal clk_tb       :   std_logic := '0';   -- Clock signal
    signal regWrite_tb  :   std_logic := '0';   -- Register write signal
    signal readReg1_tb  :   std_logic_vector(4 downto 0) := (others => '0');   -- Read register 1 signal
    signal readReg2_tb  :   std_logic_vector(4 downto 0) := (others => '0');   -- Read register 2 signal
    signal writeReg_tb  :   std_logic_vector(4 downto 0) := (others => '0');   -- Write register signal
    signal writeData_tb :   std_logic_vector(31 downto 0) := (others => '0');  -- Write data signal
    signal readData1_tb :   std_logic_vector(31 downto 0) := (others => '0');  -- Read data 1 signal
    signal readData2_tb :   std_logic_vector(31 downto 0) := (others => '0');  -- Read data 2 signal

    component RegisterFile is
        Port (
                clk       : in  STD_LOGIC;
                regWrite  : in  STD_LOGIC;
                readReg1  : in  STD_LOGIC_VECTOR (4 downto 0);
                readReg2  : in  STD_LOGIC_VECTOR (4 downto 0);
                writeReg  : in  STD_LOGIC_VECTOR (4 downto 0);
                writeData : in  STD_LOGIC_VECTOR (31 downto 0);
                readData1 : out STD_LOGIC_VECTOR (31 downto 0);
                readData2 : out STD_LOGIC_VECTOR (31 downto 0)
            );
    end component;

begin

    UUT: RegisterFile
    port map (
        clk => clk_tb,
        regWrite => regWrite_tb,
        readReg1 => readReg1_tb,
        readReg2 => readReg2_tb,
        writeReg => writeReg_tb,
        writeData => writeData_tb,
        readData1 => readData1_tb,
        readData2 => readData2_tb
    );

    clk_process: process
    begin
        while now < 1000 ns loop
            clk_tb <= '0';
            wait for CLK_PERIOD/2;
            clk_tb <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;

    testbench_process: process
    begin
        wait for CLK_PERIOD / 2;
        -- Test Case 1
        regWrite_tb <= '1';
        writeReg_tb <= "00001";
        writeData_tb <= std_logic_vector(to_unsigned(6, writeData_tb'length));
        wait for CLK_PERIOD / 2;
        regWrite_tb <= '0';
        readReg1_tb <= "00001";
        wait for CLK_PERIOD / 2;
        assert readData1_tb = std_logic_vector(to_unsigned(6, readData1_tb'length))
            report "Test Case 1 Failed" severity error;
            wait;

        -- Test Case 2: Write to register 1, Write to register 2, Read from register 1, Read from register 2

        -- Write to register 1
        regWrite_tb <= '1';
        writeReg_tb <= "00001";
        writeData_tb <= std_logic_vector(to_unsigned(6, writeData_tb'length));
        wait for CLK_PERIOD;
        writeReg_tb <= "00010";
        writeData_tb <= std_logic_vector(to_unsigned(7, writeData_tb'length));
        wait for CLK_PERIOD / 2;
        regWrite_tb <= '0';
        readReg1_tb <= "00001";
        readReg2_tb <= "00010";
        wait for CLK_PERIOD / 2;
        assert readData1_tb = std_logic_vector(to_unsigned(6, readData1_tb'length))
            report "Test Case 2 Failed: Read data from register 1 doesn't match" severity error;
        assert readData2_tb = std_logic_vector(to_unsigned(7, readData2_tb'length))
            report "Test Case 2 Failed: Read data from register 2 doesn't match" severity error;

        -- Test Case 3: 
        writeReg_tb <= "00001";
        writeData_tb <= std_logic_vector(to_unsigned(6, writeData_tb'length));
        wait for CLK_PERIOD / 2;
        assert readData1_tb = std_logic_vector(to_unsigned(0, readData1_tb'length))
            report "Test Case 3 Failed: Read data from register 1 doesn't match" severity error;

        -- Test Case 4:
        regWrite_tb <= '1';
        writeReg_tb <= "00001";
        writeData_tb <= std_logic_vector(to_unsigned(6, writeData_tb'length));
        wait for CLK_PERIOD;
        writeData_tb <= std_logic_vector(to_unsigned(7, writeData_tb'length));
        wait for CLK_PERIOD;
        writeData_tb <= std_logic_vector(to_unsigned(8, writeData_tb'length));
        wait for CLK_PERIOD;
        writeData_tb <= std_logic_vector(to_unsigned(9, writeData_tb'length));
        wait for CLK_PERIOD;
        writeData_tb <= std_logic_vector(to_unsigned(10, writeData_tb'length));
        wait for CLK_PERIOD / 2;
        regWrite_tb <= '0';
        readReg1_tb <= "00001";
        wait for CLK_PERIOD / 2;
        assert readData1_tb = std_logic_vector(to_unsigned(10, readData1_tb'length))
            report "Test Case 4 Failed: Read data from register 1 doesn't match" severity error;
        

        wait;
    end process;

end Behavioral;