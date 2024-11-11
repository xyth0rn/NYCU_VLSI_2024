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