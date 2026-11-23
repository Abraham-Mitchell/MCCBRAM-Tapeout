.SUBCKT INV A OUT VDD GND

* Width x Height = 1.18u x 1.82u
* NMOS
XND1 OUT A GND GND sky130_fd_pr__nfet_01v8 L=0.15 W=0.42

* PMOS
XPU1 OUT A VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=0.42

.ENDS INV
