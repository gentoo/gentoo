# Copyright 2022 Gentoo Authors
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
KEYWORDS="~amd64 ~arm64"
IUSE="+jaeger prometheus test"

RDEPEND="
	net-misc/curl:=
	dev-libs/thrift:=
	dev-libs/boost:=
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
		dev-cpp/benchmark
	)
"

RESTRICT="!test? ( test )"

PATCHES=(
	# remove tests the need network
	"${FILESDIR}/opentelemetry-cpp-1.3.0-tests.patch"
)

src_configure() {
	local -a mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
		-DWITH_JAEGER:BOOL=$(usex jaeger)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
	)

	cmake_src_configure
}
