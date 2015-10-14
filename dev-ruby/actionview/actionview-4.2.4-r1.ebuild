# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem versionator

DESCRIPTION="Simple, battle-tested conventions and helpers for building web pages"
HOMEPAGE="https://github.com/rails/rails/"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

RUBY_PATCHES=( ${P}-url-helper.patch )

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/builder-3.1:* =dev-ruby/builder-3*:*
	>=dev-ruby/erubis-2.7.0
	>=dev-ruby/rails-html-sanitizer-1.0.1:1
	>=dev-ruby/rails-dom-testing-1.0.5:1
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
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|jquery-rails\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|minitest\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
	rm ../Gemfile.lock || die
}
