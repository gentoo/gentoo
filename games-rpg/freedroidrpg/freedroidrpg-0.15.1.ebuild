# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils gnome2-utils python-any-r1 games

DESCRIPTION="A modification of the classical Freedroid engine into an RPG"
HOMEPAGE="http://freedroid.sourceforge.net/"
SRC_URI="mirror://sourceforge/freedroid/freedroidRPG-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="opengl vorbis"

RDEPEND="media-libs/libsdl[opengl?,video]
	dev-lang/lua:0
	virtual/jpeg:0
	media-libs/libpng:0
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis?]
	>=media-libs/sdl-gfx-2.0.21
	vorbis? ( media-libs/libogg media-libs/libvorbis )
	x11-libs/libX11
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

pkg_setup() {
	python-any-r1_pkg_setup
	games_pkg_setup
}

src_prepare() {
	# No need for executable game resources
	find sound graphics -type f -execdir chmod -c a-x '{}' +
}

src_configure() {
	egamesconf \
		--disable-dependency-tracking \
		--disable-fastmath \
		$(use_enable opengl) \
		$(use_enable vorbis)
}

src_install() {
	emake DESTDIR="${D}" install || die
	rm -f "${D}/${GAMES_BINDIR}/"{croppy,pngtoico,*glue*,explode*,make_atlas}
	newicon -s 64 win32/w32icon2_64x64.png ${PN}.png
	make_desktop_entry freedroidRPG "Freedroid RPG"
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
