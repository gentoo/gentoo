# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/manaplus/manaplus-1.3.9.29.ebuild,v 1.3 2014/08/10 17:39:15 ago Exp $

# REMINDER: check sdl2 support on version bump

EAPI=5

inherit games

DESCRIPTION="OpenSource 2D MMORPG client for Evol Online and The Mana World"
HOMEPAGE="http://manaplus.evolonline.org"
SRC_URI="http://download.evolonline.org/manaplus/download/${PV}/manaplus-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls opengl"

RDEPEND="
	>=dev-games/guichan-0.8.1[sdl]
	>=dev-games/physfs-1.0.0
	dev-libs/libxml2
	media-fonts/dejavu
	media-libs/libpng:0
	media-libs/libsdl[X,opengl?,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	net-misc/curl
	sys-libs/zlib
	x11-libs/libX11
	x11-misc/xdg-utils
	x11-apps/xmessage
	x11-misc/xsel
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	sed -i \
		-e '/^SUBDIRS/s/fonts//' \
		data/Makefile.in || die

	rm -r src/guichan || die
}

src_configure() {
	egamesconf \
		--without-internalguichan \
		--localedir=/usr/share/locale \
		--disable-manaserv \
		--disable-eathena \
		$(use_with opengl) \
		$(use_enable nls) \
		--prefix="/usr" \
		--bindir="${GAMES_BINDIR}"
}

src_install() {
	default

	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans-bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono.ttf "${GAMES_DATADIR}"/${PN}/data/fonts/dejavusans-mono.ttf

	prepgamesdirs
}
