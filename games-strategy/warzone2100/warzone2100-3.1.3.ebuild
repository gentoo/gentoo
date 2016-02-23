# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs eutils versionator gnome2-utils games

MY_PV=$(get_version_component_range -2)
VIDEOS_PV=2.2
VIDEOS_P=${PN}-videos-${VIDEOS_PV}.wz
DESCRIPTION="3D real-time strategy game"
HOMEPAGE="http://wz2100.net/"
SRC_URI="mirror://sourceforge/warzone2100/${P}.tar.xz
	videos? ( mirror://sourceforge/warzone2100/warzone2100/Videos/${VIDEOS_PV}/high-quality-en/sequences.wz -> ${VIDEOS_P} )"

LICENSE="GPL-2+ CC-BY-SA-3.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# upstream requested debug support
IUSE="debug nls qt4 videos"

# TODO: unbundle miniupnpc and quesoglc
RDEPEND=">=dev-games/physfs-2[zip]
	dev-libs/fribidi
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/glew:=
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXrandr
	dev-qt/qtcore:4
	dev-qt/qtscript:4
	nls? ( virtual/libintl )
	qt4? (
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
	)
	!qt4? ( media-libs/libsdl[opengl,video,X] )"
DEPEND="${RDEPEND}
	app-arch/zip
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	media-fonts/dejavu"

src_prepare() {
	sed -i -e 's/#top_builddir/top_builddir/' po/Makevars || die
}

src_configure() {
	egamesconf \
		--docdir=/usr/share/doc/${PF} \
		--localedir=/usr/share/locale \
		--with-distributor="Gentoo ${PF}" \
		--with-icondir=/usr/share/icons/hicolor/128x128/apps \
		--with-applicationdir=/usr/share/applications \
		$(use_enable debug debug relaxed) \
		$(use_enable nls) \
		--with-backend=$(usex qt4 "qt" "sdl")
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	rm -f "${D}"/usr/share/doc/${PF}/COPYING*
	if use videos ; then
		insinto "${GAMES_DATADIR}"/${PN}
		newins "${DISTDIR}"/${VIDEOS_P} sequences.wz
	fi
	doman doc/warzone2100.6
	dodoc doc/quickstartguide.pdf

	elog "If you are using opensource drivers you should consider installing: "
	elog "    media-libs/libtxc_dxtn"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
