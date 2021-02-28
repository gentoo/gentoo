# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COIN-OR solver for mixed-integer linear programs"
HOMEPAGE="https://projects.coin-or.org/SYMPHONY/"
SRC_URI="https://github.com/coin-or/SYMPHONY/archive/releases/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SYMPHONY-releases-${PV}/SYMPHONY"

LICENSE="EPL-1.0"
SLOT="0/3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc glpk test"
RESTRICT="!test? ( test )"

RDEPEND="
	sci-libs/coinor-cgl:=
	sci-libs/coinor-clp:=
	sci-libs/coinor-dylp:=
	sci-libs/coinor-osi:=
	sci-libs/coinor-utils:=
	sci-libs/coinor-vol:=
	glpk? ( sci-mathematics/glpk:= )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? (
		dev-tex/latex2html
		dev-texlive/texlive-latexextra
		virtual/latex-base
	)
	test? (
		sci-libs/coinor-netlib
		sci-libs/coinor-sample
	)"

src_prepare() {
	default
	# Prevent unneeded call to pkg-config that needs ${ED}'s in path.
	sed -i '/--libs.*addlibs.txt/d' Makefile.in || die

	# Fix manual color errors.
	sed -i 's/usenames/usenames,dvipsnames/' Doc/man.tex || die
}

src_configure() {
	econf $(usex glpk --with-glpk-lib=-lglpk --without-glpk)
}

src_compile() {
	default

	if use doc; then
		pushd Doc >/dev/null || die
		pdflatex Walkthrough || die
		pdflatex man || die
		popd >/dev/null || die
	fi
}

src_test() {
	# Needed given "make check" is a noop and it skips the working one.
	emake test
}

src_install() {
	default
	use doc && dodoc Doc/*.pdf

	# Other coinor-* use lowercase e, stay in-line with them.
	docinto examples
	dodoc -r Examples/.

	# Duplicate or irrelevant files.
	rm -r "${ED}"/usr/share/coin/doc || die
	find "${ED}" -name '*.la' -delete || die
}
