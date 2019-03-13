# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc	DOCUMENTATION.en.rdoc  DOCUMENTATION.ja.rdoc  README.ja  README.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="Rexical is a lexical scanner generator"
HOMEPAGE="https://github.com/tenderlove/rexical/tree/master"
LICENSE="LGPL-2" # plus exception

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

# File collision, bug 459116
RDEPEND+=" !!app-admin/rex"

ruby_add_bdepend "
	test? (
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	sed -i -e '1igem "test-unit"' test/test_generator.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_*.rb
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc sample/* || die
}
