# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils fdo-mime qt4-r2

DESCRIPTION="Tool for cutting MPEG files especially for removing commercials"
HOMEPAGE="http://www.tritime.de/ttcut/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=media-libs/libmpeg2-0.4.0
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}
	media-video/mplayer
	>=media-video/ffmpeg-1.0.8[encode]"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-deprecated.patch
	"${FILESDIR}"/${P}-ntsc-fps.patch
	"${FILESDIR}"/${P}-ffmpeg-vf-setdar.patch
	"${FILESDIR}"/${P}-no_implicit_GLU.patch
	)

src_install() {
	dobin ttcut

	domenu "${FILESDIR}"/${PN}.desktop

	dodoc AUTHORS BUGS CHANGELOG README.* TODO
}
