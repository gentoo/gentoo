# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="simplecov.gemspec"

inherit ruby-fakegem

DESCRIPTION="Code coverage with a configuration library and merging across test suites"
HOMEPAGE="https://www.ruby-toolbox.com/projects/simplecov https://github.com/colszowka/simplecov"
SRC_URI="https://github.com/colszowka/simplecov/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0.8"
IUSE="doc"

ruby_add_rdepend "|| ( dev-ruby/json:2 >=dev-ruby/json-1.8:0 )
	dev-ruby/simplecov-html:0.10
	>=dev-ruby/docile-1.1:0"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/test-unit:2
)"

# There are also cucumber tests that require poltergeist and unpackaged phantomjs gem.

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' spec/helper.rb features/support/env.rb || die

	# Avoid test depending on spawning ruby and having timing issues
	sed -i -e '/blocks other processes/askip "gentoo"' spec/result_merger_spec.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec spec/*spec.rb || die

	#${RUBY} -S cucumber features || die
}
