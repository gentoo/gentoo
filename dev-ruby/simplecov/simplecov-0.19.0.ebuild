# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="simplecov.gemspec"

inherit ruby-fakegem

DESCRIPTION="Code coverage with a configuration library and merging across test suites"
HOMEPAGE="https://github.com/simplecov-ruby/simplecov"
SRC_URI="https://github.com/simplecov-ruby/simplecov/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0.8"
IUSE="doc"

ruby_add_rdepend "
	dev-ruby/simplecov-html:0.12
	>=dev-ruby/docile-1.1:0"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/rspec:3
	dev-ruby/test-unit:2
)"

# There are also cucumber tests that require poltergeist and unpackaged phantomjs gem.

all_ruby_prepare() {
	# Avoid test depending on spawning ruby and having timing issues
	sed -i -e '/blocks other processes/askip "gentoo"' spec/result_merger_spec.rb || die

	sed -i -e '5i require "bundler"' spec/helper.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec spec/*spec.rb || die

	#${RUBY} -S cucumber features || die
}
