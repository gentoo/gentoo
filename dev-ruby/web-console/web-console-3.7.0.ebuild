# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

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
	>=dev-ruby/bindex-0.4.0
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
		-e '/\(byebug\|simplecov\)/ s:^:#:' Gemfile || die

	sed -i -e '/simplecov/I s:^:#:' test/test_helper.rb || die
}
