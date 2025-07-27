# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

GF_COMPLETE_COMMIT="a6862d10c9db467148f20eef2c6445ac9afd94d8"
DESCRIPTION="Comprehensive Open Source Library for Galois Field Arithmetic"
HOMEPAGE="http://jerasure.org https://web.eecs.utk.edu/~jplank/plank/www/software.html"
SRC_URI="https://github.com/ceph/gf-complete/archive/${GF_COMPLETE_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${GF_COMPLETE_COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

src_prepare() {
	default

	# Avoid adding '-march=native'-like flags
	sed -i -e 's/ -O3 $(SIMD_FLAGS)//g' \
		src/Makefile.am \
		tools/Makefile.am \
		test/Makefile.am \
		examples/Makefile.am || die

	eautoreconf
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
