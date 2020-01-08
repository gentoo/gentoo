# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Your Own Document Language: a pre-document language and tools to process it"
HOMEPAGE="https://fbb-git.gitlab.io/yodl/ https://gitlab.com/fbb-git/yodl"
SRC_URI="https://gitlab.com/fbb-git/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=dev-util/icmake-8.00.00"

S=${WORKDIR}/${P}/${PN}

pkg_pretend() {
	if [[ ${MERGE_TYPE} != "binary" ]]; then
		if tc-is-gcc && [[ $(gcc-major-version) -lt 8 ]]; then
			die "Your compiler doesn't fully support C++17. Use GCC 8 or newer."
		elif tc-is-clang && [[ $(clang-major-version) -lt 6 ]]; then
			die "Your compiler doesn't fully support C++17. Use Clang 6 or newer."
		fi
	fi
}

src_prepare() {
	sed -e "/DOC.* =/s/yodl\(-doc\)\?/${PF}/" \
		-e "/COMPILER =/s/gcc/$(tc-getCC)/" \
		-e "/CXX =/s/g++/$(tc-getCXX)/" \
		-i INSTALL.im || die

	sed -e "s/g++/$(tc-getCXX)/" \
		-e "s:#define CLS://\0:" \
		-i verbinsert/icmconf || die

	sed -e "s/ar r /$(tc-getAR) r /" \
		-e "s/ranlib/$(tc-getRANLIB)/" \
		-i icmake/stdcompile || die

	# required for std::filesystem usage
	append-cxxflags -std=c++17

	default
}

src_compile() {
	./build programs || die
	./build macros || die
	./build man || die
	use doc && { ./build manual || die ; }
}

src_install() {
	./build install programs "${ED}" || die
	./build install macros "${ED}" || die
	./build install man "${ED}" || die
	./build install docs "${ED}" || die
	use doc && { ./build install manual "${ED}" || die ; }
}
