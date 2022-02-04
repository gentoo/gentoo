# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="API for distributing embarrassingly parallel workloads using self-stabilization"
HOMEPAGE="https://github.com/hpc/libcircle"
SRC_URI="https://github.com/hpc/libcircle/releases/download/v$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/mpi"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		--disable-static \
		$(use_enable doc doxygen) \
		$(use_enable test tests)
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
