.SUBCKT NAND2 A B OUT VDD GND

* NMOS (series)
XND1 OUT B N1 GND sky130_fd_pr__nfet_01v8 L=0.15 W=0.42
XND2 N1 A GND GND sky130_fd_pr__nfet_01v8 L=0.15 W=0.42

* PMOS (parallel)
XPU1 OUT A VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=0.42
XPU2 OUT B VDD VDD sky130_fd_pr__pfet_01v8 L=0.15 W=0.42

.ENDS NAND2"
