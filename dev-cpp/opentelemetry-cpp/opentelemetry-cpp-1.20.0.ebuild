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
IUSE="prometheus test"

RDEPEND="
	net-misc/curl:=
	dev-libs/boost:=
"
DEPEND="
	${RDEPEND}
	prometheus? (
		dev-cpp/prometheus-cpp
	)
	test? (
		dev-cpp/gtest
		dev-cpp/benchmark
	)
"

RESTRICT="!test? ( test )"

PATCHES=(
	# remove tests the need network
	"${FILESDIR}/${PN}-1.5.0-tests.patch"
	"${FILESDIR}/${PN}-1.16.1-cstdint.patch"
	"${FILESDIR}/${PN}-1.16.1-fix-clang-template.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON
		-DBUILD_SHARED_LIBS:BOOL=ON
		-DBUILD_TESTING:BOOL=$(usex test)
		-DWITH_PROMETHEUS:BOOL=$(usex prometheus)
	)

	cmake_src_configure
}
