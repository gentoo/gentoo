# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake verify-sig

DESCRIPTION="C++ Driver for MongoDB"
HOMEPAGE="
	https://www.mongodb.com/docs/drivers/cxx/
	https://github.com/mongodb/mongo-cxx-driver
"
SRC_URI="
	https://github.com/mongodb/mongo-cxx-driver/releases/download/r${PV}/mongo-cxx-driver-r${PV}.tar.gz
	verify-sig? (
		https://github.com/mongodb/mongo-cxx-driver/releases/download/r${PV}/mongo-cxx-driver-r${PV}.tar.gz.asc
	)
"
S="${WORKDIR}/mongo-cxx-driver-r${PV}"


LICENSE="Apache-2.0"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="test test-full"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/mongo-c-driver:2
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/catch:0 )
"
BDEPEND="
	${PYTHON_DEPS}
	test-full? ( dev-db/mongodb )
	verify-sig? ( sec-keys/openpgp-keys-mongo-cxx-driver )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/mongo-cxx-driver.asc

src_prepare() {
	cmake_src_prepare

	sed -e 's/fetch_catch2()/find_package(Catch2 REQUIRED)/' -i cmake/FetchCatch2.cmake || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DENABLE_TESTS=$(usex test)
		-DNEED_DOWNLOAD_C_DRIVER=OFF
	)
	cmake_src_configure
}

src_test() {
	# https://www.mongodb.com/docs/languages/cpp/cpp-driver/current/testing/
	local CMAKE_SKIP_TESTS=()
	if use test-full; then
		mongod --setParameter enableTestCommands=1 \
			--fork --dbpath="${T}" --logpath="${T}/mongod.log" || die
	else
		CMAKE_SKIP_TESTS+=(
			command_monitoring_specs
			crud_specs
			driver
			gridfs_specs
			read_write_concern_specs
			versioned_api
			retryable_reads_specs
			transactions_specs
			unified_format_specs
		)
	fi

	# parallel tests cause failures.
	cmake_src_test -j1

	if use test-full; then
		kill $(<"${T}/mongod.lock")
	fi
}
