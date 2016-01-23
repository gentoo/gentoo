# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Tools to help construct database queries"
HOMEPAGE="https://github.com/camertron/arel-helpers"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "|| ( dev-ruby/activerecord:3.2
			dev-ruby/activerecord:4.0
			dev-ruby/activerecord:4.1
			dev-ruby/activerecord:4.2 )"

ruby_add_bdepend "test? (
	dev-ruby/rr
	dev-ruby/activerecord[sqlite]
)"

all_ruby_prepare() {
	sed -i -e '/pry-nav/ s:^:#:' spec/spec_helper.rb || die
}
