# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info

COMMIT="f9a66914622514c13997c2bf7ec20fa98e9dfc1d"
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

src_install() {
	cmake_src_install
	rm -r "${ED}"/etc/modules-load.d/ || die
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	doman doc/${PN}.1
}
