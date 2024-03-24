library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
    Port (
        clk      : in STD_LOGIC;                     
        regWrite : in STD_LOGIC;                     
        readReg1 : in STD_LOGIC_VECTOR(4 downto 0);  
        readReg2 : in STD_LOGIC_VECTOR(4 downto 0);  
        writeReg : in STD_LOGIC_VECTOR(4 downto 0);  
        writeData: in STD_LOGIC_VECTOR(31 downto 0); 
        readData1: out STD_LOGIC_VECTOR(31 downto 0); 
        readData2: out STD_LOGIC_VECTOR(31 downto 0)  
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type RegisterArray is array(0 to 31) of std_logic_vector(31 downto 0);--custom type RegisterArray as an array of 32 elements,each element is a 32-bit vector
    signal registers : RegisterArray;

begin
    process(clk) --the rising edge of the clock signal , write in the first half cycle and read in the 2nd half cycle
    begin
        if rising_edge(clk) then
            if regWrite = '1' then
                registers(to_integer(unsigned(writeReg))) <= writeData;
            end if;
        end if;
        if falling_edge(clk) then
            readData1 <= registers(to_integer(unsigned(readReg1)));
            readData2 <= registers(to_integer(unsigned(readReg2)));
        end if;
    end process;
end architecture Behavioral;