# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic qmake-utils

DESCRIPTION="An arpeggiator, sequencer and MIDI LFO for ALSA"
HOMEPAGE="http://qmidiarp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls lv2 osc"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	lv2? ( media-libs/lv2 )
	osc? ( media-libs/liblo )"
DEPEND="${RDEPEND}
	nls? ( dev-qt/qttranslations:5 )
	virtual/pkgconfig"

src_configure() {
	export PATH="$(qt5_get_bindir):${PATH}"

	append-cxxflags -std=c++11

	econf \
		--enable-qt5 \
		$(use_enable lv2 lv2plugins) \
		$(use_enable nls translations) \
		$(use_enable osc nsm)
}
