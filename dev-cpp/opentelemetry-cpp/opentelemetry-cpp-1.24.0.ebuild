# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# update based on third_party_release
OPENTELEMETRY_PROTO="1.8.0"

inherit cmake

DESCRIPTION="The OpenTelemetry C++ Client"
HOMEPAGE="
	https://opentelemetry.io/
	https://github.com/open-telemetry/opentelemetry-cpp/
"
SRC_URI="
	https://github.com/open-telemetry/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
	otlp? (
		https://github.com/open-telemetry/opentelemetry-proto/archive/refs/tags/v${OPENTELEMETRY_PROTO}.tar.gz
			-> opentelemetry-proto-${OPENTELEMETRY_PROTO}.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0/1"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

IUSE="elasticsearch grpc http otlp prometheus test"
REQUIRED_USE="
	grpc? ( otlp )
	http? ( otlp )
"
RESTRICT="!test? ( test )"

RDEPEND="
	http? (
		net-misc/curl
		virtual/zlib:=
	)
	elasticsearch? (
		dev-cpp/nlohmann_json
		net-misc/curl
	)
	grpc? ( net-libs/grpc:= )
	otlp? (
		dev-cpp/abseil-cpp:=
		dev-libs/protobuf:=[libprotoc(+)]
		dev-cpp/nlohmann_json
	)
	prometheus? ( dev-cpp/prometheus-cpp )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="
	virtual/pkgconfig
	otlp? ( dev-libs/protobuf[protoc(+)] )
"

src_configure() {
	# sanity check subslot to kick would be drive by bumpers
	# https://github.com/open-telemetry/opentelemetry-cpp/blob/main/docs/abi-version-policy.md
	local detected_abi
	detected_abi="$(sed -n -e 's/^#  define OPENTELEMETRY_ABI_VERSION_NO \(.*\)/\1/p' \
		api/include/opentelemetry/version.h)"
	detected_abi="${detected_abi}"
	if [[ "${SLOT}" != "0/${detected_abi}" ]]; then
		die "SLOT ${SLOT} doesn't match upstream specified ABI ${detected_abi}."
	fi

	local detected_proto_ver
	detected_proto_ver="$(sed -n -e '/^opentelemetry-proto=/p' third_party_release)"
	if [[ "${OPENTELEMETRY_PROTO}" != "${detected_proto_ver#opentelemetry-proto=v}" ]]; then
		die "OPENTELEMETRY_PROTO=${OPENTELEMETRY_PROTO} doesn't match upstream specified ${detected_proto_ver}"
	fi

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DWITH_BENCHMARK=OFF # benchmark tests dont make sense in ebuilds
		-DBUILD_W3CTRACECONTEXT_TEST=OFF # network-sandbox breaking tests
		-DWITH_FUNC_TESTS=ON

		-DOTELCPP_VERSIONED_LIBS=ON
		-DOTELCPP_MAINTAINER_MODE=OFF
		-DOPENTELEMETRY_INSTALL=ON
		# Modifies ABI and some project expect the non C++ std reliant ABI specifically
		-DWITH_STL=OFF
		-DWITH_GSL=OFF

		-DWITH_API_ONLY=OFF

		-DWITH_CONFIGURATION=OFF # experimental, vendored rapidyaml

		-DWITH_ELASTICSEARCH=$(usex elasticsearch)
		-DWITH_PROMETHEUS=$(usex prometheus)
		-DWITH_OPENTRACING=OFF # unpackaged
		-DWITH_ZIPKIN=OFF # unpackaged
		-DWITH_ETW=OFF # unpackaged

		# https://github.com/open-telemetry/opentelemetry-cpp/blob/main/exporters/otlp/README.md
		# file exporter can be built separately to the other exporter.
		# Its just simpler dependency wise to have a "otlp" use flag that the other exporter require.
		-DWITH_OTLP_FILE=$(usex otlp)
		-DWITH_OTLP_GRPC=$(usex grpc)
		-DWITH_OTLP_HTTP=$(usex http)
		-DWITH_OTLP_HTTP_COMPRESSION=ON # zlib is in the system set
	)
	use otlp && mycmakeargs+=( -DOTELCPP_PROTO_PATH="${WORKDIR}"/opentelemetry-proto-${OPENTELEMETRY_PROTO} )

	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# needs a running prometheus instance
		exporter.PrometheusExporter.ShutdownSetsIsShutdownToTrue
	)

	# curl tests fragile
	cmake_src_test -j1
}
