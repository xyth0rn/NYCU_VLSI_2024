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
Source Code
```
* HW2_1_1.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vd  d   gnd 0.9
Vg  g   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.18u
MP1 d g ndd ndd P_18 W=0.25u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*----------------------------------------------------------------------
.op
.end
```

Simulation Result
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
Source Code
```
* HW2_1_1_b.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
*nmos
Vg  g   gnd 0.9
Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=LN
*MP1 d g ndd ndd P_18 W=0.25u L=LP

*MN1 d g gnd gnd N_18 W=0.25u L=0.18u
*MP1 d g ndd ndd P_18 W=0.25u L=0.18u


*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 

.dc Vdd 0 1.8 1.8 sweep LN 0.81u 1.0u 0.01u
*.dc Vg 0 0.9 0.9 sweep LP 0.18u 0.2u 0.01u

.probe i1(MN1)
*.probe i1(MP1)
.meas DC IMeas find i1(MN1) when v(g)=0.9
*.meas DC IMeas find i1(MP1) when v(g)=0.9
.end
```

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
Source Code: same as above except tune pmos

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
<mark>For nmos we choose Wn = 0.25u, Ln = 0.9u. <br></mark>
<mark>For pmos we choose Wp = 0.25u, Lp = 0.18u.</mark>

-----

## HW 2-1-2

### NMOS
```
* HW2_1_2.sp
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
* HW2_1_2.sp
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

MP1 d g ndd ndd P_18 W=0.25u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 
.dc Vd 0 1.8 0.01 sweep Vg 0.7 1.0 0.1
.probe i1(MP1)
```
![image](https://github.com/user-attachments/assets/a4cb456c-6f6b-4848-887c-8df78f03649f)


-----

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

-----

## HW 2-2-2
### V1 = 0.7V
#### Initial Guess
Source Code: same as HW 2-1-1 except set all `Vg` to 0.7

Simulation Result:
```
element  0:mn1      0:mp1     
 model    0:n_18.1   0:p_18.1  
 region     Saturati   Saturati
  id        21.5095u  -18.9496u
```
We see that `id` of both nmos and pmos are very close to target (20u).

- pmos: to increase current, fine-tune `Wp` up one step (0.01u) every time.
- nmos: to decrease current, fine-tune `Ln` up one step (0.01u) every time.

#### NMOS
Simulation Result:
```
...
 * hw2_2_2_07.sp
   *** parameter ln =  180.0000n       ***
   imeas=  2.1509E-05
 ******  
 * hw2_2_2_07.sp
   *** parameter ln =  190.0000n       ***
   imeas=  1.9373E-05
...
```
when Ln parameter `ln = 0.19u`, id is closest to 20uA (1.9373E-05 A)

#### PMOS
Simulation Result:
```
...
 * hw2_2_2_07.sp
   *** parameter wp =  260.0000n       ***    
    1.80000        -19.9722u
******  
 * hw2_2_2_07.sp
   *** parameter wp =  270.0000n       ***    
    1.80000        -20.9425u
...
```
when Wp parameter `wp = 0.26u`, id is closest to 20uA (-19.9722u A)

#### Result
<mark>nmos W = 0.25u L = 0.19u</br></mark>
<mark>pmos W = 0.26u L = 0.18u</mark>
```
* HW2_2_2_07_dc.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vg  g   gnd
*Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.19u
MP1 d g ndd ndd P_18 W=0.26u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 

.dc Vg 0 1.8 0.01
.op
.end
```
![image](https://github.com/user-attachments/assets/ec227e9e-8c4e-45d8-996a-e04b7c1a9340)

### Vg = 0.8
#### Initial Guess
Source Code: same as HW 2-1-1 except set all `Vg` to 0.8

Simulation Result:
```                    
 element  0:mn1      0:mp1     
 model    0:n_18.1   0:p_18.1  
 region     Saturati   Saturati
  id        33.1641u  -14.5751u
```
We see that `id` of both nmos and pmos are very close to target (20u).

- pmos: to increase current, fine-tune `Wp` up one step (0.01u) every time.
- nmos: to decrease current, multiply `Ln` by 1.2 (0.22u), then fine-tune `Ln` up one step (0.01u) every time.

#### NMOS
```
 * hw2_2_2_08.sp
   *** parameter ln =  260.0000n       ***
   imeas=  2.0368E-05
 ******  
 * hw2_2_2_08.sp
   *** parameter ln =  270.0000n       ***
   imeas=  1.9564E-05
```
when Ln parameter `ln = 0.29u`, id is closest to 20uA (2.0368E-05 A)

#### PMOS
```
 * hw2_2_2_08.sp
   *** parameter wp =  330.0000n       ***    
    1.80000        -19.9570u       
 ******  
 * hw2_2_2_08.sp
   *** parameter wp =  340.0000n       ***
    1.80000        -20.5651u   
```
when Wp parameter `wp = 0.33u`, id is closest to 20uA (-19.9570u A)

#### Result
<mark>nmos W = 0.25u L = 0.29u</br></mark>
<mark>pmos W = 0.33u L = 0.18u</mark>
```
* HW2_2_2_08_dc.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vg  g   gnd
*Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.29u
MP1 d g ndd ndd P_18 W=0.33u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 

.dc Vg 0 1.8 0.01
.op
.end
```
![image](https://github.com/user-attachments/assets/02d08407-2c44-49cd-b07d-afecb6069ac6)

### Vg = 0.9
Same as Problem 2-2-1
<mark>nmos W = 0.25u L = 0.90u M = 2</br></mark>
<mark>pmos W = 0.25u L = 0.18u M = 2</mark>
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

MN1 d g gnd gnd N_18 W=0.25u L=0.90u M=2
MP1 d g ndd ndd P_18 W=0.25u L=0.18u M=2

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 
.dc Vg 0 1.8 0.01
.probe i1(MN1)
.end
```
![image](https://github.com/user-attachments/assets/6a19897e-6300-43a6-b078-0f1a5e16fbd6)

### Vg = 1.0
#### Initial Guess
Source Code: same as HW 2-1-1 except set all `Vg` to 1.0

Simulation Result:
```                    
 element  0:mn1      0:mp1     
 model    0:n_18.1   0:p_18.1  
 region     Saturati   Saturati
  id        60.0367u   -6.8436u
```
We see that `id` of nmos is roughly 3 times larger than the target (20uA), and pmos is roughly third of such.

- pmos: to increase current, multiply `Wp` by 2 (0.50u), fine-tune `Wp` up one step (0.01u) every time.
- nmos: to decrease current, multiply `Ln` by 3 (0.75u), then fine-tune `Ln` up one step (0.01u) every time.

#### NMOS
```
 * hw2_2_2_10.sp
 *** parameter ln =  570.0000n       ***    
    1.80000         20.2303u       
 ******  
 * hw2_2_2_10.sp
   *** parameter ln =  580.0000n       ***
    1.80000         19.9363u
```
when Ln parameter `ln = 0.58u`, id is closest to 20uA (19.9363u A)

#### PMOS
```
 * hw2_2_2_10.sp
   *** parameter wp =  790.0000n       ***     
    1.80000        -19.8113u       
 ******  
 * hw2_2_2_10.sp
   *** parameter wp =  800.0000n       ***      
    1.80000        -20.0495u 
```
when Wp parameter `wp = 0.80u`, id is closest to 20uA (-20.0495u A)

#### Result
<mark>nmos W = 0.25u L = 0.58u</br></mark>
<mark>pmos W = 0.80u L = 0.18u</mark>
```
* HW2_2_2_10_dc.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vg  g   gnd
*Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.58u
MP1 d g ndd ndd P_18 W=0.80u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 

.dc Vg 0 1.8 0.01
.op
.end
```
![image](https://github.com/user-attachments/assets/aeb3b077-62c4-48ac-b9df-d7facd33142d)

### Vg = 1.1
#### Initial Guess
Source Code: same as HW 2-1-1 except set all `Vg` to 1.1

Simulation Result:
```                    
 element  0:mn1      0:mp1     
 model    0:n_18.1   0:p_18.1  
 region     Saturati   Saturati
  id        73.6641u   -3.8705u
```
We see that `id` of nmos is roughly 3.5 times larger than the target (20uA), and pmos is roughly sixth of such.

- pmos: to increase current, multiply `Wp` by 5 (1.25), fine-tune `Wp` up one step (0.01u) every time.
- nmos: to decrease current, multiply `Ln` by 6 (0.84u), then fine-tune `Ln` up one step (0.01u) every time.

#### NMOS
```
 * hw2_2_2_11.sp
   *** parameter ln =  790.0000n       ***    
    1.80000         20.0234u       
 ******  
 * hw2_2_2_11.sp
   *** parameter ln =  800.0000n       ***     
    1.80000         19.8142u 
```
when Ln parameter `ln = 0.79u`, id is closest to 20uA (20.0234u A)

#### PMOS
```
 * hw2_2_2_11.sp
   *** parameter wp =    1.6100u       ***
    1.80000        -19.9563u       
 ******  
 * hw2_2_2_11.sp
   *** parameter wp =    1.6200u       ***    
    1.80000        -20.0835u  
```
when Wp parameter `wp = 1.61u`, id is closest to 20uA (-19.9563u A)

#### Result
<mark>nmos W = 0.25u L = 0.79u</br></mark>
<mark>pmos W = 1.61u L = 0.18u</mark>
```
* HW2_2_2_11_dc.sp
*----------------------------------------------------------------------
.lib 'cic018.l'  tt
.temp 27
.option post

*----------------------------------------------------------------------
* Simulation netlist
*----------------------------------------------------------------------
Vg  g   gnd
*Vd  d   gnd 0.9
Vdd ndd gnd 1.8

MN1 d g gnd gnd N_18 W=0.25u L=0.79u
MP1 d g ndd ndd P_18 W=1.61u L=0.18u

*----------------------------------------------------------------------
* Stimulus
*---------------------------------------------------------------------- 

.dc Vg 0 1.8 0.01
.op
.end
```
![image](https://github.com/user-attachments/assets/42a700e0-582b-49c4-8ab9-3659e3fe1a94)
