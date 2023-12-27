# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="doc/*"

USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-fakegem
DESCRIPTION="A binary search library for Ruby"
HOMEPAGE="http://0xcc.net/ruby-bsearch/"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

all_ruby_prepare() {
	sed -i 's/ruby/\$\{RUBY\}/' test/test.sh || die
}

each_ruby_test() {
	pushd test
	RUBY=${RUBY} sh test.sh || die
	popd
}
