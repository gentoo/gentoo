# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}-3-0"
DESCRIPTION="Backtracking YACC - modified from Berkeley YACC"
HOMEPAGE="https://www.siber.com/btyacc"
SRC_URI="https://www.siber.com/btyacc/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-includes.patch"
	"${FILESDIR}/${P}-makefile.patch"
)

src_prepare() {
	cp -av Makefile{,.orig} || die
	default
	# fix memory issue/glibc corruption
	sed -i -e "s|len + 13|len + 14|" main.c || die "Could not fix main.c"
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin btyacc
	dodoc README README.BYACC
	newman manpage btyacc.1
}
