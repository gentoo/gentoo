# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.markdown README.markdown"

RUBY_FAKEGEM_GEMSPEC="web-console.gemspec"

inherit ruby-fakegem

DESCRIPTION="A debugging tool for your Ruby on Rails applications"
HOMEPAGE="https://github.com/rails/web-console"
SRC_URI="https://github.com/rails/web-console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/actionview-5.0:*
	>=dev-ruby/activemodel-5.0:*
	dev-ruby/debug_inspector
	>=dev-ruby/railties-5.0:*
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	>=dev-ruby/rails-5.0
	dev-ruby/sqlite3
	dev-ruby/mocha
	www-servers/puma
)"

all_ruby_prepare() {
	# Use an installed rails version rather than live source from github.
	sed -i -e '/\(rack\|rails\|simplecov\)/ s/,/#/'  \
		-e '/simplecov/d' Gemfile || die

	sed -i -e '/simplecov/I s:^:#:' test/test_helper.rb || die
}
