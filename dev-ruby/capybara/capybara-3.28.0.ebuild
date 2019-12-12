# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

# Rake tasks are not distributed in the gem.
RUBY_FAKEGEM_TASK_TEST=""

inherit virtualx ruby-fakegem

DESCRIPTION="Capybara aims to simplify the process of integration testing Rack applications"
HOMEPAGE="https://github.com/jnicklas/capybara"
LICENSE="MIT"

KEYWORDS="amd64 ~arm ~arm64 ~hppa ~x86"
SLOT="3"
IUSE="test"

DEPEND="${DEPEND} test? ( || ( www-client/firefox www-client/firefox-bin ) )"

ruby_add_bdepend "test? (
	dev-ruby/rspec:3
	>=dev-ruby/launchy-2.4.0
	>=dev-ruby/selenium-webdriver-3.5:3
	dev-ruby/sinatra:2
	www-servers/puma
)"

ruby_add_rdepend "
	dev-ruby/addressable
	>=dev-ruby/mini_mime-0.1.3
	>=dev-ruby/nokogiri-1.8:0
	>=dev-ruby/rack-1.6.0:*
	>=dev-ruby/rack-test-0.6.3:*
	>=dev-ruby/regexp_parser-1.5:1
	>=dev-ruby/xpath-3.2:3"

all_ruby_prepare() {
	sed -i -e '/bundler/d' -e '/pry/d' -e '1igem "sinatra"' -e '/statistics/Id' spec/spec_helper.rb || die

	# Avoid window-manager specific tests (sizes are specific for fluxbox)
	sed -i -e '/#maximize/,/^  end/ s:^:#:' lib/capybara/spec/session/window/window_spec.rb || die

	# Avoid spec that requires unpackaged geckodriver
	#sed -i -e '/describe.*register_server/,/^  end/ s:^:#:' spec/capybara_spec.rb || die

	# Avoid test dependency on puma server for now
	sed -i -e '/should have :puma registered/,/^    end/ s:^:#:' spec/capybara_spec.rb || die

	# Update spec to catch the right error code. This seems to have
	# changed recently accross ruby versions.
	sed -i -e '/raise_error/ s/EOFError/Net::ReadTimeout/' spec/server_spec.rb || die
}

each_ruby_test() {
	virtx ${RUBY} -Ilib -S rspec-3 spec
}
