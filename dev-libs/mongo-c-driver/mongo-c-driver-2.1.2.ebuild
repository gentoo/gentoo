# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit cmake dot-a python-any-r1 verify-sig

DESCRIPTION="Client library written in C for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver"
SRC_URI="
	https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/${P}.tar.gz
	verify-sig? (
		https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/${P}.tar.gz.asc
	)
"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~riscv ~x86"

IUSE="debug examples sasl ssl static-libs test +test-full"
REQUIRED_USE="test? ( static-libs )"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/snappy:=
	app-arch/zstd:=
	dev-python/sphinx
	sys-libs/zlib:=
	sasl? ( dev-libs/cyrus-sasl:= )
	ssl? (
		dev-libs/openssl:=
	)"
DEPEND="
	${RDEPEND}
	test? (
		test-full? (
			dev-db/mongodb
		)
	)
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
	')
	verify-sig? ( sec-keys/openpgp-keys-mongo-c-driver )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/mongo-c-driver.asc

python_check_deps() {
	python_has_version -b "dev-python/sphinx[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	# install doc files into the right location
	sed -e "/^install/,/^)$/ s|DESTINATION \${CMAKE_INSTALL_DATADIR}/mongo-c-driver/\${PROJECT_VERSION}|DESTINATION \${CMAKE_INSTALL_DATADIR}/doc/${PF}|" -i CMakeLists.txt || die
}

src_configure() {
	lto-guarantee-fat

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DCMAKE_SKIP_RPATH=ON # mongoc-stat insecure runpath
		-DENABLE_EXAMPLES=OFF
		-DENABLE_MAN_PAGES=OFF
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
		# Install test
		"mongoc/CMake/*"
		"mongoc/pkg-config/*"
		# FIXME
		# assertion failed: saw_other
		"mongoc/bson/dsl/predicate"
		# Condition 'count <= 1' failed.
		"mongoc/Client/ipv6/single"
		# error: "Failed to connect to: localhost"
		"mongoc/azure/imds/http/talk"
		"mongoc/gcp/http/talk"
	)

	export MONGOC_TEST_OFFLINE=on
	export MONGOC_TEST_SKIP_MOCK=on
	if ! use test-full; then
		export MONGOC_TEST_SKIP_LIVE=on
		CMAKE_SKIP_TESTS+=(
			"mongoc/ClientPool/openssl/change_ssl_opts"
		)
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
	cmake_src_install
	strip-lto-bytecode

	if use examples; then
		docinto examples
		dodoc src/libmongoc/examples/*.c
	fi
}
