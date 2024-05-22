# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="actionmailbox.gemspec"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRAINSTALL="app config db"

inherit ruby-fakegem

DESCRIPTION="Framework for designing email-service layers"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	~dev-ruby/activejob-${PV}
	~dev-ruby/activerecord-${PV}
	~dev-ruby/activestorage-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/mail-2.7.1:*
	dev-ruby/net-imap
	dev-ruby/net-pop
	dev-ruby/net-smtp
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/minitest:5
	dev-ruby/mocha
	dev-ruby/propshaft
	dev-ruby/rexml
	dev-ruby/sqlite3
	dev-ruby/webmock
	dev-ruby/rails
)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|mysql2\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|sass-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|sprockets\|stackprof\|websocket-client-simple\|libxml-ruby\|redis\|blade\|aws-sdk\|google-cloud\|azure-storage\|selenium\|webdrivers\|webrick\|minitest-bisect\|minitest-retry\|minitest-reporters\|listen\|rack-cache\|rack-test\|capybara\|webpacker\|bootsnap\|dalli\|connection_pool\|terser\|cookiejar\|cgi\|web-console\|trilogy\|error_highlight\|jbuilder\)/ s:^:#:" \
		-e '/stimulus-rails/,/tailwindcss-rails/ s:^:#:' \
		-e '/group :\(cable\|doc\|job\|lint\|mdl\|rubocop\|storage\|test\)/,/^end/ s:^:#:' \
		-e '/sqlite/ s/1.6.4/99/' \
		-i ../Gemfile || die
	rm ../Gemfile.lock || die
	sed -i -e '/byebug/ s:^:#:' test/test_helper.rb || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby:'${RUBY}':' test/dummy/bin/* || die
}
