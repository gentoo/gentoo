# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

# Tests require a live MySQL database but should all pass.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="A modern, simple and very fast Mysql library for Ruby - binding to libmysql"
HOMEPAGE="https://github.com/brianmario/mysql2"

LICENSE="MIT"
SLOT="0.4"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="mysql mariadb"
REQUIRED_USE="^^ ( mariadb mysql )"

MDEPEND="mysql? ( dev-db/mysql-connector-c:= ) mariadb? ( dev-db/mariadb-connector-c:= )"
DEPEND="${DEPEND} ${MDEPEND}"
RDEPEND="${RDEPEND} ${MDEPEND}"

each_ruby_configure() {
	local config
	if use mysql ; then
		config="${EPREFIX}/usr/bin/mysql_config"
	fi
	if use mariadb ; then
		config="${EPREFIX}/usr/bin/mariadb_config"
	fi

	${RUBY} -Cext/mysql2 extconf.rb --with-mysql-config=${config} || die
}

each_ruby_compile() {
	emake V=1 -Cext/mysql2
	cp ext/mysql2/mysql2$(get_modname) lib/mysql2/ || die
}
