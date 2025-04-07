# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} pypy3_11 )

inherit cmake python-any-r1

DESCRIPTION="Client library written in C for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~riscv ~x86"
IUSE="debug examples icu sasl ssl static-libs test +test-full"
REQUIRED_USE="test? ( static-libs )"

RESTRICT="!test? ( test )"

RDEPEND="app-arch/snappy:=
	app-arch/zstd:=
	~dev-libs/libbson-${PV}[static-libs?]
	dev-python/sphinx
	sys-libs/zlib:=
	icu? ( dev-libs/icu:= )
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? (
		dev-libs/openssl:=
	)"
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/libbson[static-libs]
		test-full? (
			dev-db/mongodb
		)
	)
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
"

python_check_deps() {
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]"
}

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
	sed -i '/message (STATUS "disabling test-libmongoc since using system libbson")/{d}' CMakeLists.txt || die
	sed -i '/SET (ENABLE_TESTS OFF)/{d}' CMakeLists.txt || die
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
		-DENABLE_SNAPPY=ON
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

src_test() {
	export MONGOC_TEST_OFFLINE=on
	export MONGOC_TEST_SKIP_MOCK=on
	echo "/Samples" >> "${T}/skip-tests.txt"
	if ! use test-full; then
		export MONGOC_TEST_SKIP_LIVE=on
	else
		local PORT=27099
		export MONGOC_TEST_URI="mongodb://[127.0.0.1]:${PORT}"
		export MONGOC_ENABLE_MAJORITY_READ_CONCERN=on
		LC_ALL=C \
			mongod --setParameter enableTestCommands=1 \
			--port ${PORT} --bind_ip 127.0.0.1 --nounixsocket \
			--fork --dbpath="${T}"\
			--logpath="${T}/mongod.log" || die
	fi

	../mongo-c-driver-${PV}_build/src/libmongoc/test-libmongoc \
	--skip-tests "${T}/skip-tests.txt" || die
	if use test-full; then
		kill $(<"${T}/mongod.lock")
	fi

}

src_install() {
	if use examples; then
		docinto examples
		dodoc src/libmongoc/examples/*.c
	fi

	cmake_src_install
}
