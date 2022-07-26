# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.md"
RUBY_FAKEGEM_GEMSPEC="ruby-oembed.gemspec"

inherit ruby-fakegem

DESCRIPTION="An oEmbed consumer library written in Ruby"
HOMEPAGE="https://github.com/ruby-oembed/ruby-oembed"
SRC_URI="https://github.com/ruby-oembed/ruby-oembed/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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

	sed -i -e 's/git ls-files/find * -print/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Fix kwargs expectations for ruby30
	sed -e '455 s/:format => @default/{format: @default}/' \
		-e '460 s/:format=>:xml/{format: :xml}/' \
		-e '465 s/:format=>:json/{format: :json}/' \
		-e '477 s/:format => @default/{format: @default}/' \
		-i spec/provider_spec.rb || die
}
