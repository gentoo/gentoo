# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic gnome2-utils games

DESCRIPTION="A 2D space trading and combat game, in a similar vein to Escape Velocity"
HOMEPAGE="http://blog.naev.org/"
SRC_URI="mirror://sourceforge/naev/${P}.tar.bz2
	mirror://sourceforge/naev/ndata-${PV}.zip"

LICENSE="GPL-2 GPL-3 public-domain CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +mixer +openal"

RDEPEND="media-libs/libsdl2[X,sound,video]
	dev-libs/libzip
	dev-libs/libxml2
	>=media-libs/freetype-2
	>=media-libs/libvorbis-1.2.1
	>=media-libs/libpng-1.2:0
	virtual/glu
	virtual/opengl
	dev-lang/lua:0
	mixer? ( media-libs/sdl2-mixer )
	openal? ( media-libs/openal )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_unpack() {
	unpack ${P}.tar.bz2
}

src_configure() {
	egamesconf \
		--docdir=/usr/share/doc/${PF} \
		--enable-lua=shared \
		$(use_enable debug) \
		$(use_with openal) \
		$(use_with mixer sdlmixer)
}

src_compile() {
	emake V=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		appicondir=/usr/share/pixmaps \
		appdatadir=/usr/share/appdata \
		Graphicsdir=/usr/share/applications \
		install

	insinto "${GAMES_DATADIR}"/${PN}
	newins "${DISTDIR}"/ndata-${PV}.zip ndata

	local res
	for res in 16 32 64 128; do
		newicon -s ${res} extras/logos/logo${res}.png naev.png
	done

	rm -f "${D}"/usr/share/doc/${PF}/LICENSE

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
