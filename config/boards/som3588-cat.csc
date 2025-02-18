# Rockchip RK3588S octa core 4/8/16GB RAM SoC Type-C GBE USB3 WiFi/BT NVMe eMMC
BOARD_NAME="SOM3588Cat"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER="YAN"
BOOTCONFIG="som3588-cat_defconfig"
BOOT_SOC="rk3588"
KERNEL_TARGET="vendor,edge"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3588-som3588-cat.dtb"
BOOT_SCENARIO="spl-blobs"
BOOT_SUPPORT_SPI="yes"
BOOT_SPI_RKSPI_LOADER="yes"
IMAGE_PARTITION_TABLE="gpt"

function post_family_tweaks__som3588cat_naming_audios() {
	display_alert "$BOARD" "Renaming SOM3588Cat audios" "info"

	mkdir -p $SDCARD/etc/udev/rules.d/
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi0-sound", ENV{SOUND_DESCRIPTION}="HDMI0 Audio"' > $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmi1-sound", ENV{SOUND_DESCRIPTION}="HDMI1 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-hdmiin-sound", ENV{SOUND_DESCRIPTION}="HDMI-In Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-dp0-sound", ENV{SOUND_DESCRIPTION}="DP0 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	echo 'SUBSYSTEM=="sound", ENV{ID_PATH}=="platform-es8388-sound", ENV{SOUND_DESCRIPTION}="ES8388 Audio"' >> $SDCARD/etc/udev/rules.d/90-naming-audios.rules
	return 0
}

# Mainline u-boot
function post_family_config_branch_som3588cat_use_mainline_uboot() {
	display_alert "$BOARD" "mainline (next branch) u-boot overrides for $BOARD / $BRANCH" "info"

	declare -g BOOTCONFIG="som3588-cat_defconfig"
	declare -g BOOTDELAY=1                                       # Wait for UART interrupt to enter UMS/RockUSB mode etc
	declare -g BOOTSOURCE="https://github.com/u-boot/u-boot.git" # We ❤️ Mainline
	declare -g BOOTBRANCH="tag:v2025.04-rc2"
	declare -g BOOTPATCHDIR="v2025.04"
	declare -g BOOTDIR="u-boot-${BOARD}" # do not share u-boot directory
	declare -g UBOOT_TARGET_MAP="BL31=${RKBIN_DIR}/${BL31_BLOB} ROCKCHIP_TPL=${RKBIN_DIR}/${DDR_BLOB};;u-boot-rockchip.bin u-boot-rockchip-spi.bin"
	unset uboot_custom_postprocess write_uboot_platform write_uboot_platform_mtd # disable stuff from rockchip64_common; we're using binman here which does all the work already

	# Just use the binman-provided u-boot-rockchip.bin, which is ready-to-go
	function write_uboot_platform() {
		dd "if=$1/u-boot-rockchip.bin" "of=$2" bs=32k seek=1 conv=notrunc status=none
	}

	function write_uboot_platform_mtd() {
		flashcp -v -p "$1/u-boot-rockchip-spi.bin" /dev/mtd0
	}
}
