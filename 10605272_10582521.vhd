----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2020 12:20:05
-- Design Name: 
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project_reti_logiche is
    Port ( i_clk : in STD_LOGIC;
           i_start : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_address : out STD_LOGIC_VECTOR (15 downto 0);
           o_done : out STD_LOGIC;
           o_en : out STD_LOGIC;
           o_we : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR (7 downto 0));
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           r1_load : in STD_LOGIC;
           r2_load : in STD_LOGIC;
           r3_load : in STD_LOGIC;
           mux_sel : in STD_LOGIC_VECTOR (2 downto 0);
           d_sel : in STD_LOGIC;
           o_redo : out STD_LOGIC);
end component;     
signal r1_load : STD_LOGIC;
signal r2_load : STD_LOGIC;
signal r3_load : STD_LOGIC;
signal d_sel : STD_LOGIC;
signal o_redo : STD_LOGIC;
signal mux_sel : STD_LOGIC_VECTOR (2 downto 0);
type S is (S0,SP1,S1,S2, S2POST,SP3,S3,S4,SP5,S5,SP6,S6,SP7,S7,SP8,S8,SP9,S9,SP10,S10,SP11,S11,SP12,S12,SP13,S13);
signal cur_state, next_state, prev_state : S;
begin
DATAPATH0: datapath port map(
        i_clk => i_clk,
        i_rst => i_rst,
        i_data => i_data,
        o_data => o_data,        
        r1_load => r1_load,
        r2_load => r2_load,    
        r3_load => r3_load,
        mux_sel => mux_sel,
        d_sel => d_sel,
        o_redo => o_redo
    );
    
    process(i_clk, i_rst)
        begin
            if(i_rst = '1') then
                cur_state <= S0;
            elsif i_clk'event and i_clk = '1'
             --and falling_edge(i_clk) 
             then
                cur_state <= next_state;
            end if;
    end process;
    
    process(cur_state, i_start, o_redo)
    begin
        next_state <= cur_state;
        case cur_state is
            when S0 =>
                if i_start = '1' then
                    next_state <= SP1;
                end if;
            when SP1 =>
                next_state <= S1;
            when S1 =>
                next_state <= S2;
            when S2 =>
                next_state <= S2POST;
            when S2POST =>
                if o_redo = '1' then
                    next_state <= SP5;
                elsif o_redo = '0' then
                    next_state <= SP3;
                end if;
            when SP3 =>
                 next_state <= S3;
            when S3 =>
                 next_state <= S4;
            when S4 =>
                    next_state <= S0;
            when SP5 =>
                    next_state <= S5;
            when S5 =>
                if o_redo = '1' then
                    next_state <= SP6;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S2;
                end if;
            when SP6 =>
                 
                    next_state <= S6;
                
            when S6 =>
                if o_redo = '1' then
                    next_state <= SP7;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S5;
                end if;
            when SP7 =>
                 
                    next_state <= S7;
                
            when S7 =>
                if o_redo = '1' then
                    next_state <= SP8;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S6;
                end if;
            when SP8 =>
                 
                    next_state <= S8;
                
            when S8 =>
                if o_redo = '1' then
                    next_state <= SP9;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S7;
                end if;    
             when SP9 =>
                 
                    next_state <= S9;
                
             when S9 =>
                if o_redo = '1' then
                    next_state <= SP10;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S8;
                end if;
             when SP10 =>
                 
                    next_state <= S10;
                
             when S10 =>
                if o_redo = '1' then
                    next_state <= SP11;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S9;
                end if;
             when SP11 =>
                 
                    next_state <= S11;
                
             when S11 =>
                if o_redo = '1' then
                    next_state <= SP12;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S10;
                end if;
             when SP12 =>
                 next_state <= S12;
             when S12 =>
                 if o_redo = '1' then
                    next_state <= SP13;
                elsif o_redo = '0' then
                    next_state <= SP3;
                    prev_state <= S11;
                end if;
             when SP13 =>
                next_state <= S13;
             when S13 =>
                next_state <= S4;
        end case;
    end process;
    
    process(cur_state)
    begin
        r1_load <= '0';
        r2_load <= '0';
        r3_load <= '0';
        d_sel <= '0';
        mux_sel <= "000";
        o_address <= "0000000000000000";
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        case cur_state is
            when S0 =>
             when SP1 =>
                o_en <= '1';
                o_address <= "0000000000001000";    
            when S1 =>
                o_address <= "0000000000000000";
                o_en <= '1';
                r1_load <= '1';              
                r2_load <= '0';
                r3_load <= '0';
            when S2 =>
                mux_sel <= "000";
                r2_load <= '1';
                r1_load <= '0';
                r3_load <= '1';  
            when S2POST =>
                mux_sel <="000";
            when SP3 =>
                case prev_state is
                    when S2 =>
                        mux_sel <= "000";
                    when S5 =>
                        mux_sel <= "001";
                    when S6 =>
                        mux_sel <= "010";
                    when S7 =>
                        mux_sel <= "011";
                    when S8 =>
                        mux_sel <= "100";
                    when S9 =>
                        mux_sel <= "101";
                    when S10 =>
                        mux_sel <= "110";
                    when S11 =>
                        mux_sel <= "111";
                    when others =>
                        mux_sel <= "XXX";
                    end case;
                o_address <= "0000000000001001";
                o_en <= '1';
                o_we <= '1';
                d_sel <= '1';  
            when S3 =>  
                o_address <= "0000000000001001";
                case prev_state is
                    when S2 =>
                        mux_sel <= "000";
                    when S5 =>
                        mux_sel <= "001";
                    when S6 =>
                        mux_sel <= "010";
                    when S7 =>
                        mux_sel <= "011";
                    when S8 =>
                        mux_sel <= "100";
                    when S9 =>
                        mux_sel <= "101";
                    when S10 =>
                        mux_sel <= "110";
                    when S11 =>
                        mux_sel <= "111";
                    when others =>
                        mux_sel <= "XXX";
                    end case;
                d_sel <= '1';  
            when S4 =>
                o_address <= "0000000000001001";
                case prev_state is
                    when S2 =>
                        mux_sel <= "000";
                    when S5 =>
                        mux_sel <= "001";
                    when S6 =>
                        mux_sel <= "010";
                    when S7 =>
                        mux_sel <= "011";
                    when S8 =>
                        mux_sel <= "100";
                    when S9 =>
                        mux_sel <= "101";
                    when S10 =>
                        mux_sel <= "110";
                    when S11 =>
                        mux_sel <= "111";
                    when others =>
                        mux_sel <= "XXX";
                    end case;
                o_done <= '1';
                d_sel <= '1';  
            when SP5 =>
                mux_sel <= "000";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000001";
            when S5 =>
                mux_sel <= "000";
                r2_load <= '1';
                r1_load <= '0';
                
            when SP6 =>
                mux_sel <= "001";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000010";
            when S6 =>
                mux_sel <= "001";
                r2_load <= '1';
                r1_load <= '0';
                
            when SP7 =>
                mux_sel <= "010";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000011";
            when S7 =>
                mux_sel <= "010";
                r2_load <= '1';
                r1_load <= '0';
                
            when SP8 =>
                mux_sel <= "011";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000100";
            when S8 =>
                mux_sel <= "011";
                r2_load <= '1';
                r1_load <= '0';
                
            when SP9 =>
                mux_sel <= "100";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000101";
            when S9 =>
                mux_sel <= "100";
                r2_load <= '1';
                r1_load <= '0';
                
            when SP10 =>
                mux_sel <= "101";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000110";
            when S10 =>
                mux_sel <= "101";
                r2_load <= '1';
                r1_load <= '0';
                
            when SP11 =>
                mux_sel <= "110";
                o_en <= '1';
                r3_load <= '1';
                o_address <= "0000000000000111";
            when S11 =>
                mux_sel <= "110";
                r2_load <= '1';
                r1_load <= '0';                    
            when SP12 =>
                mux_sel <= "111";
                o_en <= '1';
                r3_load <= '1';
            when S12 =>
                mux_sel <= "111";
                r2_load <= '1';
                r1_load <= '0';
            when SP13 =>
                
                o_address <= "0000000000001001";
                o_en <= '1';
                o_we <= '1';
            when S13 =>
                d_sel <= '0';
            
                
        end case;
    end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is
    Port ( i_clk : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR (7 downto 0);
           o_data : out STD_LOGIC_VECTOR (7 downto 0);
           r1_load : in STD_LOGIC;
           r2_load : in STD_LOGIC;
           r3_load : in STD_LOGIC;
           mux_sel : in STD_LOGIC_VECTOR (2 downto 0);
           d_sel : in STD_LOGIC;
           o_redo : out STD_LOGIC);
end datapath;

architecture Behavioral of datapath is
signal o_reg1 : STD_LOGIC_VECTOR (7 downto 0);
signal o_reg2 : STD_LOGIC_VECTOR (7 downto 0);
signal sub : STD_LOGIC_VECTOR(7 downto 0);
signal sub_r : STD_LOGIC_VECTOR(7 downto 0);
signal dec_out : STD_LOGIC_VECTOR(7 downto 0);
signal o_reg3 : STD_LOGIC_VECTOR (7 downto 0);
signal mux : STD_LOGIC_VECTOR (7 downto 0);
signal sum : STD_LOGIC_VECTOR (7 downto 0);
begin
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg1 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r1_load = '1') then
                o_reg1 <= i_data;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg2 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r2_load = '1') then
                o_reg2 <= i_data;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            o_reg3 <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if(r3_load = '1') then
                o_reg3 <= sub;
            end if;
        end if;
    end process;
    
                    
    with o_reg3 select
        dec_out <= "10000001" when "00000000",
                   "10000010" when "00000001",
                   "10000100" when "00000010",
                   "10001000" when "00000011",
                   "XXXXXXXX" when others;
                   
    with mux_sel select
        mux <= "00000000" when "000",
               "00010000" when "001",
               "00100000" when "010",
               "00110000" when "011",
               "01000000" when "100",
               "01010000" when "101",
               "01100000" when "110",
               "01110000" when "111",
               "XXXXXXXX" when others;
                   
    
    with d_sel select
        o_data <= o_reg1(7 downto 0) when '0',
                  sum(7 downto 0) when '1',
                  "XXXXXXXX" when others;
  
  
  
    sub <= o_reg1 - o_reg2;
   
    
    sum <= dec_out + mux;

    
   -- o_redo <= '1' when (o_reg3 < "00000000" or o_reg3 > "00000011") else '0';
   
   --    process(i_rst, o_reg2)
--    begin
--        if(i_rst = '1') then
--            sub <= "00000000";
--        elsif i_clk'event and i_clk = '1' then
--            sub <= o_reg1 - o_reg2;
--        end if;
--    end process;
    
--    process(i_rst, sub)
--    begin
--        if(i_rst = '1') then
--            o_redo <= 'U';
--        elsif sub'event then
--            if(sub < "00000000" or sub > "00000011") then
--                o_redo <= '1'; 
--            else
--                o_redo <= '0';
--            end if;
--        end if;
--    end process;
    
    process(i_clk) 
    begin 
        if i_clk'event and i_clk = '1' then
            sub_r <= sub;
 
            if sub /= sub_r then  -- detect change in value of sub between clocks
                if(sub < "00000000" or sub > "00000011") then
                    o_redo <= '1'; 
                else
                    o_redo <= '0';
                end if;
            end if;
        end if;
    end process;
    
--    process(i_rst, i_data)
--    begin
--        if(i_rst = '1') then
--            o_redo <= 'U';
--        elsif i_data'event then
--            o_redo <= 'U';
--        end if;
--    end process;
    
end Behavioral;
