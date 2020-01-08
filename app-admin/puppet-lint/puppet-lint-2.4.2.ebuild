# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit eutils ruby-fakegem

DESCRIPTION="A linter for puppet DSL"
HOMEPAGE="http://puppet-lint.com/"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

ruby_add_bdepend "test? (
	dev-ruby/rspec-its:1
	dev-ruby/rspec-collection_matchers:1
	dev-ruby/rspec-json_expectations )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' spec/spec_helper.rb || die
}
