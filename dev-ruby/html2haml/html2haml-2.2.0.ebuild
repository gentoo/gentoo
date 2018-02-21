# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.markdown"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Convert HTML and HTML+Erb to Haml"
HOMEPAGE="https://github.com/haml/html2haml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/nokogiri-1.6.0
	>=dev-ruby/erubis-2.7.0
	>=dev-ruby/ruby_parser-3.5
	>=dev-ruby/haml-4.0.0 <dev-ruby/haml-6"

ruby_add_bdepend "test? ( dev-ruby/minitest:0 )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/html2haml_test.rb || die
	${RUBY} -Ilib:test test/erb_test.rb || die
}
