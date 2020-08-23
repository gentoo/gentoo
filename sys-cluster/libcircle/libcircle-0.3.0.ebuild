# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="https://github.com/hpc/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/hpc/${PN}/releases/download/v0.3/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
fi

DESCRIPTION="API for distributing embarrassingly parallel workloads using self-stabilization"
HOMEPAGE="https://github.com/hpc/libcircle"

SLOT="0"
LICENSE="BSD"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/mpi"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )"

src_configure() {
	econf \
		$(use_enable doc doxygen) \
		$(use_enable static-libs static) \
		$(use_enable test tests)
}

src_install() {
	use doc && HTML_DOCS=( "${S}/doc/html/." )
	default
}
