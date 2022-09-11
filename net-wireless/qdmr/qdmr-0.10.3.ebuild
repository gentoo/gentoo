# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev linux-info

DESCRIPTION="GUI application for configuring and programming cheap DMR radios"
HOMEPAGE="https://dm3mat.darc.de/qdmr/"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hmatuschek/qdmr.git"
else
	MY_PV="${PV/_/-}"
	SRC_URI="https://github.com/hmatuschek/qdmr/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	dev-cpp/yaml-cpp:=
	dev-qt/designer:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	dev-qt/qtgui:5
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtpositioning:5
	dev-qt/qtserialport:5
	virtual/libusb:1
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

pkg_setup() {
	CONFIG_CHECK="~USB_ACM"
	WARNING_USB_ACM="Some radios require CONFIG_USB_ACM to work, you may need to enable this driver to talk to your radio"
	CONFIG_CHECK="~USB_SERIAL"
	WARNING_USB_SERIAL="Some radios require CONFIG_USB_SERIAL to work, you may need to enable this driver to talk to your radio"
	check_extra_config
}

src_prepare() {
	#no devil perms
	sed -i 's#666#660#' dist/99-qdmr.rules
	sed -i "s#/etc/udev/rules.d/#$(get_udevdir)/rules.d#" lib/CMakeLists.txt
	cmake_src_prepare
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
