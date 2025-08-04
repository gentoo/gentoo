# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="C++ Mathematical Expression Parsing And Evaluation Library"
HOMEPAGE="
	https://www.partow.net/programming/exprtk/index.html
	https://github.com/ArashPartow/exprtk/
"
SRC_URI="
	https://github.com/ArashPartow/exprtk/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( readme.txt )

src_compile() { :; }

src_test() {
	emake \
		COMPILER="$(tc-getCXX)" \
		OPTIMIZATION_OPT="${CXXFLAGS}" \
		LINKER_OPT="-lm ${LDFLAGS}" \
		exprtk_test
	edo ./exprtk_test
}

src_install() {
	doheader exprtk.hpp
	einstalldocs
}
