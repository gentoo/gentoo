# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="sorted_set.gemspec"

inherit ruby-fakegem

DESCRIPTION="Implements a variant of Set whose elements are sorted in ascending order"
HOMEPAGE="https://github.com/knu/sorted_set"
SRC_URI="https://github.com/knu/sorted_set/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/rbtree
	dev-ruby/set:0
"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
