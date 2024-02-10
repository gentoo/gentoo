# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# See https://github.com/google/cppdap/issues/113 re no release
CPPDAP_COMMIT="252b56807b532533ea7362a4d949758dcb481d2b"
GTEST_COMMIT="0a03480824b4fc7883255dbd2fd8940c9f81e22e"
DESCRIPTION="C++ library for the Debug Adapter Protocol"
HOMEPAGE="https://github.com/google/cppdap"
SRC_URI="https://github.com/google/cppdap/archive/${CPPDAP_COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" test? ( https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz -> ${PN}-gtest-${GTEST_COMMIT}.tar.gz )"
S="${WORKDIR}"/${PN}-${CPPDAP_COMMIT}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/nlohmann_json"
DEPEND="${RDEPEND}"

src_prepare() {
	if use test ; then
		rm -rf "${S}"/third_party/googletest || die
		ln -s "${WORKDIR}"/googletest-${GTEST_COMMIT} "${S}"/third_party/googletest || die
		mkdir "${S}"/third_party/googletest/.git || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Per README, could use rapidjson or jsoncpp instead.
		-DCPPDAP_USE_EXTERNAL_NLOHMANN_JSON_PACKAGE=ON
		-DCPPDAP_USE_EXTERNAL_RAPIDJSON_PACKAGE=OFF
		-DCPPDAP_USE_EXTERNAL_JSONCPP_PACKAGE=OFF

		-DCPPDAP_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./cppdap-unittests || die
}
