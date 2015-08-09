# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A collection of simple routines to call some of those X11 functions"
HOMEPAGE="http://ftp.x.org/contrib/utilities/xwit-3.4.README"
SRC_URI="http://ftp.x.org/contrib/utilities/${P}.tar.gz"

LICENSE="public-domain HPND"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-malloc-includes.patch

	cp -vf "${FILESDIR}"/Makefile .

	tc-export CC
}

src_install() {
	dobin xwit
	newman xwit.man xwit.1
	dodoc README
}
