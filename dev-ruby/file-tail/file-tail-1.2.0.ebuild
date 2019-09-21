# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_DOC_SOURCES="lib README.md"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A small ruby library that allows it to 'tail' files in Ruby"
HOMEPAGE="https://flori.github.com/file-tail"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "=dev-ruby/tins-1*"
ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib tests/*_test.rb

	rm -f test.*
}
