# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ftnchek/ftnchek-3.3.1-r1.ebuild,v 1.2 2012/02/16 18:38:18 phajdan.jr Exp $

EAPI="2"

inherit autotools

DESCRIPTION="Static analyzer a la 'lint' for Fortran 77"
HOMEPAGE="http://www.dsm.fordham.edu/~ftnchek/"
SRC_URI="http://www.dsm.fordham.edu/~${PN}/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

src_prepare() {
	#1 Do not strip
	#2 CFLAGS is used internally, so append to it
	sed -i Makefile.in \
		-e '/-$(STRIP)/d' \
		-e 's|CFLAGS\([[:space:]]*\)=|CFLAGS\1+=|' \
		|| die "sed Makefile.in"

	#1 Respect CFLAGS
	#2 Respect LDFLAGS
	sed -i configure.in \
		-e 's|OPT=".*"|OPT=""|g' \
		-e '/^LDFLAGS=/d' \
		|| die "sed configure.in"

	eautoreconf
}

src_install() {
	einstall || die
	dodoc FAQ PATCHES README ToDo
	dohtml html/*
	dodir /usr/share/${PN}
	cp -r test "${D}"/usr/share/${PN}
}
