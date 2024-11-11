* HW4_2_2.sp
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

MN1 o1 in gnd gnd N_18 W=250n L=900n M=1
MP1 o1 in ndd ndd p_18 W=250n L=270n M=2

MN2 o2 o1 gnd gnd N_18 W=250n L=900n M=4
MP2 o2 o1 ndd ndd p_18 W=250n L=270n M=8

* 16x invertor load 
MNL nd o2 gnd gnd N_18 W=250n L=900n M=16
MPL nd o2 ndd ndd p_18 W=250n L=270n M=32

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
* Performing Basic Cell Measurements, Page 648, HSPICE® User Guide: Simulation and Analysis
*----------------------------------------------------------------------
.tran 1ps 60ns

.MEAS TRAN Trise    TRIG V(o2) val=0.18 TD=10n RISE=1   TARG V(o2) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(o2) val=1.62 TD=10n FALL=1   TARG V(o2) val=0.18 FALL=1
.MEAS TRAN Tdelay   TRIG V(in) val=0.9  TD=10n RISE=1   TARG V(o2) val=0.9  RISE=1

.print tran v(in) v(o2)
.end


*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* trise=   4.8475E-10
* tfall=   5.5330E-10
* tdelay=  5.1425E-10
*
* HW4_2_2.png