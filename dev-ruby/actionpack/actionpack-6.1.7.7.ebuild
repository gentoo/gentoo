# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="actionpack.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Eases web-request routing, handling, and response"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	~dev-ruby/actionview-${PV}
	dev-ruby/rack:2.2
	>=dev-ruby/rack-test-0.6.3:*
	>=dev-ruby/rails-html-sanitizer-1.2.0:1
	dev-ruby/rails-dom-testing:2
"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.14
		dev-ruby/bundler
		>=dev-ruby/capybara-2.15
		~dev-ruby/activemodel-${PV}
		~dev-ruby/railties-${PV}
		>=dev-ruby/rack-cache-1.2:1.2
		www-servers/puma
		<dev-ruby/minitest-5.16:*
	)"

all_ruby_prepare() {
	eapply "${FILESDIR}/actionpack-7.0.4-rack-test-2.patch"

	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
	rm ../Gemfile.lock || die

	sed -e '3igem "railties", "~> 6.1.0"; gem "activerecord", "~> 6.1.0"; gem "minitest", "<5.16"' \
		-i test/abstract_unit.rb || die

	# Use different timezone notation, this changed at some point due to an external dependency changing.
	sed -e 's/-0000/GMT/' \
		-i test/dispatch/response_test.rb test/dispatch/cookies_test.rb test/dispatch/session/cookie_store_test.rb || die

	# Avoid tests depending on an unreleased version of selenium-webdriver
	sed -e '/define extra capabilities/,/^  end/ s:^:#:' \
		-i test/dispatch/system_testing/driver_test.rb || die

	# Avoid tests that fail with a fixed cgi.rb version
	sed -e '/test_session_store_with_all_domains/askip "Fails with fixed cgi.rb"' \
		-i test/dispatch/session/cookie_store_test.rb || die
}
