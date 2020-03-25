# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Implementations of the floating-point LLL reduction algorithm"
HOMEPAGE="https://github.com/fplll/fplll"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/6"
KEYWORDS="amd64 x86"
IUSE="static-libs"

BDEPEND=""
DEPEND="dev-libs/gmp:0
	dev-libs/mpfr:0"
RDEPEND="${DEPEND}"

src_configure() {
	# Support for --with-qd is problematic at the moment.
	# https://github.com/fplll/fplll/issues/405
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
