# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="A GiNaC-based library for symbolic expansion of certain transcendental functions"
HOMEPAGE="https://particlephysics.uni-mainz.de/weinzierl/nestedsums/"
IUSE="doc"
SRC_URI="http://particlephysics.uni-mainz.de/weinzierl/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=sci-mathematics/ginac-1.7"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	default

	if use doc; then
		doxygen Doxyfile || die "generating documentation failed"
	fi
}

src_test() {
	emake check
}

src_install() {
	use doc && local HTML_DOCS=( reference/html/. )
	default
	find "${D}" -name '*.la' -type f -delete || die
}
