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

*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* HW4_3_1.png