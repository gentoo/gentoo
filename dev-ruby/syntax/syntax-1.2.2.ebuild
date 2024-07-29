# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Syntax highlighting for sourcecode and HTML"
HOMEPAGE="https://github.com/dblock/syntax"
SRC_URI="https://github.com/dblock/syntax/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test doc"

ruby_add_bdepend "doc? ( dev-ruby/rdoc )"

all_ruby_prepare() {
	# Remove manual doc since it can not longer be build and it blocks default rdoc recipe.
	rm -rf doc || die
}

each_ruby_test() {
	${RUBY} -Ilib test/ALL-TESTS.rb || die
}
