# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnome2-utils games

DESCRIPTION="Chromium B.S.U. - an arcade game"
HOMEPAGE="http://chromium-bsu.sourceforge.net/"
SRC_URI="mirror://sourceforge/chromium-bsu/${P}.tar.gz"

LICENSE="Clarified-Artistic"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="mixer nls +sdl"

RDEPEND="media-fonts/dejavu
	media-libs/quesoglc
	media-libs/glpng
	virtual/opengl
	virtual/glu
	x11-libs/libXmu
	mixer? ( media-libs/sdl-mixer )
	!mixer? (
		media-libs/freealut
		media-libs/openal
	)
	nls? ( virtual/libintl )
	sdl? (
		media-libs/libsdl[X]
		media-libs/sdl-image[png]
	)
	!sdl? ( media-libs/freeglut )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_configure() {
	egamesconf \
		--disable-ftgl \
		--enable-glc \
		$(use_enable mixer sdlmixer) \
		$(use_enable !mixer openal) \
		$(use_enable nls) \
		$(use_enable sdl) \
		$(use_enable sdl sdlimage) \
		$(use_enable !sdl glut)
}

src_install() {
	emake DESTDIR="${D}" install

	# remove installed /usr/games/share stuff
	rm -rf "${D}"/"${GAMES_PREFIX}"/share/

	newicon -s 64 misc/${PN}.png ${PN}.png
	domenu misc/chromium-bsu.desktop

	# install documentation
	dodoc AUTHORS README NEWS
	dohtml "${S}"/data/doc/*.htm
	dohtml -r "${S}"/data/doc/images

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
