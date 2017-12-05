# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Simple, battle-tested conventions and helpers for building web pages"
HOMEPAGE="https://github.com/rails/rails/"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86 ~amd64-linux"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/builder-3.1:* =dev-ruby/builder-3*:*
	>=dev-ruby/erubi-1.4:0
	>=dev-ruby/rails-html-sanitizer-1.0.3:1
	dev-ruby/rails-dom-testing:2
"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha:0.14
		~dev-ruby/actionpack-${PV}
		~dev-ruby/activemodel-${PV}
	)"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|'mysql'\|journey\|rack-cache\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|redcarpet\|bcrypt\|uglifier\|mime-types\|minitest\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
	rm ../Gemfile.lock || die

	# Avoid tests failing due to missing logger setup in activerecord,
	# most likely related to test environment setup.
	rm -f test/activerecord/render_partial_with_record_identification_test.rb || die
}
