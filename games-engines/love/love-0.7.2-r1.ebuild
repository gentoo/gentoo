# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-engines/love/love-0.7.2-r1.ebuild,v 1.8 2015/05/15 10:39:18 pacho Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A framework for 2D games in Lua"
HOMEPAGE="http://love2d.org/"
SRC_URI="https://www.bitbucket.org/rude/${PN}/downloads/${P}-linux-src.tar.gz"

LICENSE="ZLIB"
SLOT="0.7"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-games/physfs
	dev-lang/lua[deprecated]
	media-libs/devil[mng,png,tiff]
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl[joystick,opengl]
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/opengl"
DEPEND="${RDEPEND}
	media-libs/libmng
	media-libs/tiff"

S=${WORKDIR}/${PN}-HEAD

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8.0-freetype2.patch
}

src_install() {
	DOCS="readme.txt changes.txt" \
		default
	if [[ "${SLOT}" != "0" ]]; then
		mv "${ED}${GAMES_BINDIR}"/${PN} \
			"${ED}${GAMES_BINDIR}"/${PN}-${SLOT} || die
	fi
}
