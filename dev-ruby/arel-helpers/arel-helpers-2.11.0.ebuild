# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Tools to help construct database queries"
HOMEPAGE="https://github.com/camertron/arel-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "|| (
			dev-ruby/activerecord:6.0
			dev-ruby/activerecord:5.2
			dev-ruby/activerecord:4.2 )"

ruby_add_bdepend "test? (
	dev-ruby/rr
	dev-ruby/activerecord[sqlite]
)"

all_ruby_prepare() {
	sed -i -e '/pry-/ s:^:#:' spec/spec_helper.rb || die
}
