# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# From cmake/GoogleapisConfig.cmake
GOOGLEAPIS_COMMIT="69e9dff10df4fa1e338712d38dc26b46791a6e94"

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
SRC_URI="https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/abseil-cpp:=
	dev-cpp/nlohmann_json
	dev-libs/protobuf:=
	dev-libs/crc32c
	dev-libs/openssl:=
	dev-libs/re2:=
	net-misc/curl
	net-libs/grpc:=
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-cpp/gtest
	test? (
		dev-cpp/benchmark
	)"

DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DGOOGLE_CLOUD_CPP_ENABLE_WERROR=OFF
		-DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_CXX_STANDARD=17
	)

	cmake_src_configure

	mkdir -p "${BUILD_DIR}/external/googleapis/src/" || die
	cp "${DISTDIR}/googleapis-${GOOGLEAPIS_COMMIT}.tar.gz" \
		"${BUILD_DIR}/external/googleapis/src/${GOOGLEAPIS_COMMIT}.tar.gz" || die
}

src_test() {
	# ClogEnvironment fails under portage sandbox, no fail outside
	cmake_src_test -LE "integration-test" -E common_log_test
}
