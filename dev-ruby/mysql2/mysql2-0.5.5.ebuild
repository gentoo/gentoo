# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/mysql2/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/mysql2

RUBY_FAKEGEM_GEMSPEC="mysql2.gemspec"

inherit ruby-fakegem

DESCRIPTION="A modern, simple and very fast Mysql library for Ruby - binding to libmysql"
HOMEPAGE="https://github.com/brianmario/mysql2"
SRC_URI="https://github.com/brianmario/mysql2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="mysql mariadb"
REQUIRED_USE="^^ ( mariadb mysql )"

SQL_DEPEND="mysql? ( dev-db/mysql-connector-c:= ) mariadb? ( dev-db/mariadb-connector-c:= )"
DEPEND="${DEPEND} ${SQL_DEPEND}"
RDEPEND="${RDEPEND} ${SQL_DEPEND}"
BDEPEND="
	test? (
		mariadb? ( dev-db/mariadb:* )
		mysql? ( >=dev-db/mysql-8:* )
	)
"

all_ruby_prepare() {
	sed -i -e '/s.version/ s/Mysql2::VERSION/"'${PV}'"/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_configure() {
	local config
	if use mysql ; then
		config="${EPREFIX}/usr/bin/mysql_config"
	fi
	if use mariadb ; then
		config="${EPREFIX}/usr/bin/mariadb_config"
	fi

	${RUBY} -Cext/mysql2 extconf.rb --with-mysql-config="${config}" || die
}

each_ruby_test() {
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

	# wait for it to start
	local i
	for (( i = 0; i < 10; i++ )); do
		[[ -S ${T}/mysqld.sock ]] && break
		sleep 1
	done
	[[ ! -S ${T}/mysqld.sock ]] && die "mysqld failed to start"

	einfo "Configuring test mysql instance ..."

	mysql -u root --socket="${T}"/mysqld.sock -s -e '
		CREATE DATABASE test1 DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
	' || die "Failed to create test databases"

	# https://github.com/brianmario/mysql2/blob/master/ci/setup.sh
	mysql -u root \
		-e 'CREATE DATABASE /*M!50701 IF NOT EXISTS */ test' \
		-S "${T}"/mysqld.sock || die

	# https://github.com/brianmario/mysql2/blob/master/tasks/rspec.rake
	cat <<-EOF > spec/configuration.yml || die
	root:
	  host: localhost
	  username: root
	  password:
	  database: test
	  socket: ${T}/mysqld.sock

	user:
	  host: localhost
	  username: root
	  password:
	  database: mysql2_test
	  socket: ${T}/mysqld.sock
	EOF

	nonfatal each_fakegem_test
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
