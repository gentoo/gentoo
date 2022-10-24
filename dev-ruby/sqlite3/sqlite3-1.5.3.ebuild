# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC="faq"
RUBY_FAKEGEM_DOCDIR="doc faq"
RUBY_FAKEGEM_EXTRADOC="API_CHANGES.md README.md ChangeLog.cvs CHANGELOG.md"

RUBY_FAKEGEM_EXTENSIONS=(ext/sqlite3/extconf.rb)
RUBY_FAKEGEM_EXTENSION_LIBDIR=lib/sqlite3

inherit ruby-fakegem

DESCRIPTION="An extension library to access a SQLite database from Ruby"
HOMEPAGE="https://github.com/sparklemotion/sqlite3-ruby"
LICENSE="BSD"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

RDEPEND+=" >=dev-db/sqlite-3.39.4:3"
DEPEND+=" >=dev-db/sqlite-3.39.4:3"

ruby_add_bdepend "
	dev-ruby/mini_portile2:2.8
	doc? ( dev-ruby/rdoc dev-ruby/redcloth )
	test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	sed -i -e 's/enable_config("system-libraries")/true/' ext/sqlite3/extconf.rb || die
}

all_ruby_compile() {
	all_fakegem_compile

	if use doc; then
		rdoc --title "${P} Dcoumentation" -o doc --main README.rdoc lib *.rdoc ext/*/*.c || die
		rm -f doc/js/*.gz || die
	fi
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}
