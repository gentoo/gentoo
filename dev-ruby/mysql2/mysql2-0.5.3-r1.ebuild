# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

# Tests require a live MySQL database but should all pass.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/mysql2/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/mysql2

inherit multilib ruby-fakegem

DESCRIPTION="A modern, simple and very fast Mysql library for Ruby - binding to libmysql"
HOMEPAGE="https://github.com/brianmario/mysql2"

LICENSE="MIT"
SLOT="0.5"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
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

	${RUBY} -Cext/mysql2 extconf.rb --with-mysql-config="${config}" || die
}
