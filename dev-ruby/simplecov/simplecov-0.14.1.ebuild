# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Code coverage with a configuration library and merging across test suites"
HOMEPAGE="https://www.ruby-toolbox.com/projects/simplecov https://github.com/colszowka/simplecov"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0.8"
IUSE="doc"

ruby_add_rdepend ">=dev-ruby/json-1.8:0 <dev-ruby/json-3:0
	dev-ruby/simplecov-html:0.10
	=dev-ruby/docile-1.1*"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/test-unit:2
)"

# There are also cucumber tests that require poltergeist and unpackaged phantomjs gem.

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' spec/helper.rb features/support/env.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec spec/*spec.rb || die

	#${RUBY} -S cucumber features || die
}
