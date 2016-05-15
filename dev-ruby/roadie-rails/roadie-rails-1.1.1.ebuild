# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Hooks Roadie into your Rails application to help with email generation"
HOMEPAGE="https://github.com/Mange/roadie-rails"
SRC_URI="https://github.com/Mange/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="test"

ruby_add_rdepend ">=dev-ruby/roadie-3.1
	>=dev-ruby/railties-3.0"
ruby_add_bdepend ">=dev-ruby/rails-3.0
	test? ( dev-ruby/rspec-rails
		dev-ruby/rspec-collection_matchers )"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" -e "s/bundle exec//" Rakefile || die
}
