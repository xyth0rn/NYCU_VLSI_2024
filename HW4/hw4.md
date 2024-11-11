# Homework 4
NYCU EE 112511210 黃仲璿

## 0 PMOS NMOS W/L Ratio
For detailed method, see hw2.
```
MN1 d g gnd gnd N_18 W=250n L=900n M=1
MP1 d g ndd ndd p_18 W=250n L=270n M=2
```

## 1 Unit Inverter (with $V_d=1.8V, I_d=10\mu A, V_i=V_o=0.9V$)
### 1.1 Design
```
* HW4_0_op.sp
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
*----------------------------------------------------------------------
Vg  g   gnd 0.9
Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=250n L=900n M=1
MP1 d g ndd ndd p_18 W=250n L=270n M=2

*----------------------------------------------------------------------
* Stimulus
*----------------------------------------------------------------------
.option captab=1 	* nodal capacitance table
.op
.end
```
## 1.2 Capacitance
```
*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* HW4_1_0_op.lis
*
* nodal capacitance table 
* node    =    cap
* d       =   1.2573f
* g       =   2.6345f
*
* element  mn1       mp1     
* model    n_18.1    p_18.1  
* id       10.0246u  -10.1859u
```
_Remark: There are 3 ways to measure capacitance_  
- Method 1:
```
.option captab=1
.op
```

- Method 2:
```
.dc vg 0 1.8 0.01
.meas dc cg find cap(g) at=0.9
```

- Method 3:
```
.dc vg 0 1.8 0.01
.print Cmn1=par("lx18(mn1)")
.print Cmp1=par("lx18(mp1)")
```
and then use avanwave expression builder (or custom waveview) to get CV characteristic curve (CT = C_Total)
![image](https://github.com/user-attachments/assets/7c9b6765-f02a-4830-87c5-ba8f1ccec04b)
> Reference: <br>
> [1] https://www.ptt.cc/bbs/comm_and_RF/M.1284928485.A.86F.html <br>
> [2] https://bbs.eetop.cn/thread-408732-1-1.html

## 2 Inverter Buffer Chain
Calculate by hand and then run HSpice transient simulation.
![image](https://github.com/user-attachments/assets/bb0c62ea-4510-403e-afed-6e249478a067)

### 2.1 Single Stage Buffer Chain
```
* HW4_2_1.sp
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

* 16x invertor load 
MNL nd o1 gnd gnd N_18 W=250n L=900n M=16
MPL nd o1 ndd ndd p_18 W=250n L=270n M=32

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
* Performing Basic Cell Measurements, Page 648, HSPICE® User Guide: Simulation and Analysis
*----------------------------------------------------------------------
.tran 1ps 60ns

.MEAS TRAN Trise    TRIG V(o1) val=0.18 TD=10n RISE=1   TARG V(o1) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(o1) val=1.62 TD=10n FALL=1   TARG V(o1) val=0.18 FALL=1
.MEAS TRAN Tdelay   TRIG V(in) val=0.9  TD=10n RISE=1   TARG V(o1) val=0.9  FALL=1

.print tran v(in) v(o1)
.end


*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* trise=  1.2633E-09
* tfall=  1.7268E-09
* tdelay=  7.9930E-10
```
![image](https://github.com/user-attachments/assets/a5593b7c-e412-4044-8cd1-bbe4230264fc)

### 2.2 Two Stage Buffer Chain
```
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
```
![image](https://github.com/user-attachments/assets/951facf9-b03a-4e3f-9356-d8ecfcd4300d)


### 2.3 Three Stage Buffer Chain
```
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
```
![image](https://github.com/user-attachments/assets/2fbf2dfd-a458-45b2-ad02-6340b072a5c2)

### 2.4 Four Stage Buffer Chain
```
* HW4_2_4.sp
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

MN2 o2 o1 gnd gnd N_18 W=250n L=900n M=2
MP2 o2 o1 ndd ndd p_18 W=250n L=270n M=4

MN3 o3 o2 gnd gnd N_18 W=250n L=900n M=4
MP3 o3 o2 ndd ndd p_18 W=250n L=270n M=8

MN4 o4 o3 gnd gnd N_18 W=250n L=900n M=8
MP4 o4 o3 ndd ndd p_18 W=250n L=270n M=16

* 16x invertor load 
MNL nd o4 gnd gnd N_18 W=250n L=900n M=16
MPL nd o4 ndd ndd p_18 W=250n L=270n M=32

*----------------------------------------------------------------------
* Stimulus 25Mhz/40ns
* Performing Basic Cell Measurements, Page 648, HSPICE® User Guide: Simulation and Analysis
*----------------------------------------------------------------------
.tran 1ps 60ns

.MEAS TRAN Trise    TRIG V(o4) val=0.18 TD=10n RISE=1   TARG V(o4) val=1.62 RISE=1
.MEAS TRAN Tfall    TRIG V(o4) val=1.62 TD=10n FALL=1   TARG V(o4) val=0.18 FALL=1
.MEAS TRAN Tdelay   TRIG V(in) val=0.9  TD=10n RISE=1   TARG V(o4) val=0.9  RISE=1

.print tran v(in) v(o4)
.end


*----------------------------------------------------------------------
* Result
*----------------------------------------------------------------------
* trise=  2.6542E-10
* tfall=  3.2837E-10
* tdelay=  6.6552E-10
```
![image](https://github.com/user-attachments/assets/7a06e49c-6f1b-4525-8e19-e3ea7dc29ec6)

