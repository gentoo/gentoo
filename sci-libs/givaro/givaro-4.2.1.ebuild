# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C++ library for arithmetic and algebraic computations"
HOMEPAGE="https://casys.gricad-pages.univ-grenoble-alpes.fr/givaro/"
SRC_URI="https://github.com/linbox-team/givaro/releases/download/v${PV}/${P}.tar.gz"

LICENSE="CeCILL-B"
SLOT="0/9" # soname major
KEYWORDS="amd64 ~riscv ~x86 ~x64-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-text/doxygen[dot]
		dev-texlive/texlive-bibtexextra
		dev-texlive/texlive-fontsextra
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latex
		dev-texlive/texlive-latexextra
	)
"
DEPEND="dev-libs/gmp:0[cxx(+)]"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS ChangeLog README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-docdir="/usr/share/doc/${PF}/html" \
		$(use_enable doc)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
