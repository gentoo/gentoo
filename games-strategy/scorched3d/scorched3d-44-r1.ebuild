# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WX_GTK_VER=3.0
inherit autotools eutils wxwidgets games

DESCRIPTION="Multi-player tank battle in 3D (OpenGL)"
HOMEPAGE="http://www.scorched3d.co.uk/"
SRC_URI="mirror://sourceforge/scorched3d/Scorched3D-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dedicated mysql"

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-net
	media-libs/libpng:0
	sys-libs/zlib
	virtual/jpeg:0
	dev-libs/expat
	media-fonts/dejavu
	!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/glew
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		media-libs/freealut
		x11-libs/wxGTK:${WX_GTK_VER}[X]
		media-libs/freetype:2
		sci-libs/fftw:3.0
	)
	mysql? ( virtual/mysql )"
DEPEND="${RDEPEND}
	!dedicated? ( virtual/pkgconfig )"

S=${WORKDIR}/scorched

src_prepare() {
	edos2unix \
		src/launcher/wxdialogs/SettingsDialog.cpp \
		src/launcher/wxdialogs/DisplayDialog.cpp \
		src/launcher/wxdialogs/Display.cpp \
		src/launcher/wxdialogs/KeyDialog.cpp
	epatch \
		"${FILESDIR}"/${P}-fixups.patch \
		"${FILESDIR}"/${P}-gcc43.patch \
		"${FILESDIR}"/${P}-odbc.patch \
		"${FILESDIR}"/${P}-win32.patch \
		"${FILESDIR}"/${P}-freetype.patch \
		"${FILESDIR}"/${P}-jpeg9.patch \
		"${FILESDIR}"/${P}-wxgtk.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		--with-fftw=/usr \
		--with-ogg=/usr \
		--with-vorbis=/usr \
		--datadir="${GAMES_DATADIR}/${PN}" \
		--with-docdir="/usr/share/doc/${PF}" \
		--with-wx-config="${WX_CONFIG}" \
		--without-pgsql \
		$(use_with mysql) \
		$(use_enable dedicated serveronly)
}

src_install() {
	default
	rm "${ED}${GAMES_DATADIR}"/${PN}/data/fonts/* || die
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}/${PN}/data/fonts/dejavusans.ttf"
	dosym /usr/share/fonts/dejavu/DejaVuSansCondensed-Bold.ttf "${GAMES_DATADIR}/${PN}/data/fonts/dejavusconbd.ttf"
	dosym /usr/share/fonts/dejavu/DejaVuSansMono-Bold.ttf "${GAMES_DATADIR}/${PN}/data/fonts/dejavusmobd.ttf"
	if ! use dedicated ; then
		newicon data/images/tank-old.bmp ${PN}.bmp || die
		make_desktop_entry ${PN} "Scorched 3D" /usr/share/pixmaps/${PN}.bmp
	fi
	prepgamesdirs
}
