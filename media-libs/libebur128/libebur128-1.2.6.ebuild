# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Library implementing the EBU R128 loudness standard"
HOMEPAGE="https://github.com/jiixyj/libebur128"
SRC_URI="https://github.com/jiixyj/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://tech.ebu.ch/files/live/sites/tech/files/shared/testmaterial/ebu-loudness-test-setv05.zip )"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		app-arch/unzip
		media-libs/libsndfile[${MULTILIB_USEDEP}]
	)
"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	cd "${WORKDIR}" || die
	"${BUILD_DIR}"/r128-test-library | tee test-results
	grep -c "^FAILED" test-results > /dev/null \
		&& die "At least one test failed"
}
