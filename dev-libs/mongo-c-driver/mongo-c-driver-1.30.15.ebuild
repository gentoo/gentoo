# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-cmake-docs as a template
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${MONGO_C_DRIVER_DOCS_PREBUILT:=1}

# Default to generating man pages if no prebuilt; overridden later
MONGO_C_DRIVER_DOCS_USEFLAG="+man"
MONGO_C_DRIVER_DOCS_PV=1.30.6

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/mongo-c-driver.asc

PYTHON_COMPAT=( python3_{12..15} )

inherit cmake dot-a python-any-r1 verify-sig

DESCRIPTION="Client library written in C for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="
	https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/${P}.tar.gz
	verify-sig? (
		https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/mongo-c-driver-${PV}.tar.gz.asc
	)
"

if [[ ${MONGO_C_DRIVER_DOCS_PREBUILT} == 1 ]] ; then
	SRC_URI+=" !man? ( https://people.znc.in/~dessa/gentoo/distfiles/${CATEGORY}/${PN}/${PN}-${MONGO_C_DRIVER_DOCS_PV}-docs.tar.xz )"
	MONGO_C_DRIVER_DOCS_USEFLAG="man"
fi

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~riscv ~x86"
IUSE="debug examples ${MONGO_C_DRIVER_DOCS_USEFLAG} sasl +ssl static-libs test +test-full"
REQUIRED_USE="
	test? ( static-libs )"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/snappy:=
	app-arch/zstd:=
	~dev-libs/libbson-${PV}[static-libs?]
	dev-libs/libutf8proc:=
	virtual/zlib:=
	sasl? (
		dev-libs/cyrus-sasl:=
		>=dev-libs/libutf8proc-2.8.0:=[static-libs?]
	)
	ssl? ( dev-libs/openssl:= )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/libbson[static-libs]
		sasl? (
			dev-libs/libutf8proc[static-libs]
		)
		test-full? (
			dev-db/mongodb
		)
	)
"

BDEPEND="
	man? (
		$(python_gen_any_dep '
			dev-python/docutils[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
	verify-sig? ( sec-keys/openpgp-keys-mongo-c-driver )
"

PATCHES=(
	"${FILESDIR}"/mongo-c-driver-1.30.6-cmake4.patch

	"${FILESDIR}"/0001-CDRIVER-6308-Fix-OpenSSL-4.0.0-forward-compatibility.patch
	"${FILESDIR}"/0002-CDRIVER-6319-Improve-handling-EAGAIN-errors-in-OpenS.patch
)

python_check_deps() {
	python_has_version -b \
		"dev-python/docutils[${PYTHON_USEDEP}]" \
		"dev-python/sphinx[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use man && python-any-r1_pkg_setup
}

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi
	default
}

src_prepare() {
	cmake_src_prepare

	# copy private headers for tests since we don't build libbson
	if use test; then
		mkdir -p src/libbson/tests/bson || die
		cp src/libbson/src/bson/bson-*.h src/libbson/tests/bson/ || die
		cp src/libbson/src/bson/validate-private.h src/libbson/tests/bson/ || die
	fi

	# remove doc files
	sed -i '/^\s*install\s*(FILES COPYING NEWS/,/^\s*)/{d}' CMakeLists.txt || die

	# enable tests
	sed -i '/message (STATUS "disabling test-libmongoc since using system libbson")/{d}' CMakeLists.txt || die
	sed -i '/SET (ENABLE_TESTS OFF)/{d}' CMakeLists.txt || die
	sed -i 's#<bson/bson-private.h>#"bson/bson-private.h"#' src/libbson/tests/test-bson.c || die
	sed -i 's#<bson/validate-private.h>#"bson/validate-private.h"#' src/libbson/tests/test-bson.c || die
	sed -i 's#<bson/bson-iso8601-private.h>#"bson/bson-iso8601-private.h"#' src/libbson/tests/test-iso8601.c || die
	sed -i 's#<bson/bson-iso8601-private.h>#"bson/bson-iso8601-private.h"#' src/libbson/tests/test-json.c || die
	sed -i 's#<bson/bson-json-private.h>#"bson/bson-json-private.h"#' src/libbson/tests/test-json.c || die
	sed -i 's#<bson/bson-context-private.h>#"bson/bson-context-private.h"#' src/libbson/tests/test-oid.c || die
	sed -i 's#<bson/bson-iso8601-private.h>#"bson/bson-iso8601-private.h"#' src/libbson/tests/test-oid.c || die

	# bug 953521
	sed -i 's/message (FATAL_ERROR "System libbson built without static library target")/message (STATUS "System libbson built without static library target")/' CMakeLists.txt || die
}

src_configure() {
	use static-libs && lto-guarantee-fat
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON # mongoc-stat insecure runpath
		-DUSE_SYSTEM_LIBBSON=ON
		-DENABLE_CLIENT_SIDE_ENCRYPTION=OFF
		-DENABLE_EXAMPLES=OFF
		-DENABLE_MAN_PAGES="$(usex man ON OFF)"
		-DENABLE_MONGOC=ON
		-DENABLE_MONGODB_AWS_AUTH=OFF
		-DENABLE_SNAPPY=ON
		-DENABLE_ZLIB=SYSTEM
		-DENABLE_SASL="$(usex sasl CYRUS OFF)"
		-DENABLE_SRV=ON
		-DENABLE_SSL="$(usex ssl $(usex ssl OPENSSL) OFF)"
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_TESTS="$(usex test ON OFF)"
		-DENABLE_TRACING="$(usex debug ON OFF)"
		-DENABLE_UNINSTALL=OFF
		-DENABLE_ZSTD=ON
		-DUSE_BUNDLED_UTF8PROC=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use test; then
		cmake_build mongo_c_driver_tests
		cmake_build mongo_c_driver_examples
	fi
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		# FIXME needs setup
		"mongoc/fixtures/fake_kms_provider_server/start"
		# segfaults
		"mongoc/Topology/invalidate_server/*"
		# times out if -network-sandbox
		"mongoc/Topology/detect_nongenuine_hosts"
		# needs certificates
		"mongoc/unified/kmsProviders*"
		# needs certificates + running daemon
		"mongoc/ClientPool/openssl/change_ssl_opts"
		# Assert Failure: 3 == 1
		"mongoc/TLS/commonName"
		# depends on AWS
		"mongoc/client_side_encryption/unified/*"
		# Install test
		"mongoc/CMake/*"
		"mongoc/pkg-config/*"
		# Condition 'count <= 1' failed.
		"mongoc/Client/ipv6/single"
		# error: "Failed to connect to: localhost"
		"mongoc/azure/imds/http/talk"
		"mongoc/gcp/http/talk"
	)
	export MONGOC_TEST_OFFLINE=on
	export MONGOC_TEST_SKIP_MOCK=on
	if ! use test-full; then
		export MONGOC_TEST_SKIP_SLOW=on
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

	# parallel tests cause failures.
	cmake_src_test -j1
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
	strip-lto-bytecode

	# If USE=man, there'll be newly generated docs which we install instead.
	if ! use man && [[ ${MONGO_C_DRIVER_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${MONGO_C_DRIVER_DOCS_PV}-docs/man*/*.[0-8]
	fi
}
