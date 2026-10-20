echo "===== ARC KUIPER BOOT ====="
echo "Boot device: ${devtype} ${devnum}:${distro_bootpart}"

echo "Loading Linux Image..."
fatload ${devtype} ${devnum}:${distro_bootpart} ${kernel_addr_r} Image || reset

echo "Loading ARC system.dtb..."
fatload ${devtype} ${devnum}:${distro_bootpart} ${fdt_addr_r} system.dtb || reset

echo "Finding root filesystem partition..."
part uuid ${devtype} ${devnum}:2 rootuuid || reset

echo "Root PARTUUID: ${rootuuid}"

setenv bootargs "console=ttyPS0,115200 root=PARTUUID=${rootuuid} rw earlycon rootfstype=ext4 rootwait clk_ignore_unused cpuidle.off=1"

echo "Starting Linux..."
booti ${kernel_addr_r} - ${fdt_addr_r}
