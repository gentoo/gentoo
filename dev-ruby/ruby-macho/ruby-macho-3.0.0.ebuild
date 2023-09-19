# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"
RUBY_FAKEGEM_GEMSPEC="ruby-macho.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library for viewing and manipulating Mach-O files in Ruby"
HOMEPAGE="https://github.com/Homebrew/ruby-macho"
SRC_URI="https://github.com/Homebrew/ruby-macho/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

all_ruby_prepare() {
	# Avoid benchmarks with additional dependencies
	rm -f test/bench.rb || die
	sed -i -e '/test\/bench/ s:^:#:' Rakefile || die
}
