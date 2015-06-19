# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ps2eps/ps2eps-1.68.ebuild,v 1.15 2014/01/02 15:04:45 tomwij Exp $

inherit toolchain-funcs

DESCRIPTION="Generate Encapsulated Postscript Format (EPS,EPSF) files from one-page Postscript documents"
HOMEPAGE="http://www.tm.uka.de/~bless/ps2eps"
SRC_URI="http://www.tm.uka.de/~bless/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="app-text/ghostscript-gpl
	!<app-text/texlive-core-2007-r7"

S="${WORKDIR}/${PN}"

src_compile() {
	tc-export CC
	cd "${S}/src/C"
	echo "all: bbox" > Makefile
	emake || die "making bbox failed"
}

src_install() {
	dobin "${S}/src/C/bbox"
	dobin "${S}/bin/ps2eps"
	doman "${S}/doc/man/man1/bbox.1"
	doman "${S}/doc/man/man1/ps2eps.1"

	dodoc Changes.txt README.txt
	dohtml "${S}/doc/html/"*
	docinto pdf
	dodoc "${S}/doc/pdf/"*
}
