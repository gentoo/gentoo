# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Tools to help construct database queries"
HOMEPAGE="https://github.com/camertron/arel-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

ruby_add_rdepend "|| (
			dev-ruby/activerecord:5.1
			dev-ruby/activerecord:5.0
			dev-ruby/activerecord:4.2 )"

ruby_add_bdepend "test? (
	dev-ruby/rr
	dev-ruby/activerecord[sqlite]
)"

all_ruby_prepare() {
	sed -i -e '/pry-nav/ s:^:#:' spec/spec_helper.rb || die
}
