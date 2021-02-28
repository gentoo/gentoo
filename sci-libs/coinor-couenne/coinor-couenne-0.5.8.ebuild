# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2

DESCRIPTION="COIN-OR Convex Over and Under ENvelopes for Nonlinear Estimation"
HOMEPAGE="https://projects.coin-or.org/Couenne/"
SRC_URI="https://github.com/coin-or/Couenne/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Couenne-releases-${PV}/Couenne"

LICENSE="EPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	sci-libs/coinor-bonmin:=
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
	)"

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

src_install() {
	default
	dodoc doc/couenne-user-manual.pdf
	use doc && dodoc -r doxydoc/html

	# Duplicate or irrelevant files.
	rm -r "${ED}"/usr/share/coin/doc || die
	find "${ED}" -name '*.la' -delete || die
}
