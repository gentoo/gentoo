# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR Basic Open-source Nonlinear Mixed INteger programming"
HOMEPAGE="https://projects.coin-or.org/Bonmin/"
SRC_URI="https://github.com/coin-or/Bonmin/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Bonmin-releases-${PV}/Bonmin"

LICENSE="EPL-1.0"
SLOT="0/4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/coinor-cbc:=
	sci-libs/coinor-cgl:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	sci-libs/ipopt:=
	virtual/blas"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[dot]
		virtual/latex-base
	)
	test? ( sci-libs/coinor-sample )"

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
	dodoc -r examples doc/BONMIN_UsersManual.pdf
	use doc && dodoc -r doxydoc/html

	# Duplicate or irrelevant files.
	rm -r "${ED}"/usr/share/coin/doc || die
	find "${ED}" -name '*.la' -delete || die
}
