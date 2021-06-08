# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake udev

DESCRIPTION="GUI application for configuring and programming cheap DMR radios"
HOMEPAGE="https://dm3mat.darc.de/qdmr/"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hmatuschek/qdmr.git"
else
	SRC_URI="https://github.com/hmatuschek/qdmr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
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
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"
BDEPEND=""

src_prepare() {
	#no devil perms
	sed -i 's#666#660#' dist/99-qdmr.rules
	sed -i "s#/etc/udev/rules.d/#$(get_udevdir)/rules.d#" lib/CMakeLists.txt
	cmake_src_prepare
}
