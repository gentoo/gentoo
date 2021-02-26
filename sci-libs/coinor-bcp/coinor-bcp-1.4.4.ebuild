# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR Branch-Cut-Price Framework"
HOMEPAGE="https://projects.coin-or.org/Bcp/"
SRC_URI="https://github.com/coin-or/Bcp/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Bcp-releases-${PV}/Bcp"

LICENSE="CPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/coinor-clp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	sci-libs/coinor-vol:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	test? ( sci-libs/coinor-sample )"

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
	# Unneeded for Bcp given, while "make check" exists, it fails unlike
	# other coinor-*'s noop. Kept as safety not to lose tests in bumps.
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
