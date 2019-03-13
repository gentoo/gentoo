# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="A library for viewing and manipulating Mach-O files in Ruby"
HOMEPAGE="https://github.com/Homebrew/ruby-macho"
SRC_URI="https://github.com/Homebrew/ruby-macho/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

all_ruby_prepare() {
	# Avoid benchmarks with additional dependencies
	rm -f test/bench.rb || die
	sed -i -e '/test\/bench/ s:^:#:' Rakefile || die
}
