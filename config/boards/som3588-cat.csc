# Rockchip RK3588S octa core 4/8/16GB RAM SoC Type-C GBE USB3 WiFi/BT NVMe eMMC
BOARD_NAME="SOM3588Cat"
BOARDFAMILY="rockchip-rk3588"
BOARD_MAINTAINER="YAN"
BOOTCONFIG="rk3588-som3588-cat_defconfig"
BOOT_SOC="rk3588"
KERNEL_TARGET="vendor,edge,legacy"
KERNEL_TEST_TARGET="vendor"
FULL_DESKTOP="yes"
BOOT_LOGO="desktop"
BOOT_FDT_FILE="rockchip/rk3588-som3588-cat.dtb"
BOOT_SCENARIO="spl-blobs"
BOOT_SUPPORT_SPI="yes"
BOOT_SPI_RKSPI_LOADER="yes"
IMAGE_PARTITION_TABLE="gpt"
enable_extension "bcmdhd"
BCMDHD_TYPE="sdio"

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
function post_family_config_branch_legacy__kernel_som3588cat() {
	if [[ $BRANCH == "legacy" ]]; then
		BOOTSCRIPT='boot-rk35xx.cmd:boot.cmd'
		BOOTDIR='u-boot-rockchip64'
		declare -g KERNEL_MAJOR_MINOR="6.1"    # Major and minor versions of this kernel.
		declare -g -i KERNEL_GIT_CACHE_TTL=120 # 2 minutes; this is a high-traffic repo
		KERNELSOURCE='https://github.com/CNflysky/linux-rockchip.git'
		KERNELBRANCH='branch:rk-6.1-rkr4.1'
		KERNELPATCHDIR='rk35xx-vendor-6.1'
		LINUXFAMILY=rk35xx
	fi
}
#	declare -g KERNELSOURCE='https://github.com/CNflysky/linux-rockchip.git'
#	declare -g KERNELBRANCH='branch:rk-6.1-rkr4.1'
#}
