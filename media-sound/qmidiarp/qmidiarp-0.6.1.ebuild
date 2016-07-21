# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils autotools

DESCRIPTION="An arpeggiator, sequencer and MIDI LFO for ALSA"
HOMEPAGE="http://qmidiarp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls lv2 osc qt5"

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	lv2? ( >=media-libs/lv2-1.8 )
	osc? ( media-libs/liblo )
	qt5? ( dev-qt/qtwidgets:5 dev-qt/qtgui:5 dev-qt/qtcore:5 )
	!qt5? ( dev-qt/qtgui:4 dev-qt/qtcore:4 )"
DEPEND="${RDEPEND}
	nls? (
		qt5? ( dev-qt/qttranslations:5 )
		!qt5? ( dev-qt/qttranslations:4 )
	)
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog NEWS README"

src_prepare() {
	eautoreconf
}

src_configure() {
	if use qt5 ; then
		export PATH="$(qt5_get_bindir):${PATH}"
	else
		export PATH="$(qt4_get_bindir):${PATH}"
	fi
	econf \
		$(use qt5 && echo "--enable-qt5") \
		$(use_enable nls translations) \
		$(use_enable osc nsm) \
		$(use_enable lv2 lv2plugins)

}
