# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="set.gemspec"

inherit ruby-fakegem

DESCRIPTION="Provides a class to deal with collections of unordered, unique values"
HOMEPAGE="https://github.com/ruby/set"
SRC_URI="https://github.com/ruby/set/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/test_error/aomit "Fails when sorted_set gem is installed"' \
		-i test/test_sorted_set.rb || die
}
