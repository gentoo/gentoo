# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}-3-0"
DESCRIPTION="Backtracking YACC - modified from Berkeley YACC"
HOMEPAGE="http://www.siber.com/btyacc"
SRC_URI="http://www.siber.com/btyacc/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos ~x86-macos"

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
	# Darwin doesn't do static binaries
	if [[ ${CHOST} == *-darwin* ]]; then
		sed -i -e 's/-static//' Makefile || die
	fi
}

src_compile() {
	emake CC=$(tc-getCC)
}

src_install() {
	dobin btyacc
	dodoc README README.BYACC
	newman manpage btyacc.1
}
