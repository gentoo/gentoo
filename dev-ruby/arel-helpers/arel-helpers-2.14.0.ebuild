# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_S=${PN}-*
RUBY_FAKEGEM_VERSION="$(ver_cut 1-3)"
inherit ruby-fakegem

DESCRIPTION="Tools to help construct database queries"
HOMEPAGE="https://github.com/camertron/arel-helpers"
# No test data in gems
SRC_URI="https://github.com/camertron/arel-helpers/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"

ruby_add_rdepend "
	|| (
		dev-ruby/activerecord:7.0
		dev-ruby/activerecord:6.1
	)
"

ruby_add_bdepend "
	test? (
		dev-ruby/rr
		dev-ruby/activerecord[sqlite]
		dev-ruby/bundler
		dev-ruby/combustion
		>=dev-ruby/database_cleaner-1.8
		=dev-ruby/sqlite3-1.4*
	)
"

all_ruby_prepare() {
	# pry is for debugging, not useful here
	sed -i -e '/pry-/ s:^:#:' spec/spec_helper.rb || die

	sed \
		-e '/rake/ s/~>/>=/' \
		-e '/appraisal/ s:^:#:' \
		-e '/database_cleaner/ s/1.8/1.7/' \
		-e '/database_cleaner/ s/~>/>=/' \
		-e '/sqlite3/ s/~>/>=/' \
		-i arel-helpers.gemspec || die
}

each_ruby_test() {
	${RUBY} -S bundle exec rake spec || die
}
