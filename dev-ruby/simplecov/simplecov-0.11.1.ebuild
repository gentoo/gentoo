# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Code coverage with a configuration library and automatic merging of coverage across test suites"
HOMEPAGE="https://www.ruby-toolbox.com/projects/simplecov https://github.com/colszowka/simplecov"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0.8"
IUSE="doc"

ruby_add_rdepend ">=dev-ruby/multi_json-1.0
	dev-ruby/simplecov-html:0.10
	>=dev-ruby/docile-1.1.0"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	dev-ruby/test-unit:2
	dev-util/cucumber
	dev-util/aruba
	dev-ruby/capybara
)"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' spec/helper.rb features/support/env.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec spec/*spec.rb || die

#	${RUBY} -S cucumber features || die
}
