# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_GEMSPEC="ruby-macho.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library for viewing and manipulating Mach-O files in Ruby"
HOMEPAGE="https://github.com/Homebrew/ruby-macho"
SRC_URI="https://github.com/Homebrew/ruby-macho/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	# Avoid benchmarks with additional dependencies
	rm -f test/bench.rb || die
	sed -i -e '/test\/bench/ s:^:#:' Rakefile || die
}
