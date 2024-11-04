# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="MIDI based metronome using ALSA sequencer"
HOMEPAGE="https://kmetronome.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtbase:6[dbus,gui,widgets]
	dev-qt/qtsvg:6
	media-libs/alsa-lib
	>=media-sound/drumstick-2.9.1[alsa]
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
	)
	cmake_src_configure
}
