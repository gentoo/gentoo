# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_PN="QtGain"
inherit eutils qt4-r2

DESCRIPTION="A simple frontend to mp3gain, vorbisgain and metaflac"
HOMEPAGE="http://www.qt-apps.org/content/show.php/QtGain?content=56842"
SRC_URI="http://www.qt-apps.org/CONTENT/content-files/56842-${MY_PN}.tar.lzma
	-> ${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="flac mp3 mp4 vorbis"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	flac? ( media-libs/flac )
	mp3? ( media-sound/mp3gain )
	mp4? ( media-sound/aacgain )
	vorbis? ( media-sound/vorbisgain )
	media-sound/id3v2"

S="${WORKDIR}/${MY_PN}"

src_install() {
	dobin bin/${PN}
	newicon Icons/lsongs.png ${PN}.png
	make_desktop_entry ${PN} ${MY_PN}
}
