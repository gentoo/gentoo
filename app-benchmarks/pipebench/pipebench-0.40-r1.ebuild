# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-benchmarks/pipebench/pipebench-0.40-r1.ebuild,v 1.3 2013/06/05 07:37:05 zmedico Exp $

EAPI="3"

inherit toolchain-funcs

DESCRIPTION="Measures the speed of stdin/stdout communication"
HOMEPAGE="http://www.habets.pp.se/synscan/programs.php?prog=pipebench"
SRC_URI="ftp://ftp.habets.pp.se/pub/synscan/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~arm-linux ~x86-linux"
IUSE=""

src_prepare() {
	sed -i Makefile \
		-e 's:CFLAGS=-Wall:CFLAGS+= -Wall:' \
		-e 's:$(CFLAGS) -o:$(LDFLAGS) &:g' \
		-e "s:/usr/local/bin/:${ED}/usr/bin:" \
		-e "s:/usr/local/man/man1/:${ED}/usr/share/man/man1:" \
		|| die "sed Makefile"
}

src_compile() {
	emake CC=$(tc-getCC) || die
}

src_install() {
	dodir /usr/{bin,share/man/man1}
	emake install || die
	dodoc README
}
