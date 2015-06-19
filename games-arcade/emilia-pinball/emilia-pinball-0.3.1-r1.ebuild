# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/emilia-pinball/emilia-pinball-0.3.1-r1.ebuild,v 1.10 2015/01/04 09:24:26 tupone Exp $

EAPI=5
inherit autotools eutils games

MY_PN=${PN/emilia-/}
MY_P=${MY_PN}-${PV}
DESCRIPTION="SDL OpenGL pinball game"
HOMEPAGE="http://pinball.sourceforge.net/"
SRC_URI="mirror://sourceforge/pinball/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

# Drop the libtool dep once libltdl goes stable.
RDEPEND="virtual/opengl
	x11-libs/libSM
	media-libs/libsdl[joystick,opengl,video,X]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	|| ( dev-libs/libltdl:0 <sys-devel/libtool-2.4.3-r2:2 )"
DEPEND="${RDEPEND}
	x11-libs/libXt"

S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i -e '/dnl/d' {src,test}/Makefile.am || die #334899
	epatch "${FILESDIR}"/${P}-glibc210.patch \
		"${FILESDIR}"/${P}-libtool.patch \
		"${FILESDIR}"/${P}-gcc46.patch \
		"${FILESDIR}"/${P}-parallel.patch
	rm -rf libltdl
	eautoreconf
}

src_configure() {
	egamesconf --with-x
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	default
	dosym "${GAMES_BINDIR}"/pinball "${GAMES_BINDIR}"/emilia-pinball
	mv "${D}/${GAMES_PREFIX}/include" "${D}/usr/" || die
	dodir /usr/bin
	mv "${D}/${GAMES_BINDIR}/pinball-config" "${D}/usr/bin/" || die
	sed -i \
		-e 's:-I${prefix}/include/pinball:-I/usr/include/pinball:' \
		"${D}"/usr/bin/pinball-config || die
	newicon data/pinball.xpm ${PN}.xpm
	make_desktop_entry emilia-pinball "Emilia pinball"
	prepgamesdirs
}
