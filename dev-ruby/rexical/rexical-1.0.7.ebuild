# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc	DOCUMENTATION.en.rdoc  DOCUMENTATION.ja.rdoc  README.ja  README.rdoc"

inherit ruby-fakegem eutils

DESCRIPTION="Rexical is a lexical scanner generator"
HOMEPAGE="https://github.com/tenderlove/rexical/tree/master"
LICENSE="LGPL-2" # plus exception

KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

# File collision, bug 459116
RDEPEND+=" !!app-admin/rex"

ruby_add_bdepend "
	test? (
		dev-ruby/hoe
		dev-ruby/minitest
	)"

all_ruby_prepare() {
	# Avoid dependency on unpackaged rubocop
	sed -i -e '/test_rubocop_security/askip "not packaged"' test/test_generator.rb || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc sample/*
}
