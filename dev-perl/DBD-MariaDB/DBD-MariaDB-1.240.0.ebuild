# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PALI
DIST_VERSION=1.24
DIST_WIKI=tests
inherit perl-module

DESCRIPTION="MariaDB and MySQL driver for the Perl5 Database Interface (DBI)"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~mips ppc ~ppc64 ~riscv ~s390 x86"
IUSE="+mariadb mysql minimal"
REQUIRED_USE="^^ ( mysql mariadb )"

RDEPEND="
	>=dev-perl/DBI-1.608.0
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:= )
"
DEPEND="
	mysql? ( dev-db/mysql-connector-c:= )
	mariadb? ( dev-db/mariadb-connector-c:= )
"
# New test-harness needed for parallel testing to work
BDEPEND="
	${RDEPEND}
	>=dev-perl/Devel-CheckLib-1.120.0
	test? (
		!minimal? (
			>=dev-perl/Net-SSLeay-1.430.0
			dev-perl/Proc-ProcessTable
		)
		mariadb? ( dev-db/mariadb:* )
		mysql? ( dev-db/mysql:* )
		dev-perl/Test-Deep
		>=virtual/perl-Test-Harness-3.310.0
		>=virtual/perl-Test-Simple-0.900.0
	)
"

PERL_RM_FILES=(
	"t/pod.t"
	"t/manifest.t"
)

src_configure() {
	local impl=$(usex mariadb mariadb mysql)

	# These must be set at configure time
	export DBD_MARIADB_TESTDB=test
	export DBD_MARIADB_TESTSOCKET="${T}"/mysqld.sock
	export DBD_MARIADB_TESTAUTHPLUGIN=mysql_native_password
	export DBD_MARIADB_TESTUSER=root

	myconf=( --${impl}_config="${BROOT}"/usr/bin/${impl}_config )

	perl-module_src_configure
}

src_test() {
	local -x USER=$(whoami)

	einfo "Creating mysql test instance ..."
	mkdir -p "${T}"/mysql || die
	if use mariadb ; then
		local -x PATH="${BROOT}/usr/share/mariadb/scripts:${PATH}"

		mysql_install_db \
			--no-defaults \
			--auth-root-authentication-method=normal \
			--basedir="${EPREFIX}/usr" \
			--datadir="${T}"/mysql 1>"${T}"/mysqld_install.log || die
	else
		mysqld \
			--no-defaults \
			--initialize-insecure \
			--user ${USER} \
			--basedir="${EPREFIX}/usr" \
			--datadir="${T}"/mysql 1>"${T}"/mysqld_install.log || die
	fi

	einfo "Starting mysql test instance ..."
	mysqld \
		--no-defaults \
		--character-set-server=utf8 \
		--bind-address=127.0.0.1 \
		--pid-file="${T}"/mysqld.pid \
		--socket="${T}"/mysqld.sock \
		--datadir="${T}"/mysql 1>"${T}"/mysqld.log 2>&1 &

	# Wait for it to start
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] && break
		sleep 1
	done
	[[ ! -S ${T}/mysqld.sock ]] && die "mysqld failed to start"

	einfo "Configuring test mysql instance ..."
	mysql -u root \
		-e 'CREATE DATABASE /*M!50701 IF NOT EXISTS */ test' \
		-S "${T}"/mysqld.sock || die "Failed to create test database"

	# Don't be a hero and try to do EXTENDED_TESTING=1 unless you can figure
	# out why 60leaks.t fails
	nonfatal perl-module_src_test
	ret=$?

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
