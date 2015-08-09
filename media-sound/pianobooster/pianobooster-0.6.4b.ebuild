# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit cmake-utils

MY_P=${PN}-src-${PV}
DESCRIPTION="A MIDI file player that teaches how to play the piano"
HOMEPAGE="http://pianobooster.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="fluidsynth"

DEPEND="fluidsynth? ( media-sound/fluidsynth )
	media-libs/alsa-lib
	virtual/opengl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4"
RDEPEND="${DEPEND}"

DOCS="ReleaseNote.txt ../README.txt"

PATCHES=( "${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-gcc47.patch )

S=${WORKDIR}/${MY_P}/src

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use fluidsynth)
	)

	cmake-utils_src_configure
}
