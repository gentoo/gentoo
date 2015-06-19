# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/xgammon/xgammon-0.98.ebuild,v 1.17 2015/03/27 07:20:13 mr_bones_ Exp $

EAPI=5
inherit toolchain-funcs eutils games

DESCRIPTION="very nice backgammon game for X"
HOMEPAGE="http://fawn.unibw-hamburg.de/steuer/xgammon/xgammon.html"
SRC_URI="http://fawn.unibw-hamburg.de/steuer/xgammon/Downloads/${P}a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake"

S=${WORKDIR}/${P}a

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-broken.patch" \
		"${FILESDIR}/${P}-config.patch" \
		"${FILESDIR}/gcc33.patch"
}

src_configure() {
	xmkmf || die
}

src_compile() {
	env PATH=".:${PATH}" emake \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		CDEBUGFLAGS="${CFLAGS}" \
		CC=$(tc-getCC)
}

pkg_postinst() {
	games_pkg_postinst
	einfo "xgammon need helvetica fonts"
	einfo "They can be loaded emerging media-fonts/font-adobe-100dpi"
	einfo "or similar. Remember to restart X after loading fonts"
}
