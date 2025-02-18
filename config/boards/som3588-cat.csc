# Rockchip RK3588S octa core 4/8/16GB RAM SoC Type-C GBE USB3 WiFi/BT NVMe eMMC
BOARD_NAME="SOM3588Cat"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER=""
BOOTCONFIG="som3588-cat_defconfig"
BOOT_SOC="rk3588"
KERNEL_TARGET="vendor"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/som3588-cat.dtb"
BOOT_SCENARIO="spl-blobs"
#BOOT_SUPPORT_SPI="yes"
#BOOT_SPI_RKSPI_LOADER="yes"
IMAGE_PARTITION_TABLE="gpt"

function post_family_tweaks__som3588-cat_naming_audios() {
	display_alert "$BOARD" "Renaming som3588-cat audios" "info"

	mkdir -p $SDCARD/etc/udev/rules.d/
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi0-sound", ENV{SOUND_DESCRIPTION}="HDMI0 Audio"' > $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi1-sound", ENV{SOUND_DESCRIPTION}="HDMI1 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmiin-sound", ENV{SOUND_DESCRIPTION}="HDMI-In Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-dp0-sound", ENV{SOUND_DESCRIPTION}="DP0 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-es8388-sound", ENV{SOUND_DESCRIPTION}="ES8388 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	return 0
}
function post_family_config_branch_vendor__som3588-cat_uboot_add_sata_target() {
	display_alert "$BOARD" "Configuring ($BOARD) standard and sata uboot target map" "info"
	# Note: whitespace/newlines are significant; BOOT_SUPPORT_SPI & BOOT_SPI_RKSPI_LOADER influence the postprocess step that runs for _every_ target and produces rkspi_loader.img
	UBOOT_TARGET_MAP="BL31=$RKBIN_DIR/$BL31_BLOB $BOOTCONFIG spl/u-boot-spl.bin u-boot.dtb u-boot.itb;;idbloader.img u-boot.itb rkspi_loader.img
	BL31=$RKBIN_DIR/$BL31_BLOB $BOOTCONFIG_SATA spl/u-boot-spl.bin u-boot.dtb u-boot.itb;; rkspi_loader_sata.img"
}
