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
