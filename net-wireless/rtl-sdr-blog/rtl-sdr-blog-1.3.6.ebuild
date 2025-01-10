# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake
inherit udev

DESCRIPTION="Modified Osmocom drivers with enhancements for RTL-SDR Blog V3 and V4 units"
HOMEPAGE="
	https://github.com/rtlsdrblog/rtl-sdr-blog
	https://www.rtl-sdr.com/"

SRC_URI="https://github.com/jharvell/rtl-sdr-blog/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="+udev"

BDEPEND=">=dev-build/cmake-3.7.2"
RDEPEND="
	!net-wireless/rtl-sdr
	dev-libs/libusb
"

PATCHES=(
	"${FILESDIR}/${PN}-version_info_cache_vars.patch"
	"${FILESDIR}/${PN}-udev_rules_to_lib.patch"
)

src_configure() {
	local mycmakeargs=(
		-DVERSION_INFO_MAJOR_VERSION=1
		-DVERSION_INFO_MINOR_VERSION=3
		-DVERSION_INFO_PATCH_VERSION=6
		-DINSTALL_UDEV_RULES=$(usex udev)
	)
	cmake_src_configure
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
