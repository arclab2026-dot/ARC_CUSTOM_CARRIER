# ARC Custom Carrier Firmware

Firmware, FPGA, boot-chain, device-tree, and embedded Linux bring-up workspace for the ARC custom UltraZed-EV carrier.

Development currently includes:
- Vivado 2022.2 hardware platform
- Custom AXI register interface
- Zynq UltraScale+ MPSoC boot firmware
- U-Boot / Trusted Firmware-A
- Kuiper Linux integration
- Device-tree generation
- JTAG/UART hardware bring-up preparation

Large full-disk Kuiper `.img` artifacts are intentionally excluded from Git.
Their reproducibility hashes are retained under `evidence/`.
