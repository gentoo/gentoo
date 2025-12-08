# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info udev

COMMIT="39d5728d41b70840342ddc116a59125b337fbde2"
DESCRIPTION="Daemon that uses hid-nintendo evdev devices to implement joycon pairing"
HOMEPAGE="https://github.com/DanielOgorchock/joycond"
SRC_URI="https://github.com/DanielOgorchock/joycond/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

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

PATCHES=(
	"${FILESDIR}"/${PN}-dynamic-paths.patch
	"${FILESDIR}"/${PN}-systemd-paranoia.patch
	"${FILESDIR}"/${PN}-werror.patch
	"${FILESDIR}"/${PN}-gcc16.patch
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
