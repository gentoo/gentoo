# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="MIDI based metronome using ALSA sequencer"
HOMEPAGE="http://kmetronome.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE="debug"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	>=media-sound/drumstick-1.0.0
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
}
