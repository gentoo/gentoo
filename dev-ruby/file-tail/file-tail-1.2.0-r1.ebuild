# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

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

all_ruby_prepare() {
	sed -i -e '/test_tail_change2/aomit "has race condition"' tests/file_tail_test.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib tests/*_test.rb

	rm -f test.*
}
