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
