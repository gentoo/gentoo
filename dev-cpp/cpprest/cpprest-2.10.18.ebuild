# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="REST SDK using an asynchronous C++ API design"
HOMEPAGE="https://github.com/Microsoft/cpprestsdk"
SRC_URI="https://github.com/microsoft/cpprestsdk/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/cpprestsdk-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="brotli test +websockets"

RDEPEND="
	|| (
		<dev-libs/boost-1.77.0[nls,threads]
		>=dev-libs/boost-1.77.0[nls]
	)
	dev-libs/openssl
	sys-libs/zlib
	brotli? ( app-arch/brotli )
	websockets? ( dev-cpp/websocketpp )
"
DEPEND="${RDEPEND}"

RESTRICT="!test? ( test )"

src_prepare() {
	my_disable_tests() {
		local my_cmake_file="${1}"
		local -n my_tests="${2}"

		for file in "${my_tests[@]}"; do
			sed -i "/${file}/d" "Release/tests/${my_cmake_file}" || die
		done
	}

	local -a my_http_client_tests=(
		"authentication_tests.cpp"
		"connections_and_errors.cpp"
		"outside_tests.cpp"
		"redirect_tests.cpp"
	)
	my_disable_tests "functional/http/client/CMakeLists.txt" my_http_client_tests

	local -a my_websockets_tests=(
		"authentication_tests.cpp"
	)
	my_disable_tests "functional/websockets/CMakeLists.txt" my_websockets_tests

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		"-DWERROR=OFF"
		"-DBUILD_SAMPLES=OFF"
		"-DCPPREST_EXCLUDE_WEBSOCKETS=$(usex websockets OFF ON)"
		"-DBUILD_TESTS=$(usex test ON OFF)"
		"-DCPPREST_EXCLUDE_BROTLI=$(usex brotli OFF ON)"
	)

	cmake_src_configure
}
