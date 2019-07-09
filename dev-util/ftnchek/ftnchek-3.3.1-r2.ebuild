# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Static analyzer a la 'lint' for Fortran 77"
HOMEPAGE="https://www.dsm.fordham.edu/~ftnchek/"
SRC_URI="https://www.dsm.fordham.edu/~${PN}/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

src_prepare() {
	default
	mv configure.{in,ac} || die
	mv dcl2inc.{man,1} || die

	#1 Do not strip
	#2 CFLAGS is used internally, so append to it
	sed -i Makefile.in \
		-e '/-$(STRIP)/d' \
		-e 's|CFLAGS\([[:space:]]*\)=|CFLAGS\1+=|' \
		|| die "sed Makefile.in"

	#1 Respect CFLAGS
	#2 Respect LDFLAGS
	sed -i configure.ac \
		-e 's|OPT=".*"|OPT=""|g' \
		-e '/^LDFLAGS=/d' \
		|| die "sed configure.ac"

	eautoreconf
}

src_install() {
	dobin ${PN} dcl2inc
	doman ${PN}.1 dcl2inc.1
	insinto /usr/share/${PN}
	doins dcl2inc.awk
	doins -r test
	dodoc FAQ PATCHES README ToDo
	docinto html
	dodoc -r html/*
}
