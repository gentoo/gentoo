# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# See https://github.com/google/cppdap/issues/113 re no release
CPPDAP_COMMIT="c69444ed76f7468b232ac4f989cb8f2bdc100185"

DESCRIPTION="C++ library for the Debug Adapter Protocol"
HOMEPAGE="https://github.com/google/cppdap"
SRC_URI="https://github.com/google/cppdap/archive/${CPPDAP_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${CPPDAP_COMMIT}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/nlohmann_json"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	local mycmakeargs=(
		# Per README, could use rapidjson or jsoncpp instead.
		-DCPPDAP_USE_EXTERNAL_NLOHMANN_JSON_PACKAGE=ON
		-DCPPDAP_USE_EXTERNAL_RAPIDJSON_PACKAGE=OFF
		-DCPPDAP_USE_EXTERNAL_JSONCPP_PACKAGE=OFF

		-DCPPDAP_BUILD_TESTS=$(usex test)
		-DCPPDAP_USE_EXTERNAL_GTEST_PACKAGE=ON
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./cppdap-unittests || die
}
