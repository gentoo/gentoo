# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1

MY_PN="PyMySQL"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pure-Python MySQL Driver"
HOMEPAGE="https://github.com/PyMySQL/PyMySQL"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

# TODO: support other mysql variants
BDEPEND="
	test? ( dev-db/mariadb[server] )"

src_prepare() {
	find -name '*.py' -exec sed -i -e 's:unittest2:unittest:' {} + || die
	distutils-r1_src_prepare
}

src_test() {
	mkdir -p "${T}"/mysql || die
	"${BROOT}"/usr/share/mariadb/scripts/mysql_install_db \
		--no-defaults \
		--auth-root-authentication-method=normal \
		--basedir="${BROOT}/usr" \
		--datadir="${T}"/mysql || die
	# TODO: random port
	mysqld \
		--no-defaults \
		--character-set-server=utf8 \
		--bind-address=127.0.0.1 \
		--port=43306 \
		--socket="${T}"/mysqld.sock \
		--datadir="${T}"/mysql &
	local pid=${!}

	# wait for it to start
	local i
	for (( i = 0; i < 10; i++)); do
		[[ -S ${T}/mysqld.sock ]] && break
		sleep 1
	done
	[[ -S ${T}/mysqld.sock ]] || die "mysqld failed to start"

	# create test databases
	mysql -uroot --socket="${T}"/mysqld.sock -e '
		create database test1 DEFAULT CHARACTER SET utf8mb4;
		create database test2 DEFAULT CHARACTER SET utf8mb4;

		create user test2 identified by "some password";
		grant all on test2.* to test2;

		create user test2@localhost identified by "some password";
		grant all on test2.* to test2@localhost;
	' || die

	cat > pymysql/tests/databases.json <<-EOF || die
		[{
			"host": "localhost",
			"user": "root",
			"passwd": "",
			"db": "test1",
			"use_unicode": true,
			"local_infile": true,
			"unix_socket": "${T}/mysqld.sock"
		}, {
			"host": "localhost",
			"user": "root",
			"passwd": "",
			"db": "test2",
			"unix_socket": "${T}/mysqld.sock"
		}]
	EOF

	distutils-r1_src_test

	kill "${pid}"
	wait "${pid}"
}

python_test() {
	${PYTHON} runtests.py || die
}
