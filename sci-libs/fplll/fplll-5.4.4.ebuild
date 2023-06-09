# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/fplll/fplll"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/8"
KEYWORDS="amd64 ~x86"
IUSE="qd"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/gmp:0
	dev-libs/mpfr:0
	qd? ( sci-libs/qd )"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with qd)
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
