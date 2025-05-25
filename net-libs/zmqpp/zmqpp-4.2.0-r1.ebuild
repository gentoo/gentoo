# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zeromq/zmqpp.git"
else
	SRC_URI="https://github.com/zeromq/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="ZeroMQ 'highlevel' C++ bindings"
HOMEPAGE="https://github.com/zeromq/zmqpp"

LICENSE="MPL-2.0"
SLOT="0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

DEPEND="net-libs/zeromq[static-libs?]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-multilib-strict.patch"
	"${FILESDIR}/${PN}-4.2.0-boost-test-syntax.patch"
)

src_configure() {
	local mycmakeargs=(
		-DIS_TRAVIS_CI_BUILD=OFF
		-DZMQPP_BUILD_SHARED=ON
		-DZMQPP_BUILD_STATIC=$(usex static-libs)
		-DZMQPP_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	# https://github.com/zeromq/zmqpp/issues/223
	local -x BOOST_TEST_RUN_FILTERS='!socket/test_simple_monitor'
	cmake_src_test
}
