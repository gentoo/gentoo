# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pspresent/pspresent-1.3-r1.ebuild,v 1.5 2014/08/10 18:29:44 slyfox Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="A tool to display full-screen PostScript presentations"
SRC_URI="http://www.cse.unsw.edu.au/~matthewc/pspresent/${P}.tar.gz"
HOMEPAGE="http://www.cse.unsw.edu.au/~matthewc/pspresent/"
SLOT="0"
LICENSE="GPL-2"

IUSE="xinerama"
KEYWORDS="amd64 ppc x86"

RDEPEND="x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )
	app-text/ghostscript-gpl"
DEPEND="${RDEPEND}
	x11-proto/xproto
	xinerama? ( x11-proto/xineramaproto )
	>=sys-apps/sed-4"

src_prepare() {
	if ! use xinerama ; then
		sed -i -e "/^XINERAMA/s/^/#/g" Makefile || die "sed Makefile"
	fi
	sed -i Makefile \
		-e 's|= -Wall -O2|+= -Wall|g' \
		-e 's| -o | $(LDFLAGS)&|g' \
		|| die "sed Makefile"
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dobin pspresent
	doman pspresent.1
}
