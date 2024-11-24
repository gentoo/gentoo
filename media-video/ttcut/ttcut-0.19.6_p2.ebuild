# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop qmake-utils xdg

DESCRIPTION="Tool for cutting MPEG files especially for removing commercials"
HOMEPAGE="https://github.com/baltendorf/ttcut"
SRC_URI="https://dev.gentoo.org/~billie/distfiles/${P}.tar.gz"

S=${WORKDIR}/${PN}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=media-libs/libmpeg2-0.4.0
	dev-qt/qtbase:6
	dev-qt/qtbase:6[gui]
	dev-qt/qtbase:6[opengl]
	dev-qt/qtbase:6[widgets]
	virtual/glu
	virtual/opengl
"
RDEPEND="
	${DEPEND}
	media-video/mjpegtools
	media-video/mplayer
	>=media-video/ffmpeg-1.0.8[encode]
"

src_prepare() {
	default

	xdg_environment_reset

	eqmake6 ttcut.pro
}

src_install() {
	dobin ttcut

	domenu "${FILESDIR}"/${PN}.desktop

	dodoc AUTHORS BUGS CHANGELOG README.* TODO
}
