# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="actionpack.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Eases web-request routing, handling, and response"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	~dev-ruby/actionview-${PV}
	dev-ruby/rack:2.0
	>=dev-ruby/rack-test-0.6.3:*
	>=dev-ruby/rails-html-sanitizer-1.0.2:1
	dev-ruby/rails-dom-testing:2
"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.14
		dev-ruby/bundler
		>=dev-ruby/capybara-2.13:2
		~dev-ruby/activemodel-${PV}
		>=dev-ruby/rack-cache-1.2:1.2
		www-servers/puma
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
	rm ../Gemfile.lock || die
}
