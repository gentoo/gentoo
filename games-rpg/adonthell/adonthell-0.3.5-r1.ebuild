# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/adonthell/adonthell-0.3.5-r1.ebuild,v 1.9 2015/04/08 18:11:42 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils python-single-r1 games

DESCRIPTION="roleplaying game engine"
HOMEPAGE="http://adonthell.linuxgames.com/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc nls"

RDEPEND="${PYTHON_DEPS}
	media-libs/sdl-ttf
	media-libs/sdl-mixer[vorbis]
	media-libs/libsdl:0[X,video,sound]
	sys-libs/zlib
	media-libs/freetype
	media-libs/libogg
	media-libs/libvorbis
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-lang/swig
	doc? (
		media-gfx/graphviz
		app-doc/doxygen
	)
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}-${PV/a/}

pkg_setup() {
	python-single-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-configure.in.patch \
		"${FILESDIR}"/${P}-glibc-2.10.patch \
		"${FILESDIR}"/${P}-format.patch \
		"${FILESDIR}"/${P}-gcc46.patch
	sed -i \
		-e "/AC_PATH_PROGS/s:python:${EPYTHON}:" \
		configure.in || die "sed failed"
	rm -f ac{local,include}.m4
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-py-debug \
		$(use_enable nls) \
		$(use_enable doc)
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir "${GAMES_DATADIR}"/${PN}/games
	dodoc AUTHORS ChangeLog FULLSCREEN.howto NEWBIE NEWS README
	prepgamesdirs
}
