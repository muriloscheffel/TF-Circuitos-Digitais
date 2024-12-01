library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity NanoCPU_TB is
end NanoCPU_TB;

architecture TB of NanoCPU_TB is

	signal ck, rst: std_logic := '0';
	signal dataR, dataW: std_logic_vector(15 downto 0);
	signal address: std_logic_vector(7 downto 0);
	signal we, ce: std_logic;

	-- Memory array signal for 256 x 16-bit positions
	type memoryArray is array (0 to 255) of std_logic_vector(15 downto 0);

	signal memory: memoryArray :=
	(
		0 => X"4000",
		1 => X"4111",
		2 => X"0093",
		3 => X"6110",
		4 => X"8000",
		5 => X"7203",
		6 => X"3032",
		7 => X"10A1",
		8 => X"F000",
		9 => X"000A",
		
		
		-- 0 => X"01E0",    -- R0 = PMEM[30]
		-- 1 => X"01F1",    -- R1 = PMEM[31]
		-- 2 => X"0202",    -- R2 = PMEM[32]
		-- 3 => X"0213",    -- R3 = PMEM[33]
		-- 4 => X"6003",
		-- 5 => X"5101",
		-- 6 => X"4300",
		-- 7 => X"7210",
		-- 8 => X"10F0",
		-- 9 => X"1101",
		-- 10 => X"1112",  
		-- 11 => X"3FF2",
		-- 20 => X"8000",   -- INC R0
		-- 21 => X"8110",   -- INC R1
		-- 22 => X"9220",	 -- DEC R2
		-- 23 => X"9330",   -- DEC R3
		-- 24 => X"F000",	 -- FIM
		-- 30 => X"1111",
		-- 31 => X"2222",
		-- 32 => X"3333",
		-- 33 => X"4444",
		-- 255 => X"2140",
		others => (others => '0')
	);

begin

	rst <= '1', '0' after 2 ns;        -- generates the reset signal
	ck  <= not ck after 1 ns;          -- generates the clock signal 

	CPU: entity work.nanoCPU port map
	(
		ck      => ck,
		rst     => rst,
		address => address,
		dataR   => dataR,
		dataW   => dataW,
		ce      => ce,
		we      => we
	); 

	-- write to memory
	process(ck)
	begin
		if ck'event and ck = '1' then
			if we = '1' then
				memory(CONV_INTEGER(address)) <= dataW; 
			end if;
		end if;
	end process;

	dataR <= memory(CONV_INTEGER(address));   -- read from memory

end TB;