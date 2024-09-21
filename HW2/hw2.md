# Homework 2
## Introduction to Library: CIC 0.18um 1.8V/3.3V 1P6M virtual Mixed Mode/RFCMOS Process
### Availabe corners: (pmos-nmos)
TT (typical typical)
FF (fast fast)
SS (slow slow)
FS
SF

### Available models
#### MOS
N_18 (1.8v nmos)
N_BPW_18 (1.8v p-well nmos)
P_18 (1.8v pmos)
N_33 (3.3v nmos)
N_BPW_33
P_33
N_LV_18 (low threshold voltage 1.8v nmos)
P_LV_18
N_LV_33
P_LV_33
N_ZERO_18 (zero Vt 1.8v nmos)
N_ZERO_33
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


## Homework 2-1-1
### Simulation Result
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
