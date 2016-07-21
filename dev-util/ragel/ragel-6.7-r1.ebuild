# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils autotools

DESCRIPTION="Compiles finite state machines from regular languages into executable code"
HOMEPAGE="http://www.complang.org/ragel/"
SRC_URI="http://www.complang.org/ragel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="vim-syntax"

DEPEND=""
RDEPEND=""

# We need to get the txl language in Portage to have the tests :(
RESTRICT=test

DOCS=( ChangeLog CREDITS README TODO )

src_prepare() {
	epatch "${FILESDIR}"/${P}+gcc-4.7.patch
	epatch "${FILESDIR}"/${P}-cross-compile.patch #473970
	sed -i -e '/CXXFLAGS/d' configure.in || die

	eautoreconf
}

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_test() {
	cd "${S}"/test
	./runtests.in || die
}

src_install() {
	default

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ragel.vim
	fi
}
