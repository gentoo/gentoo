# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="MIDI based metronome using ALSA sequencer"
HOMEPAGE="https://kmetronome.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	>=media-sound/drumstick-2.0.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
		-DUSE_QT=5
	)
	cmake_src_configure
}
