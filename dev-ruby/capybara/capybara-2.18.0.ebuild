# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

# Rake tasks are not distributed in the gem.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

inherit virtualx ruby-fakegem

DESCRIPTION="Capybara aims to simplify the process of integration testing Rack applications"
HOMEPAGE="https://github.com/jnicklas/capybara"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~arm64 ~hppa ~x86"
SLOT="2"
IUSE="test"

DEPEND="${DEPEND} test? ( || ( www-client/firefox www-client/firefox-bin ) )"

ruby_add_bdepend "test? ( dev-ruby/rspec:3 dev-ruby/launchy >=dev-ruby/selenium-webdriver-2.0 dev-ruby/sinatra )"

ruby_add_rdepend "
	dev-ruby/addressable
	>=dev-ruby/mini_mime-0.1.3
	>=dev-ruby/nokogiri-1.3.3
	>=dev-ruby/rack-1.0.0:*
	>=dev-ruby/rack-test-0.5.4:*
	|| ( dev-ruby/xpath:3 dev-ruby/xpath:2 )"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e '/pry/d' -e '1igem "sinatra"' spec/spec_helper.rb || die

	# Avoid window-manager specific tests (sizes are specific for fluxbox)
	sed -i -e '/#maximize/,/^  end/ s:^:#:' lib/capybara/spec/session/window/window_spec.rb || die

	# Avoid spec that requires unpackaged geckodriver
	sed -i -e '/register_server/,/^  end/ s:^:#:' spec/capybara_spec.rb || die

	# Avoid test dependency on puma server for now
	sed -i -e '/should have :puma registered/,/^    end/ s:^:#:' spec/capybara_spec.rb || die
}

each_ruby_test() {
	virtx ${RUBY} -Ilib -S rspec-3 spec
}
