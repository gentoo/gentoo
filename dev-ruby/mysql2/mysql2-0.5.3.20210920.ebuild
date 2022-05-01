# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

# Tests require a live MySQL database but should all pass.
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/mysql2/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/mysql2

RUBY_FAKEGEM_GEMSPEC="mysql2.gemspec"

COMMIT=6652da20010ddfbbe6bceb8e41666d05e512346c

inherit ruby-fakegem

DESCRIPTION="A modern, simple and very fast Mysql library for Ruby - binding to libmysql"
HOMEPAGE="https://github.com/brianmario/mysql2"
SRC_URI="https://github.com/brianmario/mysql2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
RUBY_S="mysql2-${COMMIT}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="mysql mariadb"
REQUIRED_USE="^^ ( mariadb mysql )"

MDEPEND="mysql? ( dev-db/mysql-connector-c:= ) mariadb? ( dev-db/mariadb-connector-c:= )"
DEPEND="${DEPEND} ${MDEPEND}"
RDEPEND="${RDEPEND} ${MDEPEND}"

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
