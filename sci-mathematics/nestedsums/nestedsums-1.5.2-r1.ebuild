# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A GiNaC-based library for symbolic expansion of certain transcendental functions"
HOMEPAGE="https://particlephysics.uni-mainz.de/weinzierl/nestedsums/"
SRC_URI="https://particlephysics.uni-mainz.de/weinzierl/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=sci-mathematics/ginac-1.7"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	append-cxxflags -std=c++14
	econf --disable-static
}

src_compile() {
	default

	if use doc; then
		doxygen Doxyfile || die "generating documentation failed"
	fi
}

src_install() {
	default

	if use doc; then
		docinto html
		dodoc -r reference/html/.
	fi

	find "${ED}" -name '*.la' -delete || die
}
