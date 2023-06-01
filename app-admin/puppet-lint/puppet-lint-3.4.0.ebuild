# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP="puppet-lint"

inherit ruby-fakegem

DESCRIPTION="A linter for puppet DSL"
HOMEPAGE="https://github.com/puppetlabs/puppet-lint"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ~x86"

ruby_add_bdepend "test? (
	dev-ruby/rspec-its:1
	dev-ruby/rspec-collection_matchers:1
	dev-ruby/rspec-json_expectations )"

all_ruby_prepare() {
	# Skip acceptance tests due to unpackages puppet_litmus which in turn
	# has a number of unpackaged dependencies.
	rm -rf spec/acceptance || die
	rm -f spec/spec_helper_acceptance.rb || die
}
