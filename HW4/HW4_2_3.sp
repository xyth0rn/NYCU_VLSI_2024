* HW4_2_3.sp
*----------------------------------------------------------------------
* Assumption
* lib = cic018.l/tt/N_18 & P_18
* 1. temp 27
* 2. L=0.18um
*----------------------------------------------------------------------

.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
* Trapezoidal Pulse Source, Page 189, HSPICE® User Guide: Simulation and Analysis
* Vxxx n+ n- PU[LSE] [(]v1 v2 [td [tr [tf [pw [per]]]]] [)]
*----------------------------------------------------------------------
Vdd ndd gnd 1.8
Vin in  gnd PULSE(0v 1.8v 10ns 0.01ns 0.01ns 19.99ns 40ns)

* W/L from HW2
MN1 o1 in gnd gnd N_18 W=250n L=900n M=1
MP1 o1 in ndd ndd p_18 W=250n L=270n M=2

MN2 o2 o1 gnd gnd N_18 W=630n L=900n M=1 * x2.52
MP2 o2 o1 ndd ndd p_18 W=630n L=270n M=2 * x2.52

MN3 o3 o2 gnd gnd N_18 W=1590n L=900n M=1 * x2.52
MP3 o3 o2 ndd ndd p_18 W=1590n L=270n M=2 * x2.52

* 16x invertor load 
MNL nd o2 gnd gnd N_18 W=250n L=900n M=16
MPL nd o2 ndd ndd p_18 W=250n L=270n M=16

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
* Performing Basic Cell Measurements, Page 648, HSPICE® User Guide: Simulation and Analysis
*----------------------------------------------------------------------
.tran 1ps 60ns

.MEAS TRAN Trise    TRIG V(o3) val=0.18 TD=10n RISE=1   TARG V(o3) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(o3) val=1.62 TD=10n FALL=1   TARG V(o3) val=0.18 FALL=1
.MEAS TRAN Tdelay   TRIG V(in) val=0.9  TD=10n RISE=1   TARG V(o3) val=0.9  FALL=1

.print tran v(in) v(o3)
.end


*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* trise=  1.8406E-10
* tfall=  1.8491E-10
* tdelay=  6.1823E-10
*
* HW4_2_3.png