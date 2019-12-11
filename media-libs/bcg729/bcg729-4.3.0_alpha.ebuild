# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="encoder and decoder of the ITU G729 Annex A/B speech codec"
HOMEPAGE="https://github.com/BelledonneCommunications/bcg729"
SRC_URI="https://github.com/BelledonneCommunications/bcg729/archive/${PV/_/-}.tar.gz \
		-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc64 ~x86"
IUSE="static-libs"
RDEPEND="
	!media-plugins/mediastreamer-bcg729
"
S=${WORKDIR}/${P/_/-}
PATCHES=(
	"${FILESDIR}"/${PN}-4.3.0_beta-cmake-build.patch
)

src_configure() {
	mycmakeargs=(
		-DENABLE_STATIC=$(usex static-libs)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	find "${ED}" -name '*.la' -delete || die
}
