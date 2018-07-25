# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils toolchain-funcs

DESCRIPTION="A filter program that removes the LaTeX (or TeX) control sequences"
HOMEPAGE="http://www.cs.purdue.edu/homes/trinkle/detex/"
SRC_URI="http://www.cs.purdue.edu/homes/trinkle/detex/${P}.tar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="sys-devel/flex"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-ldflags.patch"
	sed -i \
		-e "s:CFLAGS	= -O \${DEFS}:CFLAGS	= ${CFLAGS} \${DEFS}:" \
		-e 's:LEX	= lex:#LEX	= lex:' \
		-e 's:#LEX	= flex:LEX	= flex:' \
		-e 's:#DEFS	+= ${DEFS} -DNO_MALLOC_DECL:DEFS += -DNO_MALLOC_DECL:' \
		-e 's:LEXLIB	= -ll:LEXLIB	= -lfl:' \
		Makefile || die "sed failed"
}

src_compile() {
	tc-export CC
	emake || die "emake failed"
}

src_install() {
	dobin detex || die
	dodoc README
	doman detex.1l
}
