# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# This should match the commit hash of the opentelemetry-proto submodule
OTELCPP_PROTO_SHA="b3060d2104df364136d75a35779e6bd48bac449a"

DESCRIPTION="The OpenTelemetry C++ Client"
HOMEPAGE="
	https://opentelemetry.io/
	https://github.com/open-telemetry/opentelemetry-cpp
"
SRC_URI="
	https://github.com/open-telemetry/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/open-telemetry/opentelemetry-proto/archive/${OTELCPP_PROTO_SHA}.tar.gz -> opentelemetry-proto-${OTELCPP_PROTO_SHA}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="
	+http
	+http-compression
	grpc
	file
	mtls
	zipkin
	elasticsearch
	deprecated
	test
"
REQUIRED_USE="
	http-compression? ( http )
"

RDEPEND="
	net-misc/curl
"
DEPEND="
	${RDEPEND}
	dev-cpp/abseil-cpp
	http? (
		dev-cpp/nlohmann_json
		dev-libs/protobuf
	)
	http-compression? (
		sys-libs/zlib
	)
	grpc? (
		dev-libs/protobuf
		net-libs/grpc
	)
	zipkin? (
		dev-cpp/nlohmann_json
	)
	elasticsearch? (
		dev-cpp/nlohmann_json
	)
	test? (
		dev-cpp/gtest
		dev-cpp/benchmark
	)
"

RESTRICT="!test? ( test )"

PATCHES=(
	# remove tests that need network
	"${FILESDIR}/opentelemetry-cpp-1.16.1-tests.patch"
)

src_configure() {
	local mycmakeargs=(
		-DOTELCPP_PROTO_PATH="${WORKDIR}/opentelemetry-proto-${OTELCPP_PROTO_SHA}"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DBUILD_SHARED_LIBS=ON
		-DOPENTELEMETRY_INSTALL=ON
		-DWITH_ABSEIL=ON
		-DBUILD_TESTING=$(usex test)
		-DWITH_NO_DEPRECATED_CODE=$(usex deprecated FALSE TRUE)
		-DWITH_DEPRECATED_SDK_FACTORY=$(usex deprecated)
		-DWITH_OTLP_HTTP=$(usex http)
		-DWITH_OTLP_HTTP_COMPRESSION=$(usex http-compression)
		-DWITH_OTLP_GRPC=$(usex grpc)
		-DWITH_OTLP_FILE=$(usex file)
		-DWITH_OTLP_GRPC_SSL_MTLS_PREVIEW=$(usex mtls)
	)

	cmake_src_configure
}
