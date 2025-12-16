# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=930f7a675ffc656eb5207d4f63fd03a51f767390
inherit cmake xdg

DESCRIPTION="Arpeggiator, sequencer and MIDI LFO for ALSA"
HOMEPAGE="https://qmidiarp.sourceforge.net/"
SRC_URI="https://github.com/emuse/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui lv2 nls osc"

REQUIRED_USE="osc? ( gui )"

RDEPEND="
	media-libs/alsa-lib
	virtual/jack
	gui? ( dev-qt/qtbase:6[gui,widgets] )
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )
"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( dev-qt/qttools:6[linguist] )
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DSTRIP_DEBUG_SYMBOLS=OFF
		-DCONFIG_LV2_UI_RTK=OFF
		-DCONFIG_APPBUILD=$(usex gui)
		-DCONFIG_LV2=$(usex lv2)
		-DCONFIG_TRANSLATIONS=$(usex nls)
		-DCONFIG_NSM=$(usex osc)
	)
	use gui && mycmakeargs+=( -DCONFIG_LV2_UI=$(usex lv2) )
	cmake_src_configure
}
