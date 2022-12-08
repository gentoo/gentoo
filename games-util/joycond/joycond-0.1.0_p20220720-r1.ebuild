# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info udev

COMMIT="5b590ecc9bca181d8bc21377e752126bc9180319"
DESCRIPTION="Daemon that uses hid-nintendo evdev devices to implement joycon pairing"
HOMEPAGE="https://github.com/DanielOgorchock/joycond"
SRC_URI="https://github.com/DanielOgorchock/joycond/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libevdev
	virtual/udev
"

RDEPEND="
	${DEPEND}
"

CONFIG_CHECK="
	~HID
	~HID_NINTENDO
	~HIDRAW
"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-systemd-paths.patch
	"${FILESDIR}"/${PN}-systemd-paranoia.patch
)

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	doman doc/${PN}.1
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
