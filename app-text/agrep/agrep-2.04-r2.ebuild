# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A tool for the fast searching of text allowing for errors in the search pattern"
HOMEPAGE="ftp://ftp.cs.arizona.edu/agrep/README"
SRC_URI="ftp://ftp.cs.arizona.edu/${PN}/${P}.tar.Z"

LICENSE="AGREP"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86 ~ppc-macos ~sparc-solaris"

RDEPEND="
	!dev-libs/tre
	!dev-ruby/amatch
	!app-misc/glimpse"

DOCS=( README agrep.algorithms agrep.chronicle COPYRIGHT contribution.list )

src_compile() {
	sed -i \
		-e 's/^CFLAGS.*//' \
		-e "s:\$(CFLAGS):& \$(LDFLAGS) :" Makefile || die
	tc-export CC
	emake
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
