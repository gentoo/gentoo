# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

JSON_VER="3.4.0"
GOOGLEAPIS_COMMIT="6a3277c0656219174ff7c345f31fb20a90b30b97"

DESCRIPTION="Google Cloud Client Library for C++"
HOMEPAGE="https://cloud.google.com/"
SRC_URI="https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/nlohmann/json/releases/download/v${JSON_VER}/json.hpp -> nlohmann-json-${JSON_VER}-json.hpp
	https://github.com/googleapis/googleapis/archive/${GOOGLEAPIS_COMMIT}.tar.gz -> googleapis-${GOOGLEAPIS_COMMIT}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"
RDEPEND="dev-libs/protobuf:=
	dev-libs/crc32c
	net-misc/curl
	net-libs/grpc:="
DEPEND="${RDEPEND}
	dev-cpp/gtest"

DOCS=( README.md )
PATCHES=(
	"${FILESDIR}/google-cloud-cpp-0.5.0-openssl.patch"
	"${FILESDIR}/google-cloud-cpp-0.9.0-offline_nlohmannjson.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGOOGLE_CLOUD_CPP_DEPENDENCY_PROVIDER=package
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=OFF
	)

	cmake-utils_src_configure

	mkdir -p "${BUILD_DIR}/external/nlohmann_json/src/" || die
	cp "${DISTDIR}/nlohmann-json-${JSON_VER}-json.hpp" "${BUILD_DIR}/external/nlohmann_json/src/json.hpp" || die

	mkdir -p "${BUILD_DIR}/external/googleapis/src/" || die
	cp "${DISTDIR}/googleapis-${GOOGLEAPIS_COMMIT}.tar.gz" \
		"${BUILD_DIR}/external/googleapis/src/${GOOGLEAPIS_COMMIT}.tar.gz" || die
}

src_test() {
	# test fails
	local myctestargs=(
		-E internal_parse_rfc3339_test
	)

	cmake-utils_src_test
}
