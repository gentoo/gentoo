# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="encoder and decoder of the ITU G729 Annex A/B speech codec"
HOMEPAGE="https://github.com/BelledonneCommunications/bcg729"
SRC_URI="https://github.com/BelledonneCommunications/bcg729/archive/${PV/_/-}.tar.gz \
		-> ${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~ppc ppc64 ~x86"

RDEPEND="!media-plugins/mediastreamer-bcg729"

src_prepare() {
	sed -i -e 's/-Werror //' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=no
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.la' -delete || die
}
