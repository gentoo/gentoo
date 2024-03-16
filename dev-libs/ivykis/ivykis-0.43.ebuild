# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library for asynchronous I/O readiness notification"
HOMEPAGE="https://github.com/buytenh/ivykis"
SRC_URI="https://github.com/buytenh/ivykis/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="static-libs"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--cache-file="${S}"/config.cache \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die
}
