# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_GEMSPEC="immutable-ruby.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Efficient, immutable, thread-safe collection classes for Ruby"
HOMEPAGE="https://github.com/immutable-ruby/immutable-ruby"
SRC_URI="https://github.com/immutable-ruby/immutable-ruby/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"

ruby_add_rdepend "
	>=dev-ruby/concurrent-ruby-1.1:1
	dev-ruby/sorted_set:0
"

all_ruby_prepare() {
	sed -i -e '/pry/ s:^:#:' spec/spec_helper.rb spec/lib/immutable/vector/insert_spec.rb || die
}
