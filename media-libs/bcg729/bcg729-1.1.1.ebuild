# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

TEST_SUFFIX="tests-20210101"
DESCRIPTION="Encoder and decoder of the ITU G729 Annex A/B speech codec"
HOMEPAGE="https://github.com/BelledonneCommunications/bcg729"
SRC_URI="https://github.com/BelledonneCommunications/${PN}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" test? ( http://www.belledonne-communications.com/bc-downloads/${PN}-patterns.zip -> ${PN}-${TEST_SUFFIX}.zip )"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~ppc ppc64 x86"
IUSE="test"

RESTRICT="test"
# Not all passing yet
# TODO: Report upstream
#RESTRICT="!test? ( test )"

BDEPEND="test? ( app-arch/unzip )"
RDEPEND="!media-plugins/mediastreamer-bcg729"

src_prepare() {
	sed -i -e 's/-Werror //' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=no
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}/test" || die
	mv "${WORKDIR}/patterns" "${BUILD_DIR}/test/" || die

	./testCampaignAll || die
}

src_install() {
	cmake_src_install
	find "${ED}" -name '*.la' -delete || die
}
