# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils xdg

DESCRIPTION="Arpeggiator, sequencer and MIDI LFO for ALSA"
HOMEPAGE="http://qmidiarp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lv2 nls osc"

BDEPEND="
	nls? ( dev-qt/linguist-tools:5 )
	virtual/pkgconfig"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	virtual/jack
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )"
DEPEND="${RDEPEND}"

src_configure() {
	export PATH="$(qt5_get_bindir):${PATH}"

	local myeconfargs=(
		$(use_enable lv2 lv2plugins)
		$(use_enable nls translations)
		$(use_enable osc nsm)
	)
	econf "${myeconfargs[@]}"
}
