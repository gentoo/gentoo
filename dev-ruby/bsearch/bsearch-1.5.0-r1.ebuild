# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="doc/*"

USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem
DESCRIPTION="A binary search library for Ruby"
HOMEPAGE="http://0xcc.net/ruby-bsearch/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

all_ruby_prepare() {
	sed -i 's/ruby/\$\{RUBY\}/' test/test.sh || die
}

each_ruby_test() {
	pushd test
	RUBY=${RUBY} sh test.sh || die
	popd
}
