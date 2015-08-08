# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.markdown README.markdown"

inherit ruby-fakegem

DESCRIPTION="A debugging tool for your Ruby on Rails applications"
HOMEPAGE="https://github.com/rails/web-console"
SRC_URI="https://github.com/rails/web-console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/activemodel-4.0:*
	>=dev-ruby/binding_of_caller-0.7.2
	>=dev-ruby/railties-4.0:*
	>=dev-ruby/sprockets-rails-2.0:* <dev-ruby/sprockets-rails-4.0:*
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	>=dev-ruby/rails-4.0
	dev-ruby/sqlite3
	dev-ruby/mocha
	dev-ruby/simplecov
)"

all_ruby_prepare() {
	# Use an installed rails version rather than live source from github.
	sed -i -e '/rails/ s/,/#/' Gemfile || die
}
