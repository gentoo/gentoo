# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
LANGS="cs de en it ru"

inherit qt4-r2

MY_PN="2ManDVD"

DESCRIPTION="The successor of ManDVD"
HOMEPAGE="http://kde-apps.org/content/show.php?content=99450"
SRC_URI="http://download.tuxfamily.org/${PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug libav"

DEPEND="libav? ( media-video/libav:= )
	!libav? ( media-video/ffmpeg:0= )
	media-libs/libsdl
	virtual/glu
	virtual/opengl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtopengl:4
"
RDEPEND="${DEPEND}
	|| ( app-cdr/cdrkit app-cdr/cdrtools )
	dev-lang/perl
	media-fonts/dejavu
	media-gfx/exif
	media-libs/netpbm
	media-sound/sox
	media-video/dvdauthor
	media-video/ffmpegthumbnailer
	media-video/mjpegtools
	media-video/mplayer[encode]
"

S=${WORKDIR}/${MY_PN}

PATCHES=(
	"${FILESDIR}/${PN}-1.7.3-libav.patch"
	"${FILESDIR}/${PN}-1.8.5-libavformat54.patch"
)

src_prepare() {
	# Clean backup files
	find . -name "*~" -delete || die

	# Delete useless chmod that violates the sandbox
	sed -i -e '/chmod/d' ${MY_PN}.pro || die

	# Fix desktop file
	sed -i -e '/^Categories=/s/GNOME;AudioVideo;//' ${MY_PN}.desktop || die

	qt4-r2_src_prepare
}

pkg_postinst() {
	elog "You may wish to install media-video/xine-ui and/or build"
	elog "media-sound/sox with USE=mad for improved media handling support."
}
