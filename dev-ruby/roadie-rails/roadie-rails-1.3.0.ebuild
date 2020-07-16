# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Hooks Roadie into your Rails application to help with email generation"
HOMEPAGE="https://github.com/Mange/roadie-rails"
SRC_URI="https://github.com/Mange/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#RESTRICT="test"

ruby_add_rdepend ">=dev-ruby/roadie-3.1
	>=dev-ruby/railties-3.0:* <dev-ruby/railties-5.3:*"
ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/rspec-rails
		dev-ruby/rspec-collection_matchers )"

all_ruby_prepare() {
	sed -i -e '/development/,$ d' Gemfile || die
	sed -i -e 's/git ls-files/find . -print/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid already removed rails version
	sed -i -e '/rails_50/ s:^:#:' spec/integration_spec.rb || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rspec-3 spec || die
}
