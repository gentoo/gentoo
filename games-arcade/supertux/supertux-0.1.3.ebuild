# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="A game similar to Super Mario Bros"
HOMEPAGE="http://super-tux.sourceforge.net"
SRC_URI="https://supertux.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE="opengl"

DEPEND="media-libs/libsdl[joystick]
	media-libs/sdl-image[png,jpeg]
	media-libs/sdl-mixer[mod,vorbis]
	x11-libs/libXt"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
	"${FILESDIR}"/${P}-gcc41.patch \
	"${FILESDIR}"/${P}-ndebug.patch \
	"${FILESDIR}"/${P}-desktop.patch
}

src_configure() {
	egamesconf \
		--disable-debug \
		$(use_enable opengl)
}

src_install() {
	emake DESTDIR="${D}" \
		desktopdir=/usr/share/applications \
		icondir=/usr/share/pixmaps \
		install
	dodoc AUTHORS ChangeLog LEVELDESIGN README TODO
	prepgamesdirs
}
