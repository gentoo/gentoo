# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="phlex.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="sus"

inherit ruby-fakegem

DESCRIPTION="A framework for building object-oriented views in Ruby"
HOMEPAGE="https://github.com/yippee-fun/phlex"
SRC_URI="https://github.com/yippee-fun/phlex/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/zeitwerk-2.7:2"

ruby_add_bdepend "test? (
	>=dev-ruby/concurrent-ruby-1.2:1
)"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/bundler/I s:^:#:' \
		-e '1irequire "concurrent"' \
		-e '/simplecov/,/SimpleCov.command_name/ s:^:#:' \
		-i config/sus.rb || die
}

each_ruby_test() {
	RUBYLIB=lib each_fakegem_test
}
