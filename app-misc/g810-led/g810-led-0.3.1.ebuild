# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd udev eutils

DESCRIPTION="Led controller for Logitech G- Keyboards"
HOMEPAGE="https://github.com/MatMoul/g810-led"
SRC_URI="https://github.com/MatMoul/g810-led/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+hidapi"

RDEPEND="
	hidapi? ( dev-libs/hidapi:= )
	!hidapi? ( virtual/libusb:= )
"

DEPEND="${RDEPEND}"

DOCS=("README.md" "sample_profiles" "sample_effects")

src_compile() {
	emake LIB="$(usex hidapi hidapi libusb)"
}

src_install() {
	dolib.so "lib/libg810-led.so.${PV}"
	dosym "libg810-led.so.${PV}" "/usr/$(get_libdir)/libg810-led.so"

	dobin bin/g810-led
	local boards=(213 410 413 512 513 610 910 pro)
	local x
	for x in "${boards[@]}"; do
		dosym g810-led "/usr/bin/g${x}-led"
	done

	systemd_dounit systemd/g810-led.service
	systemd_dounit systemd/g810-led-reboot.service

	udev_newrules udev/g810-led.rules 60-g810-led.rules

	einstalldocs
}
