# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Compiles finite state machines from regular languages into executable code"
HOMEPAGE="http://www.colm.net/open-source/ragel/"
SRC_URI="http://www.colm.net/files/ragel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

# We need to get the txl language in Portage to have the tests :(
RESTRICT="test"

DOCS=( ChangeLog CREDITS README TODO )

src_prepare() {
	default

	eautoreconf
}

src_test() {
	cd "${S}"/test
	./runtests.in || die
}

src_install() {
	default

	insinto /usr/share/vim/vimfiles/syntax
	doins ragel.vim
}
