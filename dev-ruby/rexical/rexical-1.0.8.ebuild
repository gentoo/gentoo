# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc	DOCUMENTATION.en.rdoc  DOCUMENTATION.ja.rdoc  README.ja  README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Rexical is a lexical scanner generator"
HOMEPAGE="https://github.com/sparklemotion/rexical/tree/master"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"

# File collision, bug 459116
RDEPEND="!!app-admin/rex"

ruby_add_depend "dev-ruby/getoptlong"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest
	)"

all_ruby_prepare() {
	# Avoid dependency on unpackaged rubocop
	sed -i -e '/test_rubocop_security/askip "not packaged"' test/test_generator.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc sample/*
}
