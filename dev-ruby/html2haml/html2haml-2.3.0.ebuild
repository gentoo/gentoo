# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.markdown"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Convert HTML and HTML+Erb to Haml"
HOMEPAGE="https://github.com/haml/html2haml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend ">=dev-ruby/nokogiri-1.6.0
	>=dev-ruby/erubis-2.7.0
	>=dev-ruby/ruby_parser-3.5
	>=dev-ruby/haml-4.0"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -e "/bundler/d" \
		-e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/test_helper.rb || die
	sed -e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/*_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/html2haml_test.rb || die
	${RUBY} -Ilib:test test/erb_test.rb || die
}
