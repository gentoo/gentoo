# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Text handling for Twitter"
HOMEPAGE="https://github.com/twitter/twitter-text"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "=dev-ruby/unf-0.1*"

ruby_add_bdepend "test? ( >=dev-ruby/multi_json-1.3
	>=dev-ruby/nokogiri-1.5.10 )"

all_ruby_prepare() {
	sed -i -e 's/2.14.0/2.14/' twitter-text.gemspec || die
	sed -i -e '/simplecov/,/end/ s:^:#:' spec/spec_helper.rb || die
}
