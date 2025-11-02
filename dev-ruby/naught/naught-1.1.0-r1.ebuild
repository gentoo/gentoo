# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="Changelog.md README.markdown"

inherit ruby-fakegem

DESCRIPTION="A toolkit for building Null Objects in Ruby"
HOMEPAGE="https://github.com/avdi/naught"

LICENSE="MIT"
SLOT="5"
KEYWORDS="~amd64"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/spec_helper.rb || die

	# Account for different call stack messages in Ruby 3.4.
	sed -e '/with/ s/\$/.?$/' \
		-e '/with/ s/from block/block/' \
		-e '/with/ s/from call_method/from.*call_method/' \
		-i spec/pebble_spec.rb || die
}
