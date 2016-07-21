# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs

DESCRIPTION="agrep is a tool for the fast searching of text allowing for errors in the search pattern"
HOMEPAGE="ftp://ftp.cs.arizona.edu/agrep/README"
SRC_URI="ftp://ftp.cs.arizona.edu/agrep/${P}.tar.Z"

LICENSE="AGREP"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc ppc64 ~sparc x86 ~ppc-macos ~sparc-solaris"
IUSE=""

DEPEND=""
RDEPEND="
	!dev-libs/tre
	!app-misc/glimpse"

src_compile() {
	# Remove first occurace of CFLAGS so we grab the user CFLAGS
	sed -i -e 's/^CFLAGS.*//' \
		-e "s:\$(CFLAGS):& \$(LDFLAGS) :" Makefile || die
	tc-export CC
	emake || die
}

src_install() {
	dobin agrep || die
	doman agrep.1 || die
	dodoc README agrep.algorithms agrep.chronicle COPYRIGHT \
		contribution.list || die
}
