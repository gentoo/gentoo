# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DVEEDEN
# Parallel testing is broken as 2 tests create the same table
# and mysql isn't acid compliant and can't limit visibility of tables
# to a transaction...
DIST_TEST="do"
DIST_WIKI=tests
DIST_VERSION=5.007
inherit perl-module

DESCRIPTION="MySQL driver for the Perl5 Database Interface (DBI)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="mariadb +mysql test"
RESTRICT="!test? ( test )"
REQUIRED_USE="^^ ( mysql mariadb )"

DB_DEPENDS="
	mysql? ( >=dev-db/mysql-connector-c-8:= )
	mariadb? ( >=dev-db/mariadb-connector-c-3.1:=[ssl(+)] )
"
RDEPEND="
	>=dev-perl/DBI-1.609.0
	>=dev-perl/Devel-CheckLib-1.109.0
	${DB_DEPENDS}
"
DEPEND="
	${DB_DEPENDS}
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Data-Dumper
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.900.0
		virtual/perl-Time-HiRes
		mariadb? ( dev-db/mariadb:* )
		mysql? ( >=dev-db/mysql-8:* )
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-4.050-no-dot-inc.patch"
)

PERL_RM_FILES=(
	t/pod.t
	t/manifest.t

	#   Failed test 'USE is not supported with mysql_server_prepare_disable_fallback=1'
	#   at t/40server_prepare.t line 93.
	t/40server_prepare.t
)

src_configure() {
	local impl=$(usex mariadb mariadb mysql)
	local myconf=()

	if use test; then
		myconf+=(
			--testdb=test
			--testhost=localhost
			--testsocket="${T}"/mysqld.sock
			--testuser=root
		)
	fi

	myconf+=( --mysql_config="${EPREFIX}"/usr/bin/${impl}_config )

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
