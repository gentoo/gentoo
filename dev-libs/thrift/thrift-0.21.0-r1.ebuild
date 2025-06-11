# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ bindings for Apache Thrift"
HOMEPAGE="https://thrift.apache.org/lib/cpp.html"
# Misses testing files
# SRC_URI="mirror://apache/thrift/${PV}/${P}.tar.gz"
SRC_URI="
	https://github.com/apache/thrift/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc64 ~riscv ~s390 ~x86"

IUSE="libevent lua +ssl test"
REQUIRED_USE="test? ( ssl libevent )"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/boost:=[nls(+)]
	dev-libs/openssl:=
	sys-libs/zlib:=
	libevent? ( dev-libs/libevent:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
"

PATCHES=(
	"${FILESDIR}/thrift-0.21.0-gcc15-cstdint.patch"
	"${FILESDIR}/thrift-0.21.0-cmake4.patch"
)

src_configure() {
	local mycmakeargs=(
		# follow order in build/cmake/DefineOptions.cmake
		# Prefer WITH_OPTION over BUILD_OPTION for bug #943012
		-DBUILD_COMPILER=ON
		-DBUILD_TESTING=$(usex test)
		-DBUILD_TUTORIALS=OFF
		-DBUILD_LIBRARIES=ON
		-DWITH_AS3=ON
		-DWITH_CPP=ON
		-DWITH_ZLIB=ON
		-DWITH_LIBEVENT=$(usex libevent)
		-DWITH_QT5=OFF
		-DWITH_C_GLIB=OFF
		-DWITH_OPENSSL=$(usex ssl)
		-DWITH_JAVA=OFF
		-DWITH_JAVASCRIPT=OFF
		-DWITH_NODEJS=OFF
		-DWITH_PYTHON=OFF
		-Wno-dev
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# network sandbox
		StressTestConcurrent
		StressTestNonBlocking
		UnitTests
	)
	cmake_src_test
}
