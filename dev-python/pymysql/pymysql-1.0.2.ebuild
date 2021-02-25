# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )

inherit distutils-r1

MY_PN="PyMySQL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pure-Python MySQL Driver"
HOMEPAGE="https://github.com/PyMySQL/PyMySQL"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

# TODO: support other mysql variants
BDEPEND="
	test? (
		dev-db/mariadb[server]
	)"

distutils_enable_tests pytest

src_prepare() {
	# Auth tests don't support socket auth
	find tests/ -name '*_auth.py' -delete || die

	distutils-r1_src_prepare
}

src_test() {
	if [[ -z "${USER}" ]] ; then
		# Tests require system user
		local -x USER="$(whoami)"
		einfo "USER set to '${USER}'"
	fi

	local PIDFILE="${T}/mysqld.pid"
	if pkill -0 -F "${PIDFILE}" &>/dev/null ; then
		einfo "Killing already running mysqld process ..."
		pkill -F "${PIDFILE}"
	fi

	if [[ -d "${T}/mysql" ]] ; then
		einfo "Removing already existing mysqld data dir ..."
		rm -rf "${T}/mysql" || die
	fi

	einfo "Creating mysql test instance ..."
	mkdir -p "${T}"/mysql || die
	"${BROOT}"/usr/share/mariadb/scripts/mysql_install_db \
		--no-defaults \
		--auth-root-authentication-method=normal \
		--basedir="${BROOT}/usr" \
		--datadir="${T}"/mysql 1>"${T}"/mysqld_install.log \
		|| die

	einfo "Starting mysql test instance ..."
	# TODO: random port
	mysqld \
		--no-defaults \
		--character-set-server=utf8 \
		--bind-address=127.0.0.1 \
		--port=43306 \
		--pid-file="${T}"/mysqld.pid \
		--socket="${T}"/mysqld.sock \
		--datadir="${T}"/mysql 1>"${T}"/mysqld.log 2>&1 &

	# wait for it to start
	local i
	for (( i = 0; i < 10; i++)); do
		[[ -S ${T}/mysqld.sock ]] && break
		sleep 1
	done
	[[ -S ${T}/mysqld.sock ]] || die "mysqld failed to start"

	einfo "Configuring test mysql instance ..."

	# create test user for auth tests
	mysql -uroot --socket="${T}"/mysqld.sock -s -e '
		INSTALL SONAME "auth_ed25519";
		CREATE FUNCTION ed25519_password RETURNS STRING SONAME "auth_ed25519.so";
	' || die "Failed to set up auth_ed25519"

	mysql -uroot --socket="${T}"/mysqld.sock -s -e "
		SELECT CONCAT('CREATE USER nopass_ed25519 IDENTIFIED VIA ed25519 USING \"',ed25519_password(\"\"),'\";');
		SELECT CONCAT('CREATE USER user_ed25519 IDENTIFIED VIA ed25519 USING \"',ed25519_password(\"pass_ed25519\"),'\";');
	" || die "Failed to create ed25519 test users"

	# create test databases
	mysql -uroot --socket="${T}"/mysqld.sock -s -e '
		create database test1 DEFAULT CHARACTER SET utf8mb4;
		create database test2 DEFAULT CHARACTER SET utf8mb4;

		create user test2 identified by "some password";
		grant all on test2.* to test2;

		create user test2@localhost identified by "some password";
		grant all on test2.* to test2@localhost;
	' || die "Failed to create test databases"

	cat > pymysql/tests/databases.json <<-EOF || die
		[{
			"host": "localhost",
			"user": "root",
			"password": "",
			"database": "test1",
			"use_unicode": true,
			"local_infile": true,
			"unix_socket": "${T}/mysqld.sock"
		}, {
			"host": "localhost",
			"user": "root",
			"password": "",
			"database": "test2",
			"unix_socket": "${T}/mysqld.sock"
		}]
	EOF

	distutils-r1_src_test

	if pkill -0 -F "${PIDFILE}" &>/dev/null ; then
		einfo "Stopping mysql test instance ..."
		pkill -F "${PIDFILE}"
	fi
}

python_test() {
	local excludes=(
		# requires some dialog plugin
		pymysql/tests/test_connection.py::TestAuthentication::testDialogAuthThreeAttemptsQuestionsInstallPlugin
		pymysql/tests/test_connection.py::TestAuthentication::testDialogAuthTwoQuestionsInstallPlugin
	)

	PYTHONPATH=. pytest -vv ${excludes[@]/#/--deselect } ||
		die "Tests failed with ${EPYTHON}"
}
