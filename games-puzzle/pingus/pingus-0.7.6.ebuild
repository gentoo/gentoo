# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils scons-utils toolchain-funcs flag-o-matic games

DESCRIPTION="free Lemmings clone"
HOMEPAGE="http://pingus.seul.org/"
SRC_URI="https://pingus.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="opengl music"

RDEPEND="media-libs/libsdl[joystick,opengl?,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	music? ( media-libs/sdl-mixer[mod] )
	opengl? ( virtual/opengl )
	media-libs/libpng:0=
	dev-libs/boost:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	strip-flags
	epatch \
		"${FILESDIR}"/${P}-noopengl.patch \
		"${FILESDIR}"/${P}-gcc47.patch
}

src_compile() {
	escons \
		CXX="$(tc-getCXX)" \
		CCFLAGS="${CXXFLAGS}" \
		LINKFLAGS="${LDFLAGS}" \
		$(use_scons opengl with_opengl)
}

src_install() {
	emake install-exec install-data \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		DATADIR="${GAMES_DATADIR}/${PN}" \
		BINDIR="${GAMES_BINDIR}"
	doman doc/man/pingus.6
	doicon data/images/icons/pingus.svg
	make_desktop_entry ${PN} Pingus
	dodoc AUTHORS NEWS README TODO
	prepgamesdirs
}
