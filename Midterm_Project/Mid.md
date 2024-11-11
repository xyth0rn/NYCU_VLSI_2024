# Midterm Project
## 1 Register Design Using CMOS Positive Trigger D Latch
### 1.1 Register Using Positive Trigger D Latch Testbench Result
25MHz Input Sequence: 1,1,0,1,0,0,1,0,1,1,1,0,0,1,0 <br>
Data rate: 25Mbps
```
* HW4_3_1.sp
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27

*----------------------------------------------------------------------
* Simulation netlist
* data sequence is 1,1,0,1,0,0,1,0,1,1,1,0,0,1,0 @25Mhz
*----------------------------------------------------------------------

* FIGURE 1.11
.subckt inv in out vdd gnd
MP1 out in vdd vdd p_18 W=250n L=270n M=2
MN1 out in gnd gnd N_18 W=250n L=900n M=1
.ends inv

* FIGURE 1.21
.subckt tgate a b g gb vdd gnd
MP1 a gb b vdd p_18 W=250n L=270n M=2
MN1 a g  b gnd N_18 W=250n L=900n M=1
.ends tgate

* FIGURE 1.31(b)
.subckt dlatch d q clk vdd gnd
xtgate1	d q clk clkb vdd gnd	tgate
xinv1 	q qb vdd gnd			inv
xinv2 	qb qbb vdd gnd			inv
xtgate2 qbb q clkb clk vdd gnd	tgate
xinv3	clk clkb vdd gnd 		inv
.ends dlatch

X1 d q clk vdd gnd	dlatch
Vdd vdd gnd 1.8
Vck clk gnd PULSE(0v 1.8v 10ns 0.1ns 0.1ns 19.9ns 40ns)
Vd  d   gnd PWL(0ns 		1.8v 	40ns 	1.8v	40.1ns 	1.8v 	80ns 	1.8v	80.1ns 	0v 	 	120ns 	0v		120.1ns 	1.8v 	160ns 	1.8v	160.1ns 	0v 	 	200ns 	0v		200.1ns 	0v 	 	240ns 	0v		240.1ns 	1.8v 	280ns 	1.8v	280.1ns 	0v 	 	320ns 	0v		320.1ns 	1.8v 	360ns 	1.8v	360.1ns 	1.8v 	400ns 	1.8v	400.1ns 	1.8v 	440ns 	1.8v	440.1ns 	0v 	 	480ns 	0v		480.1ns 	0v 	 	520ns 	0v		520.1ns 	1.8v 	560ns 	1.8v	560.1ns 	0v 	 	600ns 	0v		600.1ns 	0v		640ns 	0v)


*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
* 15x40ns = 600ns
*----------------------------------------------------------------------
.option post
.tran 1ps 640ns
.print tran v(d) v(q) v(clk) v(x1.clkb) v(x1.qb) v(x1.qbb)
.end
```
![image](https://github.com/user-attachments/assets/63a71403-c520-4cd4-b7cb-823e3babecee)

## 1.2 Additional Testbench: Non-synchronized Input and Clock Signal
Here we test a case where the input signal is not in sync with the clock signal to verify the latch function.  
```
* HW4_3_1_2.sp
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27

*----------------------------------------------------------------------
* Simulation netlist
* d latch functional testbench @25Mhz
*----------------------------------------------------------------------

* FIGURE 1.11
.subckt inv in out vdd gnd
MP1 out in vdd vdd p_18 W=250n L=270n M=2
MN1 out in gnd gnd N_18 W=250n L=900n M=1
.ends inv

* FIGURE 1.21
.subckt tgate a b g gb vdd gnd
MP1 a gb b vdd p_18 W=250n L=270n M=2
MN1 a g  b gnd N_18 W=250n L=900n M=1
.ends tgate

* FIGURE 1.31(b)
.subckt dlatch d q clk vdd gnd
xtgate1	d q clk clkb vdd gnd	tgate
xinv1 	q qb vdd gnd			inv
xinv2 	qb qbb vdd gnd			inv
xtgate2 qbb q clkb clk vdd gnd	tgate
xinv3	clk clkb vdd gnd 		inv
.ends dlatch

X1 d q clk vdd gnd	dlatch
Vdd vdd gnd 1.8
Vck clk gnd PULSE(0v 1.8v 20ns 0.1ns 0.1ns 19.9ns 40ns)
Vd  d   gnd PWL(0ns 	0v 		5ns 	0v	5.1ns 	1.8v 	15ns 	1.8v	15.1ns 	0v 	 	25ns 	0v		25.1ns 	1.8v 	35ns 	1.8v	35.1ns 	0v 	 	50ns 	0v		50.1ns 	1.8v 	70ns 	1.8v		70.1ns 	0v 		110ns 	0v	110.1ns 1.8v 	130ns 	1.8v		130.1ns 0v 		160ns 	0v)


*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
* 15x40ns = 600ns
*----------------------------------------------------------------------
.option post
.tran 1ps 160ns
.print tran v(d) v(q) v(clk) v(x1.clkb) v(x1.qb) v(x1.qbb)
.end
```
![HW4_3_1_2](https://github.com/user-attachments/assets/e27dfb29-9746-4890-a52c-37ebc6411cc5)


## 2 Two Input Decoder
Here we attempt to design a two input decoder using footed and unfooted dynamic gates (referencing figures 9.22 ~ 9.25 from the textbook). By comparing the following results, we can conclude that the 3-stage decoder designs have better performance.   
![image](https://github.com/user-attachments/assets/007267bd-58b4-4edf-8e12-3a328f2cfe7f) <br>
![image](https://github.com/user-attachments/assets/681b3fd3-d957-477a-81e7-1fcb8c1c84b6)
![image](https://github.com/user-attachments/assets/e53d9505-eba6-4a40-ab03-5e0d72c3ee56)
![image](https://github.com/user-attachments/assets/a72fac25-7124-494b-a153-b862fcf60a5a)

### Basic Components
#### Footed Domino AND Gate
![image](https://github.com/user-attachments/assets/d01b0624-2441-4085-b195-d01788272744)

#### Footed Domino NOR Gate
![image](https://github.com/user-attachments/assets/d084c593-e131-458d-b15f-1b010701b48c)


#### Unfooted Domino AND Gate
![image](https://github.com/user-attachments/assets/9ea48992-597c-416e-96aa-4da155450c5d)

#### Unfooted Domino NOR Gate
![image](https://github.com/user-attachments/assets/0639873e-c674-42d5-acf6-567f7860ec44)


### Decoder Structure Design
Both the 2-stage and 3-stage designs are tested.
![image](https://github.com/user-attachments/assets/e77ffb3a-ce03-4ca1-9215-a5d2620ad0bc)

#### 2-1 2-stage Unfooted Domino AND Decoder 8x8=64
```
* HW4_3_2_2.sp 
* 2 stage unfooted Domino AND Decoder 8x8=64
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------

* FIGURE 1.11 inverter
.subckt inv in out vdd gnd
MP1 out in vdd vdd p_18 W=250n L=270n M=2
MN1 out in gnd gnd N_18 W=250n L=900n M=1
.ends inv


* FIGURE 9.28(a) 2 Stage Unfooted Domino AND
.subckt UDAND a b x ck vdd gnd
* ------------------------------------------------
* Unfooted Dynamic NAND x1
MP1 w  ck vdd vdd p_18 W=250n L=270n M=1
MN1 w  a  n   gnd N_18 W=250n L=900n M=2
MN2 n  b  gnd gnd N_18 W=250n L=900n M=2
* ------------------------------------------------
* Static inverter x8
XINV1 w x vdd gnd inv M=8
* ------------------------------------------------
.ends UDAND


* HW4 Fig3 2 Input Decoder
.subckt DECODER2 a e ck a_e a_eb ab_e ab_eb vdd gnd
XINV1 a ab vdd gnd	inv
XINV2 e eb vdd gnd	inv
* decoder
X1AND a  e  a_e   ck vdd gnd UDAND
X2AND a  eb a_eb  ck vdd gnd UDAND
X3AND ab e  ab_e  ck vdd gnd UDAND
X4AND ab eb ab_eb ck vdd gnd UDAND
.ends DECODER2


Vdd vdd gnd 1.8
Vck clk gnd PULSE(0v 1.8v 20ns 0.1ns 0.1ns 19.9ns 40ns)
Va	a 	gnd PULSE(0v 1.8v 5ns  0.1ns 0.1ns 39.9ns 80ns)		* input can be changed @ precharge cycle
Ve	e 	gnd	PULSE(0v 1.8v 5ns  0.1ns 0.1ns 79.9ns 160ns)	* input can be changed @ precharge cycle

Xdec2 a e clk a_e a_eb ab_e ab_eb vdd gnd DECODER2

Xload1 a_e   n1 vdd gnd	inv M=64
Xload2 a_eb  n2 vdd gnd	inv M=64
Xload3 ab_e  n3 vdd gnd	inv M=64
Xload4 ab_eb n4 vdd gnd	inv M=64

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
*----------------------------------------------------------------------
.option post
.tran 1ps 200ns
.MEAS TRAN Trise    TRIG V(a_e) val=0.18 TD=20n RISE=1   TARG V(a_e) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(a_e) val=1.62 TD=20n FALL=1   TARG V(a_e) val=0.18 FALL=1
.print tran v(a) v(e) v(clk) v(a_e) v(a_eb) v(ab_e) v(ab_eb)
.end

*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* trise=  1.7975E-09
* tfall=  1.1561E-09
*
* HW4_3_2_2.png
* HW4_3_2_2_mark.png
* HW4_3_2_2_UDAND.png
* HW4_3_3_2_DECODER2.png
```
![HW4_3_2_2_mark](https://github.com/user-attachments/assets/36edfe86-ace6-407f-8624-d878ae66ec86)



### 2-2 3-stage Unfooted Domino NOR Decoder 4x4x4=64
```
* HW4_3_2_3.sp 
* 3 stage Unfooted Domino NOR Decoder 4x4x4=64
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------

* FIGURE 1.11 inverter
.subckt inv in out vdd gnd
MP1 out in vdd vdd p_18 W=250n L=270n M=2
MN1 out in gnd gnd N_18 W=250n L=900n M=1
.ends inv


* FIGURE 9.28(a) 3 Stage Unfooted Domino NOR
.subckt UDNOR a b x ck vdd gnd
* ------------------------------------------------
* Unfooted Dynamic NOR x1
MP1 w ck vdd vdd p_18 W=250n L=270n M=1
MN1 w a  gnd gnd N_18 W=250n L=900n M=1
MN2 w b  gnd gnd N_18 W=250n L=900n M=1
* ------------------------------------------------
* Static inverter x4
XINV1 w w1 vdd gnd inv M=4
* ------------------------------------------------
* Static inverter x16
XINV2 w1 x vdd gnd inv M=16
* ------------------------------------------------
.ends UDNOR


* HW4 Fig3 2 Input Decoder
.subckt DECODER2 a e ck a_e a_eb ab_e ab_eb vdd gnd
XINV1 a ab vdd gnd	inv
XINV2 e eb vdd gnd	inv
* decoder
X1OR ab eb a_e   ck vdd gnd UDNOR
X2OR ab e  a_eb  ck vdd gnd UDNOR
X3OR a  eb ab_e  ck vdd gnd UDNOR
X4OR a  e  ab_eb ck vdd gnd UDNOR
.ends DECODER2


Vdd vdd gnd 1.8
Vck clk gnd PULSE(0v 1.8v 20ns 0.1ns 0.1ns 19.9ns 40ns)
Va	a 	gnd PULSE(0v 1.8v 5ns  0.1ns 0.1ns 39.9ns 80ns)		* input can be changed @ precharge cycle
Ve	e 	gnd	PULSE(0v 1.8v 5ns  0.1ns 0.1ns 79.9ns 160ns)	* input can be changed @ precharge cycle

Xdec2 a e clk a_e a_eb ab_e ab_eb vdd gnd DECODER2

Xload1 a_e   n1 vdd gnd	inv M=64
Xload2 a_eb  n2 vdd gnd	inv M=64
Xload3 ab_e  n3 vdd gnd	inv M=64
Xload4 ab_eb n4 vdd gnd	inv M=64

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
*----------------------------------------------------------------------
.option post
.tran 1ps 200ns
.MEAS TRAN Trise    TRIG V(a_e) val=0.18 TD=20n RISE=1   TARG V(a_e) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(a_e) val=1.62 TD=20n FALL=1   TARG V(a_e) val=0.18 FALL=1
.print tran v(a) v(e) v(clk) v(a_e) v(a_eb) v(ab_e) v(ab_eb)
.end
```
![HW4_3_2_3_staticINV_mark](https://github.com/user-attachments/assets/bdb785e4-42c1-4bc3-bc6c-00ba2c818a6e)




### 2-3 2-stage Footed Domino AND Decoder 8x8=64
```
* HW4_3_3_2.sp 
* 2 stage Footed Domino AND Decoder 8x8=64
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------

* FIGURE 1.11 inverter
.subckt inv in out vdd gnd
MP1 out in vdd vdd p_18 W=250n L=270n M=2
MN1 out in gnd gnd N_18 W=250n L=900n M=1
.ends inv


* FIGURE 9.28(a) 2 Stage Footed Domino AND
.subckt FDAND a b x ck vdd gnd
* ------------------------------------------------
* Footed Dynamic NAND x1
MP1 w  ck vdd vdd p_18 W=250n L=270n M=1
MN1 w  a  n1  gnd N_18 W=250n L=900n M=3
MN2 n1 b  n2  gnd N_18 W=250n L=900n M=3
MN3 n2 ck gnd gnd N_18 W=250n L=900n M=3
* ------------------------------------------------
* Static inverter x8
XINV1 w x vdd gnd inv M=8
* ------------------------------------------------
.ends FDAND


* HW4 Fig3 2 Input Decoder
.subckt DECODER2 a e ck a_e a_eb ab_e ab_eb vdd gnd
XINV1 a ab vdd gnd	inv
XINV2 e eb vdd gnd	inv
* decoder
X1AND a  e  a_e   ck vdd gnd FDAND
X2AND a  eb a_eb  ck vdd gnd FDAND
X3AND ab e  ab_e  ck vdd gnd FDAND
X4AND ab eb ab_eb ck vdd gnd FDAND
.ends DECODER2


Vdd vdd gnd 1.8
Vck clk gnd PULSE(0v 1.8v 20ns 0.1ns 0.1ns 19.9ns 40ns)
Va	a 	gnd PULSE(0v 1.8v 5ns  0.1ns 0.1ns 39.9ns 80ns)		* input can be changed @ precharge cycle
Ve	e 	gnd	PULSE(0v 1.8v 5ns  0.1ns 0.1ns 79.9ns 160ns)	* input can be changed @ precharge cycle

Xdec2 a e clk a_e a_eb ab_e ab_eb vdd gnd DECODER2

Xload1 a_e   n1 vdd gnd	inv M=64
Xload2 a_eb  n2 vdd gnd	inv M=64
Xload3 ab_e  n3 vdd gnd	inv M=64
Xload4 ab_eb n4 vdd gnd	inv M=64

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
*----------------------------------------------------------------------
.option post
.tran 1ps 200ns
.MEAS TRAN Trise    TRIG V(a_e) val=0.18 TD=20n RISE=1   TARG V(a_e) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(a_e) val=1.62 TD=20n FALL=1   TARG V(a_e) val=0.18 FALL=1
.print tran v(a) v(e) v(clk) v(a_e) v(a_eb) v(ab_e) v(ab_eb)
.end

*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* trise=  9.2614E-10
* tfall=  1.3009E-09
*
* HW4_3_3_2.png
* HW4_3_3_2_mark.png
* HW4_3_3_2_FDAND.png
* HW4_3_3_2_DECODER2.png
```
![HW4_3_3_2_mark](https://github.com/user-attachments/assets/8aea0673-7d62-4a2a-a9d5-36b137dfd197)



### 2-4 3-stage Footed Domino NOR Decoder 4x4x4=64
```
* HW4_3_3_3.sp 
* 3 stage Footed Domino NOR Decoder 4x4x4=64
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------

* FIGURE 1.11 inverter
.subckt inv in out vdd gnd
MP1 out in vdd vdd p_18 W=250n L=270n M=2
MN1 out in gnd gnd N_18 W=250n L=900n M=1
.ends inv


* FIGURE 9.28(a) 3 Stage Footed Domino NOR
.subckt FDNOR a b x ck vdd gnd
* ------------------------------------------------
* Footed Dynamic NOR x1
MP1 w ck vdd vdd p_18 W=250n L=270n M=1
MN1 w a  n   gnd N_18 W=250n L=900n M=2
MN2 w b  n   gnd N_18 W=250n L=900n M=2
MN3 n ck gnd gnd N_18 W=250n L=900n M=2
* ------------------------------------------------
* Static inverter x4
XINV1 w w1 vdd gnd inv M=4
* ------------------------------------------------
* Static inverter x16
XINV2 x w vdd gnd inv M=16
* ------------------------------------------------
.ends FDNOR


* HW4 Fig3 2 Input Decoder
.subckt DECODER2 a e ck a_e a_eb ab_e ab_eb vdd gnd
XINV1 a ab vdd gnd	inv
XINV2 e eb vdd gnd	inv
* decoder
X1OR ab eb a_e   ck vdd gnd FDNOR
X2OR ab e  a_eb  ck vdd gnd FDNOR
X3OR a  eb ab_e  ck vdd gnd FDNOR
X4OR a  e  ab_eb ck vdd gnd FDNOR
.ends DECODER2


Vdd vdd gnd 1.8
Vck clk gnd PULSE(0v 1.8v 20ns 0.1ns 0.1ns 19.9ns 40ns)
Va	a 	gnd PULSE(0v 1.8v 5ns  0.1ns 0.1ns 39.9ns 80ns)		* input can be changed @ precharge cycle
Ve	e 	gnd	PULSE(0v 1.8v 5ns  0.1ns 0.1ns 79.9ns 160ns)	* input can be changed @ precharge cycle

Xdec2 a e clk a_e a_eb ab_e ab_eb vdd gnd DECODER2

Xload1 a_e   n1 vdd gnd	inv M=64
Xload2 a_eb  n2 vdd gnd	inv M=64
Xload3 ab_e  n3 vdd gnd	inv M=64
Xload4 ab_eb n4 vdd gnd	inv M=64

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
*----------------------------------------------------------------------
.option post
.tran 1ps 200ns
.MEAS TRAN Trise    TRIG V(a_e) val=0.18 TD=20n RISE=1   TARG V(a_e) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(a_e) val=1.62 TD=20n FALL=1   TARG V(a_e) val=0.18 FALL=1
.print tran v(a) v(e) v(clk) v(a_e) v(a_eb) v(ab_e) v(ab_eb)
.end
```
![HW4_3_3_3_staticINV_mark](https://github.com/user-attachments/assets/90a5f0a3-ff1b-4842-be26-544199b10cdb)


