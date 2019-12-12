# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Client library written in C for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="https://github.com/mongodb/mongo-c-driver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~s390 ~x86"
IUSE="debug examples libressl sasl ssl static-libs test"
REQUIRED_USE="test? ( static-libs )"

RDEPEND="app-arch/snappy:=
	>=dev-libs/libbson-1.10.3
	dev-python/sphinx
	sys-libs/zlib:=
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
RESTRICT="!test? ( test ) x86? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-enable-tests.patch" # enable tests without libbson
)

src_prepare() {
	cmake-utils_src_prepare

	# copy private headers for tests since we don't build libbson
	if use test; then
		for f in bson-private.h bson-iso8601-private.h bson-thread-private.h; do
			cp -v src/libbson/src/bson/${f} src/libbson/tests/ || die
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # mongoc-stat insecure runpath
		-DENABLE_BSON=SYSTEM
		-DENABLE_EXAMPLES=OFF
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MONGOC=ON
		-DENABLE_SNAPPY=SYSTEM
		-DENABLE_ZLIB=SYSTEM
		-DENABLE_SASL="$(usex sasl CYRUS OFF)"
		-DENABLE_SSL="$(usex ssl $(usex libressl LIBRESSL OPENSSL) OFF)"
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_TESTS="$(usex test ON OFF)"
		-DENABLE_TRACING="$(usex debug ON OFF)"
	)

	cmake-utils_src_configure
}

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
