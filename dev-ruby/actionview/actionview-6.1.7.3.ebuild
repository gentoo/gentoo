# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Simple, battle-tested conventions and helpers for building web pages"
HOMEPAGE="https://github.com/rails/rails/"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/builder-3.1:* =dev-ruby/builder-3*:*
	>=dev-ruby/erubi-1.4:0
	>=dev-ruby/rails-html-sanitizer-1.2.0:1
	dev-ruby/rails-dom-testing:2
"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha
		~dev-ruby/actionpack-${PV}
		~dev-ruby/activemodel-${PV}
		~dev-ruby/activerecord-${PV}
		~dev-ruby/railties-${PV}
		dev-ruby/sqlite3
		<dev-ruby/minitest-5.16:5
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|rack-cache\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|redcarpet\|bcrypt\|uglifier\|mime-types\|minitest\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
	rm ../Gemfile.lock || die

	sed -i -e '3igem "railties", "~> 6.1.0"; gem "activerecord", "~> 6.1.0"' test/abstract_unit.rb || die

	# Fix loading of activerecord integration tests. This avoids loading
	# activerecord twice and thus redefining constants leading to
	# failures. Bug #719342
	sed -e '/abstract_unit/arequire "active_record" ; require "active_record/fixtures"' \
		-e '/defined/ s/FixtureSet/ActiveRecord::FixtureSet/' \
		-i test/active_record_unit.rb || die
}
