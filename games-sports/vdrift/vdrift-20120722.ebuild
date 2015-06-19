# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-sports/vdrift/vdrift-20120722.ebuild,v 1.4 2015/02/10 10:11:32 ago Exp $

EAPI=5
inherit eutils scons-utils games

MY_P=${PN}-${PV:0:4}-${PV:4:2}-${PV:6:2}
DESCRIPTION="A driving simulation made with drift racing in mind"
HOMEPAGE="http://vdrift.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2
	mirror://sourceforge/${PN}/${MY_P}c_patch.diff"

LICENSE="GPL-3 ZLIB LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="app-arch/libarchive
	media-libs/glew
	media-libs/libsdl[opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/libvorbis
	net-misc/curl
	sci-physics/bullet[-double-precision]
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-cpp/asio
	dev-libs/boost
	virtual/pkgconfig"

S=${WORKDIR}/VDrift

src_unpack() {
	unpack ${MY_P}.tar.bz2
}

src_prepare() {
	epatch \
		"${DISTDIR}"/${MY_P}c_patch.diff \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-bullet.patch
}

src_compile() {
	escons \
		force_feedback=1 \
		destdir="${D}" \
		bindir="${GAMES_BINDIR}" \
		datadir="${GAMES_DATADIR}"/${PN} \
		prefix= \
		use_binreloc=0 \
		release=1 \
		os_cc=1 \
		os_cxx=1 \
		os_cxxflags=1 \
		|| die
}

src_install() {
	dogamesbin build/vdrift
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/*
	newicon data/textures/icons/vdrift-64x64.png ${PN}.png
	make_desktop_entry ${PN} VDrift
	find "${D}" -name "SCon*" -exec rm \{\} +
	keepdir "${GAMES_DATADIR}"/${PN}/{music,settings/replays,settings/screenshots}
	prepgamesdirs
}
