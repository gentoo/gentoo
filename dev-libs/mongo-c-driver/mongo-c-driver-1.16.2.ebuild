# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Client library written in C for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~s390 ~x86"
IUSE="debug examples icu libressl sasl ssl static-libs test"
REQUIRED_USE="test? ( static-libs )"

RDEPEND="app-arch/snappy:=
	app-arch/zstd:=
	>=dev-libs/libbson-${PV}[static-libs?]
	dev-python/sphinx
	sys-libs/zlib:=
	icu? ( dev-libs/icu:= )
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}
	test? (
		dev-db/mongodb
		dev-libs/libbson[static-libs]
	)"

# No tests on x86 because tests require dev-db/mongodb which don't support
# x86 anymore (bug #645994)
RESTRICT="x86? ( test )
	!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-1.14.0-no-docs.patch"
	"${FILESDIR}/${PN}-1.16.2-enable-tests.patch" # enable tests with system libbson
	"${FILESDIR}/${PN}-1.16.2-single-doc-job.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	# copy private headers for tests since we don't build libbson
	if use test; then
		mkdir -p src/libbson/tests/bson || die
		cp src/libbson/src/bson/bson-*.h src/libbson/tests/bson/ || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # mongoc-stat insecure runpath
		-DENABLE_BSON=SYSTEM
		-DENABLE_EXAMPLES=OFF
		-DENABLE_ICU="$(usex icu ON OFF)"
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MONGOC=ON
		-DENABLE_SNAPPY=SYSTEM
		-DENABLE_ZLIB=SYSTEM
		-DENABLE_SASL="$(usex sasl CYRUS OFF)"
		-DENABLE_SSL="$(usex ssl $(usex libressl LIBRESSL OPENSSL) OFF)"
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_TESTS="$(usex test ON OFF)"
		-DENABLE_TRACING="$(usex debug ON OFF)"
		-DENABLE_UNINSTALL=OFF
		-DENABLE_ZSTD=ON
	)

	cmake-utils_src_configure
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

	cmake-utils_src_install
}
