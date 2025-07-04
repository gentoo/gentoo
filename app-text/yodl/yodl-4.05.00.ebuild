# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic prefix

DESCRIPTION="Your Own Document Language: a pre-document language and tools to process it"
HOMEPAGE="https://fbb-git.gitlab.io/yodl/ https://gitlab.com/fbb-git/yodl"
SRC_URI="https://gitlab.com/fbb-git/${PN}/-/archive/${PV}/${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

BDEPEND="
	>=dev-build/icmake-9.03.01-r1
	doc? (
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-plaingeneric
	)
"

PATCHES=(
	"${FILESDIR}/${P}"-stdbool.patch
	"${FILESDIR}/${P}"-echo.patch
	"${FILESDIR}/${P}"-man.patch
)

src_prepare() {
	sed -e "/DOC.* =/s/yodl\(-doc\)\?/${PF}/" \
		-e "/COMPILER =/s/gcc/$(tc-getCC)/" \
		-e "/CXX =/s/g++/$(tc-getCXX)/" \
		-i INSTALL.im || die

	sed -e "s/ar r /$(tc-getAR) r /" \
		-e "s/ranlib/$(tc-getRANLIB)/" \
		-i icmake/stdcompile || die

	sed -e '/strip/s|"-s"|""|g' \
		-i icmake/program || die

	# required for std::filesystem usage
	append-cxxflags -std=c++17

	hprefixify build

	default
}

src_compile() {
	local target
	for target in  programs macros man $(usex doc manual ''); do
		AR=$(tc-getAR) RANLIB=$(tc-getRANLIB) ./build ${target} ||
			die "${target} failed"
	done
}

src_install() {
	./build install programs "${ED}" || die
	./build install macros "${ED}" || die
	./build install man "${ED}" || die
	./build install docs "${ED}" || die
	use doc && { ./build install manual "${ED}" || die ; }
}
