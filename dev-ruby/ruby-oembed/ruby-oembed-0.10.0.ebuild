# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc README.rdoc"

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
		dev-ruby/vcr:1
		dev-ruby/xml-simple
		dev-ruby/nokogiri
		dev-ruby/fakeweb
	)"

all_ruby_prepare() {
	# Remove bundler but keep vcr version requirement
	rm -f Gemfile || die
	sed -i -e '1igem "vcr", "~> 1.0"' spec/spec_helper.rb || die

	# Fix broken spec (fix taken from upstream commit)
	sed -i -e '127,135 s/should_receive/to receive/' spec/providers_spec.rb || die
}
