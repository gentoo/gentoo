# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="The OpenTelemetry C++ Client"
HOMEPAGE="
	https://opentelemetry.io/
	https://github.com/open-telemetry/opentelemetry-cpp
"
SRC_URI="https://github.com/open-telemetry/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE="+jaeger prometheus test"

RDEPEND="
	net-misc/curl:=
	dev-libs/thrift:=
	dev-libs/boost:=
	prometheus? ( dev-cpp/prometheus-cpp )
"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"

RESTRICT="!test? ( test )"

PATCHES=(
	# bug #865029
	"${FILESDIR}/opentelemetry-cpp-1.6.0-dont-install-nosend.patch"
	"${FILESDIR}/opentelemetry-cpp-1.6.0-cmake4.patch"
	"${FILESDIR}/opentelemetry-cpp-1.6.0-gcc13.patch"
	"${FILESDIR}/opentelemetry-cpp-1.6.0-add-benchmark-option.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING:BOOL=$(usex test)
		-DWITH_BENCHMARK=OFF # benchmark tests dont make sense in ebuilds
		-DBUILD_W3CTRACECONTEXT_TEST=OFF # network-sandbox breaking tests

		-DWITH_JAEGER=$(usex jaeger)
		-DWITH_PROMETHEUS=$(usex prometheus)
	)

	cmake_src_configure
}

src_test() {
	# curl tests fragile
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	if use prometheus; then
		sed '/^# Create imported target opentelemetry-cpp::prometheus_exporter/i\find_dependency(prometheus-cpp REQUIRED)\n' \
			-i "${ED}/usr/$(get_libdir)/cmake/opentelemetry-cpp/opentelemetry-cpp-target.cmake" || die
	fi
}
