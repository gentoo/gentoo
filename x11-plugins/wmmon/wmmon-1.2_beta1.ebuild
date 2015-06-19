# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmmon/wmmon-1.2_beta1.ebuild,v 1.1 2012/03/29 11:28:04 voyageur Exp $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="Dockable system resources monitor applet for WindowMaker"
HOMEPAGE="http://repo.or.cz/w/dockapps.git"
SRC_URI="http://dev.gentoo.org/~voyageur/distfiles/${P/_beta/b}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S=${WORKDIR}/${P/_beta/b}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" -C ${PN}
}

src_install () {
	dobin wmmon/wmmon
	doman wmmon/wmmon.1
	dodoc BUGS CHANGES HINTS README TODO
}
