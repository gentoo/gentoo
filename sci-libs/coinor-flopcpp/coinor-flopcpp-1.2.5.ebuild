# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR algebraic modeling language for linear optimization"
HOMEPAGE="https://projects.coin-or.org/FlopC++/"
SRC_URI="https://github.com/coin-or/FlopCpp/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FlopCpp-releases-${PV}/FlopCpp"

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

src_prepare() {
	default
	# Prevent unneeded call to pkg-config that needs ${ED}'s in path.
	sed -i '/--libs.*addlibs.txt/d' Makefile.in || die
}

src_configure() {
	econf $(use_with doc dot)
}

src_compile() {
	emake all $(usex doc doxydoc '')
}

src_test() {
	emake -j1 test
}

src_install() {
	default
	dodoc -r examples
	use doc && dodoc -r doxydoc/html

	# Duplicate or irrelevant files.
	rm -r "${ED}"/usr/share/coin/doc || die
	find "${ED}" -name '*.la' -delete || die
}
