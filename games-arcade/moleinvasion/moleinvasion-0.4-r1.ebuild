# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="Mole infested 2D platform game"
HOMEPAGE="http://moleinvasion.tuxfamily.org/"
SRC_URI="ftp://download.tuxfamily.org/minvasion/packages/MoleInvasion-${PV}.tar.bz2
	music? ( mirror://gentoo/${PN}-music-20090731.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="music"

DEPEND="media-libs/libsdl[opengl,video]
	virtual/opengl
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${P}/src

src_prepare() {
	use music && mv -f "${WORKDIR}"/music ../
	sed -i \
		-e '/^CFLAGS/s:= -g:+=:' \
		-e '/^LDFLAGS/d' \
		-e "/^FINALEXEDIR/s:/usr.*:${GAMES_BINDIR}:" \
		-e "/^FINALDATADIR/s:/usr.*:${GAMES_DATADIR}/${PN}:" \
		Makefile \
		|| die "sed failed"
	epatch "${FILESDIR}"/${P}-opengl.patch \
		"${FILESDIR}"/${P}-underlink.patch
}

src_install() {
	emake DESTDIR="${D}" install install-data
	newicon ../gfx/icon.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Mole Invasion"
	doman ../debian/*.6
	prepgamesdirs
}
