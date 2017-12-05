# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Efficient, immutable, thread-safe collection classes for Ruby"
HOMEPAGE="https://github.com/hamstergem/hamster"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "dev-ruby/concurrent-ruby:1"

all_ruby_prepare() {
	sed -i -e '/codeclimate/I s:^:#:' spec/spec_helper.rb || die
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb spec/lib/hamster/vector/insert_spec.rb || die
}
