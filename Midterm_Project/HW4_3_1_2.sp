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

*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* HW4_3_1_2.png