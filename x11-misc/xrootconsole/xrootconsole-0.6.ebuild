# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="A utility that displays its input in a text box on your root window"
HOMEPAGE="http://sourceforge.net/projects/xrootconsole/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}.noversion.patch"
	epatch "${FILESDIR}/${P}.makefile.patch"
	epatch "${FILESDIR}/${P}.manpage.patch"
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dodir /usr/bin

	make \
		MANDIR="${D}usr/share/man/man1" \
		BINDIR="${D}usr/bin/" \
		install || die "make install failed"

	dodoc TODO NEWS CREDITS
}
