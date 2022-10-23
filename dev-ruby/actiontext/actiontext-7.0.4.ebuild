# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="actiontext.gemspec"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRAINSTALL="app db package.json"

inherit ruby-fakegem

DESCRIPTION="Edit and display rich text in Rails applications"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~riscv"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	~dev-ruby/activerecord-${PV}
	~dev-ruby/activestorage-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.6.0
	>=dev-ruby/nokogiri-1.8.5
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	dev-ruby/mocha
	dev-ruby/propshaft
)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|mysql2\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|sass-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|sprockets\|stackprof\|websocket-client-simple\|libxml-ruby\|redis\|blade\|aws-sdk\|google-cloud\|azure-storage\|selenium\|webpacker\|webrick\|webmock\|webdrivers\|minitest-bisect\|minitest-retry\|minitest-reporters\|listen\|rack-cache\|bootsnap\|capybara\|dalli\|connection_pool\)/ s:^:#:" \
		-e '/stimulus-rails/,/tailwindcss-rails/ s:^:#:' \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :\(cable\|doc\|rubocop\|storage\|test\)/,/^end/ s:^:#:' \
		-i ../Gemfile || die
	rm ../Gemfile.lock || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby:'${RUBY}':' test/dummy/bin/* || die
}
