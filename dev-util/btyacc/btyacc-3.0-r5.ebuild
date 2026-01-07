# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${PN}-3-0"
DESCRIPTION="Backtracking YACC - modified from Berkeley YACC"
HOMEPAGE="https://www.siber.com/btyacc"
SRC_URI="https://www.siber.com/btyacc/${MY_P}.tar.gz"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=(
	"${FILESDIR}/${P}-includes.patch"
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${P}-c99.patch"
)

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	local file
	for file in "${S}"/test/*.y; do
		"${S}"/btyacc "${file}" || die
		rm y_tab.c || die
	done
}

src_install() {
	dobin btyacc
	dodoc README README.BYACC
	newman manpage btyacc.1
}
