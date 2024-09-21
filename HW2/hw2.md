# Homework 2
## Introduction to Library: CIC 0.18um 1.8V/3.3V 1P6M virtual Mixed Mode/RFCMOS Process
### Availabe corners: (pmos-nmos)
- TT (typical typical)
- FF (fast fast)
- SS (slow slow)
- FS
- SF

### Available Models
#### MOS
- N_18 (1.8v nmos)
- N_BPW_18 (1.8v p-well nmos)
- P_18 (1.8v pmos)
- N_33 (3.3v nmos)
- N_BPW_33
- P_33
- N_LV_18 (low threshold voltage 1.8v nmos)
- P_LV_18
- N_LV_33
- P_LV_33
- N_ZERO_18 (zero Vt 1.8v nmos)
- N_ZERO_33

#### BJT
#### Diode
#### Capacitor

### Design Rule
```
****Layout-Dependent Parasitics Model Parameters****
+   LMIN = 1.8000E-07    LMAX = 5.0000E-05
+   WMIN = 2.5000E-07    WMAX = 1.0000E-04
```

### Library Summary
For homework simulation, use:
- `TT` type
- `N_18` and `P_18` for 1.8V nmos and pmos
- `LMIN = 0.18u` and `WMIN = 2.5u`
- assume minimal channel length/width delta = 0.01u (????)
- assume temperature = 27 C

### Spice Tutorial
#### MOS
`M<name> <drain> <gate> <source> <body> <model> W=<width> L=<length>`


## HW 2-1-1
### Initial Guess
```
...                       
 element  0:mn1      0:mp1     
 model    0:n_18.1   0:p_18.1  
 region     Saturati   Saturati
  id        45.7379u  -10.5697u
...
```
We see that `id` of nmos is 4.5 times larger than target (10u), and `id` of pmos is very close to target (10u).
Note: ![image](https://github.com/user-attachments/assets/2f2d32a4-f20d-470f-8f64-441c11031715)

pmos: fine-tune `Lp` up one step (0.01u) every time.
nmos: change `Ln` to 4.5 times the original (0.81u), then perform fine-tuning.

### NMOS Tuning
Simulation Result:
```
...
 ******  
 * hw2_1_1_b.sp
   *** parameter ln =  900.0000n       ***
   imeas=  1.0025E-05
 ******

 * hw2_1_1_b.sp
   *** parameter ln =  910.0000n       ***
   imeas=  9.9322E-06
 ******
...
```
when Ln parameter `ln = 0.9u`, id is closest to 10uA (1.0025E-05 A).

### PMOS Tuning
Simulation Result:
```
...
******  
 * hw2_1_1_b.sp
   *** parameter lp =  180.0000n       ***
   imeas= -1.0570E-05
 ******

 * hw2_1_1_b.sp
  *** parameter lp =  190.0000n       ***
   imeas= -9.2225E-06
 ******
...
```
when Lp parameter `lp = 0.18u`, id is closest to 10uA (-1.0570E-05 A)

### Answer
For nmos we choose Wn = 0.25u, Ln = 0.9u.
For pmos we choose Wp = 0.25u, Lp = 0.18u. 

## HW 2-1-2

### NMOS
```
Vg  g   gnd 0.9
Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.9u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 
.dc Vd 0 1.8 0.01 sweep Vg 0.7 1.0 0.1
.probe i1(MN1)
```
![image](https://github.com/user-attachments/assets/b2d96cea-ad2f-4a3e-8fa8-6873ab2d3a43)

### PMOS
```
Vg  g   gnd 0.9
Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MP1 d g ndd ndd P_18 W=0.25u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 
.dc Vd 0 1.8 0.01 sweep Vg 0.7 1.0 0.1
.probe i1(MP1)
```
![image](https://github.com/user-attachments/assets/a4cb456c-6f6b-4848-887c-8df78f03649f)

## HW 2-2-1
Parallel connecting M nmoses is the equivalent of multiplying Ln by M, thus multiplying Io. The same idea applies to pmos. Therefore, to have Io = 10uA, 20uA, 30uA, we use:
```
*Io = 10u
MN1 d g gnd gnd N_18 W=0.25u L= 0.9u M=1
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=1

*Io = 20u
MN1 d g gnd gnd N_18 W=0.25u L= 0.9u M=2
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=2

*Io = 30u
MN1 d g gnd gnd N_18 W=0.25u L= 0.9u M=3
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=3
```

### Io = 10uA (M = 1)
```
* HW2_2_1.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vg  g   gnd
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.90u M=1
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=1

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 
.dc Vg 0 1.8 0.01
.probe i1(MN1)
.end
```
![image](https://github.com/user-attachments/assets/ba1661d1-1f25-431d-832c-57843e751b75)


### Io = 20uA (M = 2)
Code same as above, except
```
MN1 d g gnd gnd N_18 W=0.25u L=0.90u M=2
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=2
```
![image](https://github.com/user-attachments/assets/6a19897e-6300-43a6-b078-0f1a5e16fbd6)


### Io = 30uA (M = 3)
Code same as above, except
```
MN1 d g gnd gnd N_18 W=0.25u L=0.90u M=3
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=3
```
![image](https://github.com/user-attachments/assets/e236e886-4136-4670-a61f-d27cdf972a8b)


### Discussion
output current changes but Vo-Vi curve remains the same, why?

## HW 2-2-2
