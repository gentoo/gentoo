# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.md"

inherit ruby-fakegem

DESCRIPTION="An oEmbed consumer library written in Ruby."
HOMEPAGE="https://github.com/judofyr/ruby-oembed"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test?
	(
		dev-ruby/json
		dev-ruby/vcr:5
		dev-ruby/xml-simple
		dev-ruby/nokogiri
		dev-ruby/webmock:3
	)"

all_ruby_prepare() {
	# Remove bundler but keep vcr version requirement
	rm -f Gemfile || die
	sed -i -e '1igem "vcr", "~> 5.0"' spec/spec_helper.rb || die

	# Avoid development dependencies
	sed -i -e '/coverall/I s:^:#:' spec/spec_helper.rb || die
}
