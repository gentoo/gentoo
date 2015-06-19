# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/sdl-sopwith/sdl-sopwith-1.7.5-r1.ebuild,v 1.6 2013/05/13 03:49:12 mr_bones_ Exp $

EAPI=5
inherit eutils autotools toolchain-funcs games

MY_P=${P/sdl-/}
DESCRIPTION="Port of the classic Sopwith game using LibSDL"
HOMEPAGE="http://sdl-sopwith.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/libsdl-1.1.3[video]"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm acconfig.h
	epatch "${FILESDIR}"/${P}-nogtk.patch
	# bug 458504
	epatch "${FILESDIR}"/${P}-video-fix.patch
	eautoreconf
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog FAQ NEWS README TODO doc/*txt
	rm -rf "${D}/usr/games/share/"
	prepgamesdirs
}
