# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev linux-info xdg-utils

DESCRIPTION="GUI application for configuring and programming cheap DMR radios"
HOMEPAGE="https://dm3mat.darc.de/qdmr/"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hmatuschek/qdmr.git"
else
	MY_PV="${PV/_/-}"
	SRC_URI="https://github.com/hmatuschek/qdmr/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="amd64 x86"
fi
LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/yaml-cpp:=
	dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtpositioning:6
	dev-qt/qtserialport:6
	dev-qt/qttools[designer,linguist]
	virtual/libusb:1
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qtbase:6[test] )
"
BDEPEND="
	gnome-base/librsvg
"

pkg_setup() {
	CONFIG_CHECK="~USB_ACM"
	WARNING_USB_ACM="You need to enable CONFIG_USB_ACM in your kernel to talk to some radios"
	CONFIG_CHECK="~USB_SERIAL"
	WARNING_USB_SERIAL="You need to enable CONFIG_USB_SERIAL in your kernel to talk to some radios"
	check_extra_config
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
		-DINSTALL_UDEV_RULES=ON
		-DINSTALL_UDEV_PATH="$(get_udevdir)/rules.d"
	)
	cmake_src_configure
}

pkg_postinst() {
	udev_reload
	xdg_icon_cache_update
}

pkg_postrm() {
	udev_reload
	xdg_icon_cache_update
}
