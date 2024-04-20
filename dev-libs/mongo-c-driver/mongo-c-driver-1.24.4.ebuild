# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Client library written in C for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~riscv ~x86"
IUSE="debug examples icu sasl ssl static-libs test"
REQUIRED_USE="test? ( static-libs )"

# No tests on x86 because tests require dev-db/mongodb which don't support
# x86 anymore (bug #645994)
RESTRICT="x86? ( test )
	!test? ( test )"

RDEPEND="app-arch/snappy:=
	app-arch/zstd:=
	>=dev-libs/libbson-${PV}[static-libs?]
	dev-python/sphinx
	sys-libs/zlib:=
	icu? ( dev-libs/icu:= )
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? (
		dev-libs/openssl:=
	)"
DEPEND="${RDEPEND}
	test? (
		dev-db/mongodb
		dev-libs/libbson[static-libs]
	)"

src_prepare() {
	cmake_src_prepare

	# copy private headers for tests since we don't build libbson
	if use test; then
		mkdir -p src/libbson/tests/bson || die
		cp src/libbson/src/bson/bson-*.h src/libbson/tests/bson/ || die
	fi

	# remove doc files
	sed -i '/^\s*install\s*(FILES COPYING NEWS/,/^\s*)/{d}' CMakeLists.txt || die

	# enable tests
	sed -i '/message ("--   disabling test-libmongoc since using system libbson")/{d}' CMakeLists.txt || die
	sed -i '/SET (ENABLE_TESTS OFF)/{d}' CMakeLists.txt || die
	sed -i 's/message (FATAL_ERROR "System libbson built without static library target")/message (STATUS "System libbson built without static library target")/' CMakeLists.txt || die
	sed -i 's#<bson/bson-private.h>#"bson/bson-private.h"#' src/libbson/tests/test-bson.c || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # mongoc-stat insecure runpath
		-DUSE_SYSTEM_LIBBSON=ON
		-DENABLE_EXAMPLES=OFF
		-DENABLE_ICU="$(usex icu ON OFF)"
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MONGOC=ON
		-DENABLE_SNAPPY=AUTO
		-DENABLE_ZLIB=SYSTEM
		-DENABLE_SASL="$(usex sasl CYRUS OFF)"
		-DENABLE_SSL="$(usex ssl $(usex ssl OPENSSL) OFF)"
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_TESTS="$(usex test ON OFF)"
		-DENABLE_TRACING="$(usex debug ON OFF)"
		-DENABLE_UNINSTALL=OFF
		-DENABLE_ZSTD=ON
	)

	cmake_src_configure
}

# FEATURES="test -network-sandbox" USE="static-libs" emerge dev-libs/mongo-c-driver
src_test() {
	local PORT=27099
	mongod --port ${PORT} --bind_ip 127.0.0.1 --nounixsocket --fork \
		--dbpath="${T}" --logpath="${T}/mongod.log" || die
	MONGOC_TEST_URI="mongodb://[127.0.0.1]:${PORT}" ../mongo-c-driver-${PV}_build/src/libmongoc/test-libmongoc || die
	kill $(<"${T}/mongod.lock")
}

src_install() {
	if use examples; then
		docinto examples
		dodoc src/libmongoc/examples/*.c
	fi

	cmake_src_install
}
