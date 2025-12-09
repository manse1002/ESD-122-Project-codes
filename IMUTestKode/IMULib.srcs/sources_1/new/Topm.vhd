----------------------------------------------------------------------------------
-- Engineer: 	Daniel Moran <dmorang@hotmail.com>
-- Project: 	mpu6050 
-- Description: reading raw values for mpu6050
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY mpu_rg is
	PORT(
		CLOCK:	IN	STD_LOGIC;
		reset_n:    in std_logic;
		en:         in std_logic := '1';
		I2C_SDAT: INOUT	STD_LOGIC;
		I2C_SCL: OUT STD_LOGIC;
		gx: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		gy: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		gz: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		ax: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		ay: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		az: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END mpu_rg;

ARCHITECTURE SOLUCION OF mpu_rg IS
SIGNAL resetn, GO,  SDA, SCL: STD_LOGIC;
signal data: std_logic_vector(15 downto 0);
signal address: std_logic_vector(6 downto 0) := "1101000"; ---mpu6050  default address
SIGNAL SD_COUNTER: INTEGER  RANGE 0 TO 610;
SIGNAL COUNT: STD_LOGIC_VECTOR(9 downto 0);

BEGIN
	RESETN <= reset_n;
	Process(CLOCK)
	BEGIN
		IF(RISING_EDGE(CLOCK)) THEN COUNT<=COUNT+1;
		END IF;
	END PROCESS;
	
	Process(COUNT(6), RESETN)
	BEGIN
		IF(RESETN/='1') THEN
			GO<='0';
		ELSIF(en='1') THEN
			GO<='1';
		END IF;
	END PROCESS;
	
	PROCESS(COUNT(6), RESETN)
	BEGIN
		IF(RESETN/='1') THEN
			SD_COUNTER<=0;
		ELSIF(RISING_EDGE(COUNT(6))) THEN
			IF (GO/='1') THEN
				SD_COUNTER<=0;
			ELSIF(SD_COUNTER<603) THEN
				SD_COUNTER<=SD_COUNTER+1;
			ElSE
				SD_COUNTER<=0;
				
			END IF;
		END IF;
	END PROCESS;

--i2C OPERATION
	PROCESS(COUNT(6), RESETN)
	BEGIN
		IF(RESETN/='1') THEN
			SCL<='1';
			SDA<='1';
		ELSIF(RISING_EDGE(COUNT(6))) THEN
			CASE(SD_COUNTER) IS
			
--****************************************X0*****************************************************			
			--START
				WHEN 0	=>	SDA<='1'; SCL<='1';
				WHEN 1	=>	SDA<='0';
				WHEN 2	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 3	=>	SDA<=address(6);
				WHEN 4	=>	SDA<=address(5);---******************************
				WHEN 5	=>	SDA<=address(4);
				WHEN 6	=>	SDA<=address(3);
				WHEN 7	=>	SDA<=address(2);
				WHEN 8	=>	SDA<=address(1);
				WHEN 9	=>	SDA<=address(0);
				WHEN 10	=>	SDA<='0';
				WHEN 11	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 12	=>	SDA<='0';
				WHEN 13	=>	SDA<='1';
				WHEN 14	=>	SDA<='0';
				WHEN 15	=>	SDA<='0';
				WHEN 16	=>	SDA<='0';
				WHEN 17	=>	SDA<='1'; --44
				WHEN 18	=>	SDA<='0';
				WHEN 19	=>	SDA<='0';
				WHEN 20	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 21	=>
				
			--START
				WHEN 22	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 23	=>	SDA<='0';
				WHEN 24	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 25	=>	SDA<=address(6);
				WHEN 26	=>	SDA<=address(5);---*****************************
				WHEN 27	=>	SDA<=address(4);
				WHEN 28	=>	SDA<=address(3);
				WHEN 29	=>	SDA<=address(2);
				WHEN 30	=>	SDA<=address(1);
				WHEN 31	=>	SDA<=address(0);
				WHEN 32	=>	SDA<='1';
				WHEN 33	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 34	=>
				WHEN 35	=>	data(7)<=I2C_SDAT;
				WHEN 36	=>	data(6)<=I2C_SDAT;
				WHEN 37	=>	data(5)<=I2C_SDAT;
				WHEN 38	=>	data(4)<=I2C_SDAT;
				WHEN 39	=>	data(3)<=I2C_SDAT;
				WHEN 40	=>	data(2)<=I2C_SDAT;
				WHEN 41	=>	data(1)<=I2C_SDAT;
				WHEN 42	=>	data(0)<=I2C_SDAT;
				WHEN 43	=> SDA<='0';--TO Slave ACK		
				
			--STOP
				WHEN 44	=>	SDA<='0'; ---*********************************
				WHEN 45	=>	SCL<='1';
				WHEN 46	=>	SDA <= '1';
				
				
--*****************************************X1************************************************************				
			--START
				WHEN 48	=>	SDA<='1'; SCL<='1';
				WHEN 49	=>	SDA<='0';
				WHEN 50	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 51	=>	SDA<=address(6);
				WHEN 52	=>	SDA<=address(5);---******************************
				WHEN 53	=>	SDA<=address(4);
				WHEN 54	=>	SDA<=address(3);
				WHEN 55	=>	SDA<=address(2);
				WHEN 56	=>	SDA<=address(1);
				WHEN 57	=>	SDA<=address(0);
				WHEN 58	=>	SDA<='0';
				WHEN 59	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 60	=>	SDA<='0';
				WHEN 61	=>	SDA<='1';
				WHEN 62	=>	SDA<='0';
				WHEN 63	=>	SDA<='0';
				WHEN 64	=>	SDA<='0';
				WHEN 65	=>	SDA<='0';
				WHEN 66	=>	SDA<='1';
				WHEN 67	=>	SDA<='1';
				WHEN 68	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 69	=>
				
			--START
				WHEN 70	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 71	=>	SDA<='0';
				WHEN 72	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 73	=>	SDA<=address(6);
				WHEN 74	=>	SDA<=address(5);---*****************************
				WHEN 75	=>	SDA<=address(4);
				WHEN 76	=>	SDA<=address(3);
				WHEN 77	=>	SDA<=address(2);
				WHEN 78	=>	SDA<=address(1);
				WHEN 79	=>	SDA<=address(0);
				WHEN 80	=>	SDA<='1';
				WHEN 81	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 82	=>
				WHEN 83	=>	data(15)<=I2C_SDAT;
				WHEN 84	=>	data(14)<=I2C_SDAT;
				WHEN 85	=>	data(13)<=I2C_SDAT;
				WHEN 86	=>	data(12)<=I2C_SDAT;
				WHEN 87	=>	data(11)<=I2C_SDAT;
				WHEN 88	=>	data(10)<=I2C_SDAT;
				WHEN 89	=>	data(9)<=I2C_SDAT;
				WHEN 90	=>	data(8)<=I2C_SDAT;
				WHEN 91	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 92	=>	SDA<='0'; ---*********************************
				WHEN 93	=>	SCL<='1';gx<=data;
				WHEN 94	=>	SDA <= '1';			
				
--***************************************Y0***********************************************

			--START
				WHEN 96	=>	SDA<='1'; SCL<='1';
				WHEN 97	=>	SDA<='0';
				WHEN 98	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 99	=>	SDA<=address(6);
				WHEN 100	=>	SDA<=address(5);---******************************
				WHEN 101	=>	SDA<=address(4);
				WHEN 102	=>	SDA<=address(3);
				WHEN 103	=>	SDA<=address(2);
				WHEN 104	=>	SDA<=address(1);
				WHEN 105	=>	SDA<=address(0);
				WHEN 106	=>	SDA<='0';
				WHEN 107	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 108	=>	SDA<='0';
				WHEN 109	=>	SDA<='1';
				WHEN 110	=>	SDA<='0';
				WHEN 111	=>	SDA<='0';--46
				WHEN 112	=>	SDA<='0';
				WHEN 113	=>	SDA<='1';
				WHEN 114	=>	SDA<='1';
				WHEN 115	=>	SDA<='0';
				WHEN 116	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 117	=>
				
			--START
				WHEN 118	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 119	=>	SDA<='0';
				WHEN 120	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 121	=>	SDA<=address(6);
				WHEN 122	=>	SDA<=address(5);---*****************************
				WHEN 123	=>	SDA<=address(4);
				WHEN 124	=>	SDA<=address(3);
				WHEN 125	=>	SDA<=address(2);
				WHEN 126	=>	SDA<=address(1);
				WHEN 127	=>	SDA<=address(0);
				WHEN 128	=>	SDA<='1';
				WHEN 129	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 130	=>
				WHEN 131	=>	data(7)<=I2C_SDAT;
				WHEN 132	=>	data(6)<=I2C_SDAT;
				WHEN 133	=>	data(5)<=I2C_SDAT;
				WHEN 134	=>	data(4)<=I2C_SDAT;
				WHEN 135	=>	data(3)<=I2C_SDAT;
				WHEN 136	=>	data(2)<=I2C_SDAT;
				WHEN 137	=>	data(1)<=I2C_SDAT;
				WHEN 138	=>	data(0)<=I2C_SDAT;
				WHEN 139	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 140	=>	SDA<='0'; ---*********************************
				WHEN 141	=>	SCL<='1';
				WHEN 142	=>	SDA <= '1';				
				

--**************************************Y1**********************************************
			
			--START
				WHEN 144	=>	SDA<='1'; SCL<='1';
				WHEN 145	=>	SDA<='0';
				WHEN 146	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 147	=>	SDA<=address(6);
				WHEN 148	=>	SDA<=address(5);---******************************
				WHEN 149	=>	SDA<=address(4);
				WHEN 150	=>	SDA<=address(3);
				WHEN 151	=>	SDA<=address(2);
				WHEN 152	=>	SDA<=address(1);
				WHEN 153	=>	SDA<=address(0);
				WHEN 154	=>	SDA<='0';
				WHEN 155	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 156	=>	SDA<='0';
				WHEN 157	=>	SDA<='1';
				WHEN 158	=>	SDA<='0';
				WHEN 159	=>	SDA<='0';
				WHEN 160	=>	SDA<='0';--45
				WHEN 161	=>	SDA<='1';
				WHEN 162	=>	SDA<='0';
				WHEN 163	=>	SDA<='1';
				WHEN 164	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 165	=>
				
			--START
				WHEN 166	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 167	=>	SDA<='0';
				WHEN 168	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 169	=>	SDA<=address(6);
				WHEN 170	=>	SDA<=address(5);---*****************************
				WHEN 171	=>	SDA<=address(4);
				WHEN 172	=>	SDA<=address(3);
				WHEN 173	=>	SDA<=address(2);
				WHEN 174	=>	SDA<=address(1);
				WHEN 175	=>	SDA<=address(0);
				WHEN 176	=>	SDA<='1';
				WHEN 177	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 178	=>
				WHEN 179	=>	data(15)<=I2C_SDAT;
				WHEN 180	=>	data(14)<=I2C_SDAT;
				WHEN 181	=>	data(13)<=I2C_SDAT;
				WHEN 182	=>	data(12)<=I2C_SDAT;
				WHEN 183	=>	data(11)<=I2C_SDAT;
				WHEN 184	=>	data(10)<=I2C_SDAT;
				WHEN 185	=>	data(9)<=I2C_SDAT;
				WHEN 186	=>	data(8)<=I2C_SDAT;
				WHEN 187	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 188	=>	SDA<='0'; ---*********************************
				WHEN 189	=>	SCL<='1'; gy<=data;
				WHEN 190	=>	SDA <= '1';
	

--***************************************Z0***********************************************

			--START
				WHEN 192	=>	SDA<='1'; SCL<='1';
				WHEN 193	=>	SDA<='0';
				WHEN 194	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 195	=>	SDA<=address(6);
				WHEN 196	=>	SDA<=address(5);---******************************
				WHEN 197	=>	SDA<=address(4);
				WHEN 198	=>	SDA<=address(3);
				WHEN 199	=>	SDA<=address(2);
				WHEN 200	=>	SDA<=address(1);
				WHEN 201	=>	SDA<=address(0);
				WHEN 202	=>	SDA<='0';
				WHEN 203	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 204	=>	SDA<='0';
				WHEN 205	=>	SDA<='1';
				WHEN 206	=>	SDA<='0';
				WHEN 207	=>	SDA<='0';
				WHEN 208	=>	SDA<='1';
				WHEN 209	=>	SDA<='0';--48
				WHEN 210	=>	SDA<='0';
				WHEN 211	=>	SDA<='0';
				WHEN 212	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 213	=>
				
			--START
				WHEN 214	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 215	=>	SDA<='0';
				WHEN 216	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 217	=>	SDA<=address(6);
				WHEN 218	=>	SDA<=address(5);---******************************
				WHEN 219	=>	SDA<=address(4);
				WHEN 220	=>	SDA<=address(3);
				WHEN 221	=>	SDA<=address(2);
				WHEN 222	=>	SDA<=address(1);
				WHEN 223	=>	SDA<=address(0);
				WHEN 224	=>	SDA<='1';
				WHEN 225	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 226	=>
				WHEN 227	=>	data(7)<=I2C_SDAT;
				WHEN 228	=>	data(6)<=I2C_SDAT;
				WHEN 229	=>	data(5)<=I2C_SDAT;
				WHEN 230	=>	data(4)<=I2C_SDAT;
				WHEN 231	=>	data(3)<=I2C_SDAT;
				WHEN 232	=>	data(2)<=I2C_SDAT;
				WHEN 233	=>	data(1)<=I2C_SDAT;
				WHEN 234	=>	data(0)<=I2C_SDAT;
				WHEN 235	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 236	=>	SDA<='0'; ---*********************************
				WHEN 237	=>	SCL<='1';
				WHEN 238	=>	SDA <= '1';
				

--***************************************Z1***********************************************

			--START
				WHEN 239	=>	SDA<='1'; SCL<='1';
				WHEN 240	=>	SDA<='0';
				WHEN 241	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 242	=>	SDA<=address(6);
				WHEN 243	=>	SDA<=address(5);---******************************
				WHEN 244	=>	SDA<=address(4);
				WHEN 245	=>	SDA<=address(3);
				WHEN 246	=>	SDA<=address(2);
				WHEN 247	=>	SDA<=address(1);
				WHEN 248	=>	SDA<=address(0);
				WHEN 249	=>	SDA<='0';
				WHEN 250	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 251	=>	SDA<='0';
				WHEN 252	=>	SDA<='1';
				WHEN 253	=>	SDA<='0';
				WHEN 254	=>	SDA<='0';
				WHEN 255	=>	SDA<='0';
				WHEN 256	=>	SDA<='1';--47
				WHEN 257	=>	SDA<='1';
				WHEN 258	=>	SDA<='1';
				WHEN 259	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 260	=>
				
			--START
				WHEN 261	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 262	=>	SDA<='0';
				WHEN 263	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 264	=>	SDA<=address(6);
				WHEN 265	=>	SDA<=address(5);---******************************
				WHEN 266	=>	SDA<=address(4);
				WHEN 267	=>	SDA<=address(3);
				WHEN 268	=>	SDA<=address(2);
				WHEN 269	=>	SDA<=address(1);
				WHEN 270	=>	SDA<=address(0);
				WHEN 271	=>	SDA<='1';
				WHEN 272	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 273	=>
				WHEN 274	=>	data(15)<=I2C_SDAT;
				WHEN 275	=>	data(14)<=I2C_SDAT;
				WHEN 276	=>	data(13)<=I2C_SDAT;
				WHEN 277	=>	data(12)<=I2C_SDAT;
				WHEN 278	=>	data(11)<=I2C_SDAT;
				WHEN 279	=>	data(10)<=I2C_SDAT;
				WHEN 280	=>	data(9)<=I2C_SDAT;
				WHEN 281	=>	data(8)<=I2C_SDAT;
				WHEN 282	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 283	=>	SDA<='0'; ---*********************************
				WHEN 284	=>	SCL<='1'; gz<=data;
				WHEN 285	=>	SDA <= '1';	
	-----------------------------------------------------------	
--***************************************ax1***********************************************

			--START
				WHEN 286	=>	SDA<='1'; SCL<='1';
				WHEN 287	=>	SDA<='0';
				WHEN 288	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 289	=>	SDA<=address(6);
				WHEN 290	=>	SDA<=address(5);---******************************
				WHEN 291	=>	SDA<=address(4);
				WHEN 292	=>	SDA<=address(3);
				WHEN 293	=>	SDA<=address(2);
				WHEN 294	=>	SDA<=address(1);
				WHEN 295	=>	SDA<=address(0);
				WHEN 296	=>	SDA<='0';
				WHEN 297	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 298	=>	SDA<='0';
				WHEN 299	=>	SDA<='0';
				WHEN 300	=>	SDA<='1';
				WHEN 301	=>	SDA<='1';
				WHEN 302	=>	SDA<='1';
				WHEN 303	=>	SDA<='0';
				WHEN 304	=>	SDA<='1';
				WHEN 305	=>	SDA<='1';
				WHEN 306	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 307	=>
				
			--START
				WHEN 308	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 309	=>	SDA<='0';
				WHEN 310	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 311	=>	SDA<=address(6);
				WHEN 312	=>	SDA<=address(5);---******************************
				WHEN 313	=>	SDA<=address(4);
				WHEN 314	=>	SDA<=address(3);
				WHEN 315	=>	SDA<=address(2);
				WHEN 316	=>	SDA<=address(1);
				WHEN 317	=>	SDA<=address(0);
				WHEN 318	=>	SDA<='1';
				WHEN 319	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 320	=>
				WHEN 321	=>	data(15)<=I2C_SDAT;
				WHEN 322	=>	data(14)<=I2C_SDAT;
				WHEN 323	=>	data(13)<=I2C_SDAT;
				WHEN 324	=>	data(12)<=I2C_SDAT;
				WHEN 325	=>	data(11)<=I2C_SDAT;
				WHEN 326	=>	data(10)<=I2C_SDAT;
				WHEN 327	=>	data(9)<=I2C_SDAT;
				WHEN 328	=>	data(8)<=I2C_SDAT;
				WHEN 329	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 330	=>	SDA<='0'; ---*********************************
				WHEN 331	=>	SCL<='1';
				WHEN 334	=>	SDA <= '1';		
				--------------------------------------------------------
					-----------------------------------------------------------	
--***************************************ax0***********************************************

			--START
				WHEN 335	=>	SDA<='1'; SCL<='1';
				WHEN 336	=>	SDA<='0';
				WHEN 337	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 338	=>	SDA<=address(6);
				WHEN 339	=>	SDA<=address(5);---******************************
				WHEN 340	=>	SDA<=address(4);
				WHEN 341	=>	SDA<=address(3);
				WHEN 342	=>	SDA<=address(2);
				WHEN 343	=>	SDA<=address(1);
				WHEN 344	=>	SDA<=address(0);
				WHEN 345	=>	SDA<='0';
				WHEN 346	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 347	=>	SDA<='0';
				WHEN 348	=>	SDA<='0';
				WHEN 349	=>	SDA<='1';
				WHEN 350	=>	SDA<='1';
				WHEN 351	=>	SDA<='1';
				WHEN 352	=>	SDA<='1';
				WHEN 353	=>	SDA<='0';
				WHEN 354	=>	SDA<='0';
				WHEN 355	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 356	=>
				
			--START
				WHEN 357	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 358	=>	SDA<='0';
				WHEN 359	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 360	=>	SDA<=address(6);
				WHEN 361	=>	SDA<=address(5);---******************************
				WHEN 362	=>	SDA<=address(4);
				WHEN 363	=>	SDA<=address(3);
				WHEN 364	=>	SDA<=address(2);
				WHEN 365	=>	SDA<=address(1);
				WHEN 366	=>	SDA<=address(0);
				WHEN 367	=>	SDA<='1';
				WHEN 368	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 369	=>
				WHEN 370	=>	data(7)<=I2C_SDAT;
				WHEN 371	=>	data(6)<=I2C_SDAT;
				WHEN 372	=>	data(5)<=I2C_SDAT;
				WHEN 373	=>	data(4)<=I2C_SDAT;
				WHEN 374	=>	data(3)<=I2C_SDAT;
				WHEN 375	=>	data(2)<=I2C_SDAT;
				WHEN 376	=>	data(1)<=I2C_SDAT;
				WHEN 377	=>	data(0)<=I2C_SDAT;
				WHEN 378	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 379	=>	SDA<='0'; ---*********************************
				WHEN 380	=>	SCL<='1'; ax<=data;
				WHEN 381	=>	SDA <= '1';		
				--------------------------------------------------------
					-----------------------------------------------------------	
--***************************************ay1***********************************************

			--START
				WHEN 382	=>	SDA<='1'; SCL<='1';
				WHEN 383	=>	SDA<='0';
				WHEN 384	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 385	=>	SDA<=address(6);
				WHEN 386	=>	SDA<=address(5);---******************************
				WHEN 387	=>	SDA<=address(4);
				WHEN 388	=>	SDA<=address(3);
				WHEN 389	=>	SDA<=address(2);
				WHEN 390	=>	SDA<=address(1);
				WHEN 391	=>	SDA<=address(0);
				WHEN 392	=>	SDA<='0';
				WHEN 393	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 394	=>	SDA<='0';
				WHEN 395	=>	SDA<='0';
				WHEN 396	=>	SDA<='1';
				WHEN 397	=>	SDA<='1';
				WHEN 398	=>	SDA<='1';
				WHEN 399	=>	SDA<='1';
				WHEN 400	=>	SDA<='0';
				WHEN 401	=>	SDA<='1';
				WHEN 402	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 403	=>
				
			--START
				WHEN 404	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 405	=>	SDA<='0';
				WHEN 406	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 407	=>	SDA<=address(6);
				WHEN 408	=>	SDA<=address(5);---******************************
				WHEN 409	=>	SDA<=address(4);
				WHEN 410	=>	SDA<=address(3);
				WHEN 411	=>	SDA<=address(2);
				WHEN 412	=>	SDA<=address(1);
				WHEN 413	=>	SDA<=address(0);
				WHEN 414	=>	SDA<='1';
				WHEN 415	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 416	=>
				WHEN 417	=>	data(15)<=I2C_SDAT;
				WHEN 418	=>	data(14)<=I2C_SDAT;
				WHEN 419	=>	data(13)<=I2C_SDAT;
				WHEN 420	=>	data(12)<=I2C_SDAT;
				WHEN 421	=>	data(11)<=I2C_SDAT;
				WHEN 422	=>	data(10)<=I2C_SDAT;
				WHEN 423	=>	data(9)<=I2C_SDAT;
				WHEN 424	=>	data(8)<=I2C_SDAT;
				WHEN 425	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 426	=>	SDA<='0'; ---*********************************
				WHEN 427	=>	SCL<='1';
				WHEN 428	=>	SDA <= '1';		
				--------------------------------------------------------
					-----------------------------------------------------------	
--***************************************ay0***********************************************

			--START
				WHEN 429	=>	SDA<='1'; SCL<='1';
				WHEN 430	=>	SDA<='0';
				WHEN 431	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 432	=>	SDA<=address(6);
				WHEN 433	=>	SDA<=address(5);---******************************
				WHEN 434	=>	SDA<=address(4);
				WHEN 435	=>	SDA<=address(3);
				WHEN 436	=>	SDA<=address(2);
				WHEN 437	=>	SDA<=address(1);
				WHEN 438	=>	SDA<=address(0);
				WHEN 439	=>	SDA<='0';
				WHEN 440	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 441	=>	SDA<='0';
				WHEN 442	=>	SDA<='0';
				WHEN 443	=>	SDA<='1';
				WHEN 444	=>	SDA<='1';
				WHEN 445	=>	SDA<='1';
				WHEN 446	=>	SDA<='1';
				WHEN 447	=>	SDA<='1';
				WHEN 448	=>	SDA<='0';
				WHEN 449	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 450	=>
				
			--START
				WHEN 451	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 452	=>	SDA<='0';
				WHEN 453	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 454	=>	SDA<=address(6);
				WHEN 455	=>	SDA<=address(5);---******************************
				WHEN 456	=>	SDA<=address(4);
				WHEN 457	=>	SDA<=address(3);
				WHEN 458	=>	SDA<=address(2);
				WHEN 459	=>	SDA<=address(1);
				WHEN 460	=>	SDA<=address(0);
				WHEN 461	=>	SDA<='1';
				WHEN 462	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 463	=>
				WHEN 464	=>	data(7)<=I2C_SDAT;
				WHEN 465	=>	data(6)<=I2C_SDAT;
				WHEN 466	=>	data(5)<=I2C_SDAT;
				WHEN 467	=>	data(4)<=I2C_SDAT;
				WHEN 468	=>	data(3)<=I2C_SDAT;
				WHEN 469	=>	data(2)<=I2C_SDAT;
				WHEN 470	=>	data(1)<=I2C_SDAT;
				WHEN 471	=>	data(0)<=I2C_SDAT;
				WHEN 472	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 473	=>	SDA<='0'; ---*********************************
				WHEN 474	=>	SCL<='1'; ay<=data;
				WHEN 475	=>	SDA <= '1';		
				--------------------------------------------------------
				
									-----------------------------------------------------------	
--***************************************az1***********************************************

			--START
				WHEN 476	=>	SDA<='1'; SCL<='1';
				WHEN 477	=>	SDA<='0';
				WHEN 478	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 479	=>	SDA<=address(6);
				WHEN 480	=>	SDA<=address(5);---******************************
				WHEN 481	=>	SDA<=address(4);
				WHEN 482	=>	SDA<=address(3);
				WHEN 483	=>	SDA<=address(2);
				WHEN 484	=>	SDA<=address(1);
				WHEN 485	=>	SDA<=address(0);
				WHEN 486	=>	SDA<='0';
				WHEN 487	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 488	=>	SDA<='0';
				WHEN 489	=>	SDA<='0';
				WHEN 490	=>	SDA<='1';
				WHEN 491	=>	SDA<='1';
				WHEN 492	=>	SDA<='1';
				WHEN 493	=>	SDA<='1';
				WHEN 494	=>	SDA<='1';
				WHEN 495	=>	SDA<='1';
				WHEN 496	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 497	=>
				
			--START
				WHEN 498	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 499	=>	SDA<='0';
				WHEN 500	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 501	=>	SDA<=address(6);
				WHEN 502	=>	SDA<=address(5);---******************************
				WHEN 503	=>	SDA<=address(4);
				WHEN 504	=>	SDA<=address(3);
				WHEN 505	=>	SDA<=address(2);
				WHEN 506	=>	SDA<=address(1);
				WHEN 507	=>	SDA<=address(0);
				WHEN 508	=>	SDA<='1';
				WHEN 509	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 510	=>
				WHEN 511	=>	data(15)<=I2C_SDAT;
				WHEN 512	=>	data(14)<=I2C_SDAT;
				WHEN 513	=>	data(13)<=I2C_SDAT;
				WHEN 514	=>	data(12)<=I2C_SDAT;
				WHEN 515	=>	data(11)<=I2C_SDAT;
				WHEN 516	=>	data(10)<=I2C_SDAT;
				WHEN 517	=>	data(9)<=I2C_SDAT;
				WHEN 518	=>	data(8)<=I2C_SDAT;
				WHEN 519	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 520	=>	SDA<='0'; ---*********************************
				WHEN 521	=>	SCL<='1';
				WHEN 522	=>	SDA <= '1';		
				--------------------------------------------------------
				
									-----------------------------------------------------------	
--***************************************az0***********************************************

			--START
				WHEN 523	=>	SDA<='1'; SCL<='1';
				WHEN 524	=>	SDA<='0';
				WHEN 525	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 526	=>	SDA<=address(6);
				WHEN 527	=>	SDA<=address(5);---******************************
				WHEN 528	=>	SDA<=address(4);
				WHEN 529	=>	SDA<=address(3);
				WHEN 530	=>	SDA<=address(2);
				WHEN 531	=>	SDA<=address(1);
				WHEN 532	=>	SDA<=address(0);
				WHEN 533	=>	SDA<='0';
				WHEN 534	=>	SDA<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 535	=>	SDA<='0';
				WHEN 536	=>	SDA<='1';
				WHEN 537	=>	SDA<='0';
				WHEN 538	=>	SDA<='0';
				WHEN 539	=>	SDA<='0';
				WHEN 540	=>	SDA<='0';
				WHEN 541	=>	SDA<='0';
				WHEN 542	=>	SDA<='0';
				WHEN 543	=>	SDA<='Z';-- FROM Slave ACK
				WHEN 544	=>
				
			--START
				WHEN 545	=>	SDA<='1'; SCL<='1';--------------------*****************
				WHEN 546	=>	SDA<='0';
				WHEN 547	=>	SCL<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 548	=>	SDA<=address(6);
				WHEN 549	=>	SDA<=address(5);---******************************
				WHEN 550	=>	SDA<=address(4);
				WHEN 551	=>	SDA<=address(3);
				WHEN 552	=>	SDA<=address(2);
				WHEN 553	=>	SDA<=address(1);
				WHEN 554	=>	SDA<=address(0);
				WHEN 555	=>	SDA<='1';
				WHEN 556	=>	SDA<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 557	=>
				WHEN 558	=>	data(7)<=I2C_SDAT;
				WHEN 559	=>	data(6)<=I2C_SDAT;
				WHEN 560	=>	data(5)<=I2C_SDAT;
				WHEN 561	=>	data(4)<=I2C_SDAT;
				WHEN 562	=>	data(3)<=I2C_SDAT;
				WHEN 563	=>	data(2)<=I2C_SDAT;
				WHEN 564	=>	data(1)<=I2C_SDAT;
				WHEN 565	=>	data(0)<=I2C_SDAT;
				WHEN 566	=> SDA<='1';--TO Slave ACK		
				
			--STOP
				WHEN 567	=>	SDA<='0'; ---*********************************
				WHEN 568	=>	SCL<='1'; az<=data;
				WHEN 569	=>	SDA <= '1';		
				--------------------------------------------------------
				--*********************************REGISTRO (0X6b)************************************************************			
			--START
				WHEN 570	=>	SDA<='1'; SCL<='1';
				WHEN 571	=>	SDA<='0';
				WHEN 572	=>	SCL<='0';
	
			--DIRECCIÓN DEL ESCLAVO  ESCRITURA
				WHEN 573	=>	SDA<=address(6);
				WHEN 574	=>	SDA<=address(5);---******************************
				WHEN 575	=>	SDA<=address(4);
				WHEN 576	=>	SDA<=address(3);
				WHEN 577	=>	SDA<=address(2);
				WHEN 578	=>	SDA<=address(1);
				WHEN 579	=>	SDA<=address(0);
				WHEN 580	=>	SDA<='0';
				WHEN 581	=>	SDA<='Z';--Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A ESCRIBIR)
				WHEN 582	=>	SDA<='0';
				WHEN 583	=>	SDA<='1';
				WHEN 584	=>	SDA<='1';
				WHEN 585	=>	SDA<='0';
				WHEN 586	=>	SDA<='1';
				WHEN 587	=>	SDA<='0';
				WHEN 588	=>	SDA<='1';
				WHEN 589	=>	SDA<='1';--(0X6b)
				WHEN 590	=>	SDA<='Z';--Slave ACK
				
			--DATA
				WHEN 591	=>	SDA<='0';
				WHEN 592	=>	SDA<='0';
				WHEN 593	=>	SDA<='0';
				WHEN 594	=>	SDA<='0';
				WHEN 595	=>	SDA<='0';
				WHEN 596	=>	SDA<='0';
				WHEN 597	=>	SDA<='0';
				WHEN 598	=>	SDA<='0';
				WHEN 599	=>	SDA<='Z';--Slave ACK

			--STOP
				WHEN 600	=>		SDA<='0';--****************************************
				WHEN 601	=>	  SCL<='1'; 
				WHEN 602	=>	 SDA <= '1';
				------------------------------------------------------------------------
				
				WHEN OTHERS =>	SDA<='1'; SCL<='1';

			END CASE;
		END IF;
	END PROCESS;
	I2C_SCL<= NOT(COUNT(6)) WHEN ( ((SD_COUNTER >= 4) AND (SD_COUNTER <= 22)) OR ((SD_COUNTER >= 26) AND (SD_COUNTER <= 44))
								OR ((SD_COUNTER >= 52) AND (SD_COUNTER <= 70)) OR ((SD_COUNTER >= 74) AND (SD_COUNTER <= 92))
								OR ((SD_COUNTER >= 100) AND (SD_COUNTER <= 118)) OR ((SD_COUNTER >= 122) AND (SD_COUNTER <= 140))
								OR ((SD_COUNTER >= 148) AND (SD_COUNTER <= 166)) OR ((SD_COUNTER >= 170) AND (SD_COUNTER <= 188))
								OR ((SD_COUNTER >= 196) AND (SD_COUNTER <= 214)) OR ((SD_COUNTER >= 218) AND (SD_COUNTER <= 236))
								OR ((SD_COUNTER >= 243) AND (SD_COUNTER <= 261)) OR ((SD_COUNTER >= 265) AND (SD_COUNTER <= 283))
								OR ((SD_COUNTER >= 290) AND (SD_COUNTER <= 308)) OR ((SD_COUNTER >= 312) AND (SD_COUNTER <= 330))
								OR ((SD_COUNTER >= 339) AND (SD_COUNTER <= 357)) OR ((SD_COUNTER >= 361) AND (SD_COUNTER <= 379))
								OR ((SD_COUNTER >= 386) AND (SD_COUNTER <= 404)) OR ((SD_COUNTER >= 408) AND (SD_COUNTER <= 426))
								OR ((SD_COUNTER >= 433) AND (SD_COUNTER <= 451)) OR ((SD_COUNTER >= 455) AND (SD_COUNTER <= 473))
								OR ((SD_COUNTER >= 480) AND (SD_COUNTER <= 498)) OR ((SD_COUNTER >= 502) AND (SD_COUNTER <= 520))
								OR ((SD_COUNTER >= 527) AND (SD_COUNTER <= 545)) OR ((SD_COUNTER >= 549) AND (SD_COUNTER <= 567))
								OR ((SD_COUNTER >= 574) AND (SD_COUNTER <= 600))
								) ELSE SCL;
	I2C_SDAT<= SDA;
END SOLUCION;