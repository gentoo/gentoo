# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

MY_PN="HeadsetControl"

DESCRIPTION="A tool to control certain aspects of USB-connected headsets on Linux"
HOMEPAGE="https://github.com/Sapd/HeadsetControl"
SRC_URI="https://github.com/Sapd/HeadsetControl/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="static-libs udev"

DEPEND="
	dev-libs/hidapi
	udev? ( virtual/udev )
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s#lib/udev/rules.d/#$(get_udevdir)/rules.d#" CMakeLists.txt || die "Failed correcting udev rules directory"
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHEADSETCONTROL_VERSION="${PV}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	use static-libs || rm "${ED}"/usr/lib/libheadsetcontrol.a || die
}

pkg_postinst() {
	use udev && udev_reload
}

pkg_postrm() {
	use udev && udev_reload
}
