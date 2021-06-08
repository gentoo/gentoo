# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/fplll/fplll"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/7"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs qd"

BDEPEND="qd? ( virtual/pkgconfig )"
DEPEND="dev-libs/gmp:0
	dev-libs/mpfr:0
	qd? ( sci-libs/qd )"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-5.4.0-gcc11.patch" )

src_configure() {
	econf \
		$(use_with qd) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
