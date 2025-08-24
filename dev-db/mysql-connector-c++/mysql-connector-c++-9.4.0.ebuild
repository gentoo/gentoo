# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

URI_DIR="Connector-C++"
DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
SRC_URI="
	https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}-src.tar.gz
"
S="${WORKDIR}/${P}-src"

LICENSE="Artistic GPL-2"
# See ABI_VERSION(s) is version.cmake
SLOT="0/2.10" # ABI_VERSION_MAJOR/JDBC_ABI_VERSION_MAJOR
# -ppc, -sparc for bug #711940
KEYWORDS="~amd64 ~arm ~arm64 -ppc ~ppc64 -sparc ~x86"
IUSE="+legacy test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/openssl:=
	sys-libs/zlib
	legacy? (
		>=dev-db/mysql-connector-c-8.0.27:=
	)
"
DEPEND="
	${RDEPEND}
	test? (
		dev-cpp/gtest
	)
"
BDEPEND="
	test? (
		>=dev-db/mysql-8[server]
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.27-mysqlclient_r.patch
	"${FILESDIR}"/${PN}-8.0.33-jdbc.patch
	"${FILESDIR}"/${PN}-9.2.0-gcc-15-cstdint.patch
	"${FILESDIR}"/${PN}-9.2.0-test-iomanip.patch
	"${FILESDIR}"/${PN}-9.4.0-hookup-tests.patch
	"${FILESDIR}"/${PN}-9.4.0-cmake4.patch
)

src_prepare() {
	cmake_src_prepare

	# ignores MAKEOPTS and runs recursive make -j$(nproc). Clobbers jobs badly
	# enough that your system immediately freezes.
	#
	# https://bugs.gentoo.org/921309
	# https://bugs.mysql.com/bug.php?id=115734
	sed -i 's/prc_cnt AND NOT/FALSE AND NOT/' cdk/cmake/dependency.cmake || die
}

src_configure() {
	# sanity check subslot to kick would be drive by bumpers
	local detected_abi
	detected_abi="$(awk '$1 ~ "set.*ABI_VERSION_MAJOR" {printf("%s.",$2)}' version.cmake)"
	detected_abi="${detected_abi%.}"
	if [[ "${SLOT#0/}" != "${detected_abi}" ]]; then
		die "Sub slot ${SLOT#0/} doesn't match upstream specified ABI ${detected_abi}."
	fi

	local mycmakeargs=(
		-DBUNDLE_DEPENDENCIES=OFF
		# Cannot handle protobuf >23, bug #912797
		#-DWITH_PROTOBUF=system
		-DWITH_LZ4=system
		-DWITH_SSL=system
		-DWITH_ZLIB=system
		-DWITH_ZSTD=system
		-DWITH_JDBC=$(usex legacy)
		-DWITH_TESTS=$(usex test)
	)

	if use legacy ; then
		mycmakeargs+=(
			-DMYSQLCLIENT_STATIC_BINDING=0
			-DMYSQLCLIENT_STATIC_LINKING=0
		)
	fi

	cmake_src_configure
}

# NOTE: Test failures in jdbc may be a sign of issues in mysql-connector-c.
src_test() {
	local CMAKE_SKIP_TESTS=(
		# Test that configures, builds and install a test project again. It gets caught on the install phase.
		Link_test
		# Only ipv4 will work as only the ipv4 local address is specified. A future task for someone...
		# https://dev.mysql.com/doc/refman/8.4/en/x-plugin-options-system-variables.html#sysvar_mysqlx_bind_address
		Sess.ipv6
		# FIXME:
		# not ok 15 - preparedstatement::queryAttributes # assertEquals(int) failed in
		# /var/tmp/portage/dev-db/mysql-connector-c++-9.2.0/work/mysql-connector-c++-9.2.0-src/jdbc/test/unit/classes/preparedstatement.cpp,
		# line #1582 expecting '200' got '0'
		jdbc_test_preparedstatement
	)

	local -x MYSQL_HOST="127.0.0.1"
	local -x MYSQL_PORT="5555"
	local -x MYSQL_USER="$(whoami)"
	local -x MYSQL_PASSWORD="insecure"
	local -x XPLUGIN_PORT="5556"

	einfo "Creating mysql test instance"
	mkdir -p "${T}"/mysql || die
	mysqld \
		--no-defaults \
		--initialize-insecure \
		--user root \
		--basedir="${EPREFIX}/usr" \
		--datadir="${T}"/mysql 1>"${T}"/mysqld_install.log || die

	einfo "Starting mysql test instance ..."
	mysqld \
		--no-defaults \
		--character-set-server=utf8 \
		--bind-address=${MYSQL_HOST} \
		--port=${MYSQL_PORT} \
		--socket="${T}"/mysqld.sock \
		--mysqlx-bind-address=${MYSQL_HOST} \
		--mysqlx-port=${XPLUGIN_PORT} \
		--mysqlx-socket="${T}"/mysqlx.sock \
		--pid-file="${T}"/mysqld.pid \
		--datadir="${T}"/mysql 1>"${T}"/mysqld.log 2>&1 &

	# wait for it to start
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] && break
		sleep 1
	done
	[[ ! -S ${T}/mysqld.sock ]] && die "mysqld failed to start"

	einfo "Configure mysql test instance ..."
	# https://github.com/mysql/mysql-connector-cpp/blob/trunk/jdbc/test/CJUnitTestsPort/README
	mysql -u root \
		-e "CREATE USER ${MYSQL_USER} IDENTIFIED BY '${MYSQL_PASSWORD}'; GRANT ALL PRIVILEGES ON *.* TO ${MYSQL_USER} WITH GRANT OPTION;" \
		-S "${T}/mysqld.sock" \
		-h ${MYSQL_HOST} \
		-P ${MYSQL_PORT} || die
	mysql -u root \
		-S "${T}/mysqld.sock" \
		-h ${MYSQL_HOST} \
		-P ${MYSQL_PORT} < "${S}"/jdbc/test/CJUnitTestsPort/cts.sql || die

	# Do tests with one job for proper clean up in database tests.
	nonfatal cmake_src_test -j1
	local ret=${?}

	einfo "Stopping mysql test instance ..."
	pkill -F "${T}"/mysqld.pid || die
	# wait for it to stop
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] || break
		sleep 1
	done

	rm -rf "${T}"/mysql || die

	[[ ${ret} -ne 0 ]] && die
}

src_install() {
	cmake_src_install
	einstalldocs

	# cmake package config file appears to be broken in multiple ways
	rm "${ED}/usr/mysql-concpp-config.cmake" || die
	rm "${ED}/usr/mysql-concpp-config-version.cmake" || die
}
