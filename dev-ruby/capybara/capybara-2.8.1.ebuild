# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

# Rake tasks are not distributed in the gem.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit virtualx ruby-fakegem

DESCRIPTION="Capybara aims to simplify the process of integration testing Rack applications"
HOMEPAGE="https://github.com/jnicklas/capybara"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="2"
IUSE="test"

DEPEND="${DEPEND} test? ( www-client/firefox )"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 dev-ruby/launchy >=dev-ruby/selenium-webdriver-2.0 dev-ruby/sinatra )"

ruby_add_rdepend "
	dev-ruby/addressable
	>=dev-ruby/mime-types-1.16:*
	>=dev-ruby/nokogiri-1.3.3
	>=dev-ruby/rack-1.0.0:*
	>=dev-ruby/rack-test-0.5.4
	>=dev-ruby/xpath-2.0.0:2"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e '/pry/d' -e '1igem "sinatra"' spec/spec_helper.rb || die

	# Avoid window-manager specific tests (sizes are specific for fluxbox)
	sed -i -e '/#maximize/,/^  end/ s:^:#:' lib/capybara/spec/session/window/window_spec.rb || die
}

each_ruby_test() {
	VIRTUALX_COMMAND=${RUBY}
	virtualmake -Ilib -S rspec-3 spec || die "Tests failed."
}
