# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev systemd

DESCRIPTION="System tweaks for the Raspberry Pi from Raspberry Pi OS"

HOMEPAGE="https://github.com/RPi-Distro/raspberrypi-sys-mods"

SRC_URI="https://archive.raspberrypi.org/debian/pool/main/r/raspberrypi-sys-mods/${PN}_${PV}.tar.xz"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~arm ~arm64"

IUSE=""

RDEPEND="
	acct-group/input
	acct-group/i2c
	acct-group/spi
	acct-group/gpio
	acct-group/video
	"

DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}"

DOCS=( debian/changelog )

src_install() {
	default
	insinto /etc/modprobe.d/
	#See https://github.com/RPi-Distro/raspberrypi-sys-mods/issues/37
	doins etc.armhf/modprobe.d/blacklist-8192cu.conf
	#See https://github.com/raspberrypi/linux/issues/2164#issuecomment-322152871
	doins etc.armhf/modprobe.d/blacklist-rtl8xxxu.conf

	udev_dorules etc.armhf/udev/rules.d/99-com.rules
	udev_dorules lib/udev/rules.d/{15-i2c-modprobe.rules,70-microbit.rules}
	exeinto /usr/lib/raspberrypi-sys-mods
	doexe usr/lib/raspberrypi-sys-mods/i2cprobe

	systemd_newunit debian/raspberrypi-sys-mods.rpi-display-backlight.service rpi-display-backlight.service
	for target in reboot.target halt.target poweroff.target; do
		systemd_enable_service "${target}" rpi-display-backlight.service
	done
}
