# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/xvt/xvt-2.1-r3.ebuild,v 1.6 2013/01/21 19:02:24 ulm Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A tiny vt100 terminal emulator for X"
HOMEPAGE="ftp://ftp.x.org/R5contrib/xvt-1.0.README"
SRC_URI="ftp://ftp.x.org/R5contrib/xvt-1.0.tar.Z
		mirror://gentoo/xvt-2.1.diff.gz"

LICENSE="xvt"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${PN}-1.0

src_prepare() {
	# this brings the distribution upto version 2.1
	epatch "${WORKDIR}"/${P}.diff

	# fix #61393
	epatch "${FILESDIR}/${PN}-ttyinit-svr4pty.diff"

	# CFLAGS, CC #241554
	epatch "${FILESDIR}/${PN}-makefile.patch"

	# int main, not void main
	epatch "${FILESDIR}/${PN}-int-main.patch"

	# fix segfault (bug #363883)
	epatch "${FILESDIR}/${PN}-pts.patch"

	tc-export CC
}

src_install() {
	dobin xvt || die "dobin failed"
	doman xvt.1
	dodoc README
}
