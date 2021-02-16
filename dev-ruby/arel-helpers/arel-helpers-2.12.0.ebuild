# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Tools to help construct database queries"
HOMEPAGE="https://github.com/camertron/arel-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "|| (
			dev-ruby/activerecord:6.1
			dev-ruby/activerecord:6.0
			dev-ruby/activerecord:5.2
			)"

ruby_add_bdepend "test? (
	dev-ruby/rr
	dev-ruby/activerecord[sqlite]
	dev-ruby/bundler
)"

all_ruby_prepare() {
	sed -i -e '/pry-/ s:^:#:' spec/spec_helper.rb || die
	sed -e '/rake/ s/~>/>=/' -e '/appraisal/ s:^:#:' -e '/database_cleaner/ s/1.8/1.7/' -i arel-helpers.gemspec || die
}

each_ruby_test() {
	bundle exec rspec spec || die
}
