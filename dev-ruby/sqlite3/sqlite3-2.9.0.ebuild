# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_DOC="faq"
RUBY_FAKEGEM_DOCDIR="doc faq"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/sqlite3/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/sqlite3
RUBY_FAKEGEM_GEMSPEC="sqlite3.gemspec"

inherit ruby-fakegem

DESCRIPTION="An extension library to access a SQLite database from Ruby"
HOMEPAGE="https://github.com/sparklemotion/sqlite3-ruby"
SRC_URI="https://github.com/sparklemotion/sqlite3-ruby/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="sqlite3-ruby-${PV}"
LICENSE="BSD"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="doc test"

# We track the bundled sqlite version here
RDEPEND=">=dev-db/sqlite-3.51.1:3"
DEPEND=">=dev-db/sqlite-3.51.1:3"

ruby_add_bdepend "
	doc? ( dev-ruby/rdoc )
	test? ( dev-ruby/minitest:5 )
"

all_ruby_prepare() {
	sed -i -e 's/enable_config("system-libraries")/true/' ext/sqlite3/extconf.rb || die

	# Remove the runtime dependency on mini_portile2. We build without
	# it and it is not a runtime dependency for us.
	sed -e '/mini_portile2/ s:^:#:' \
		-e '/WARNING/ s:^:#:' \
		-e "s/0.0.0/${PV}/" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid a failing spec for reprepares stats. Upstream indicates that
	# the stats data should not be relied on other than for human
	# debugging.
	sed -e '/def test_stat_reprepares/askip "Fails on Gentoo"' \
		-i test/test_statement.rb || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc; then
		rdoc --title "${P} Documentation" -o doc --main README.rdoc lib *.rdoc ext/*/*.c || die
		rm -f doc/js/*.gz || die
	fi
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
