# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib flag-o-matic

DESCRIPTION="A GiNaC-based library for symbolic expansion of certain transcendental functions"
HOMEPAGE="https://particlephysics.uni-mainz.de/weinzierl/nestedsums/"
IUSE="doc static-libs"
SRC_URI="http://particlephysics.uni-mainz.de/weinzierl/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RDEPEND=">=sci-mathematics/ginac-1.7[static-libs=]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	append-cxxflags -std=c++14
	econf $(use_enable static-libs static)
}

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
	emake DESTDIR="${D}" install
	rm "${D}"/usr/$(get_libdir)/lib${PN}.la || die "cannot rm lib${PN}.la"
	dodoc AUTHORS ChangeLog

	if use doc; then
		docinto html
		dodoc -r reference/html/.
	fi
}
