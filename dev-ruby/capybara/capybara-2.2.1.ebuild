# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

# Rake tasks are not distributed in the gem.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit virtualx ruby-fakegem

DESCRIPTION="Capybara aims to simplify the process of integration testing Rack applications"
HOMEPAGE="http://github.com/jnicklas/capybara"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="2"
IUSE="test"

DEPEND="${DEPEND} test? ( www-client/firefox )"

ruby_add_bdepend "test? ( dev-ruby/rspec:2 dev-ruby/launchy >=dev-ruby/selenium-webdriver-2.0 )"

ruby_add_rdepend "
	>=dev-ruby/mime-types-1.16
	>=dev-ruby/nokogiri-1.3.3
	>=dev-ruby/rack-1.0.0
	>=dev-ruby/rack-test-0.5.4
	>=dev-ruby/xpath-2.0.0:2"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e '/pry/d' spec/spec_helper.rb || die
}

each_ruby_test() {
	VIRTUALX_COMMAND="${RUBY} -Ilib -S rspec spec"
	virtualmake || die "Tests failed."
}
