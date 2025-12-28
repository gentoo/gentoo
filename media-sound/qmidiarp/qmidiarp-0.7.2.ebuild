# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Arpeggiator, sequencer and MIDI LFO for ALSA"
HOMEPAGE="https://qmidiarp.sourceforge.net/"
SRC_URI="https://github.com/emuse/${PN}/archive/refs/tags/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="lv2 osc"

RDEPEND="
	dev-qt/qtbase:6[gui,widgets]
	media-libs/alsa-lib
	virtual/jack
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DSTRIP_DEBUG_SYMBOLS=OFF
		-DCONFIG_LV2_UI_RTK=OFF
		-DCONFIG_APPBUILD=ON
		-DCONFIG_TRANSLATIONS=ON
		-DCONFIG_LV2=$(usex lv2)
		-DCONFIG_LV2_UI=$(usex lv2)
		-DCONFIG_NSM=$(usex osc)
	)
	cmake_src_configure
}
