# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR BiCePS Linear Integer Solver"
HOMEPAGE="https://projects.coin-or.org/CHiPPS/"
SRC_URI="https://github.com/coin-or/CHiPPS-BLIS/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/CHiPPS-BLIS-releases-${PV}/Blis"

LICENSE="EPL-1.0"
SLOT="0" # formerly 0/1, upstream went from so.1 to so.0
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/coinor-alps:=
	sci-libs/coinor-bcps:=
	sci-libs/coinor-cgl:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

src_prepare() {
	default
	# Prevent unneeded call to pkg-config that needs ${ED}'s in path.
	sed -i '/--libs.*addlibs.txt/d' Makefile.in || die

	gzip -d examples/data/{,hard/}*.gz || die
}

src_configure() {
	econf $(use_with doc dot)
}

src_compile() {
	emake all $(usex doc doxydoc '')
}

src_test() {
	# Needed given "make check" is a noop and it skips the working one.
	emake test
}

src_install() {
	default
	dodoc -r examples
	use doc && dodoc -r doxydoc/html

	# Duplicate or irrelevant files.
	rm -r "${ED}"/usr/share/coin/doc || die
	find "${ED}" -name '*.la' -delete || die
}
