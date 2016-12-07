# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Compiles finite state machines from regular languages into executable code"
HOMEPAGE="http://www.colm.net/open-source/ragel/"
SRC_URI="http://www.colm.net/files/ragel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="vim-syntax test"

DEPEND="test? (
	amd64? ( dev-lang/go )
	arm? ( dev-lang/go )
	arm64? ( dev-lang/go )
	ppc64? ( dev-lang/go )
	x86? ( dev-lang/go )
	amd64-fbsd? ( dev-lang/go )
	x86-fbsd? ( dev-lang/go )
	x64-macos? ( dev-lang/go )
	x64-solaris? ( dev-lang/go )
)"
RDEPEND=""

PATCHES=( "${FILESDIR}/ragel-6.9+gcc-6.patch"
	"${FILESDIR}/ragel-fix-atoi3-test.patch" )

src_test() {
	cd "${S}"/test || die "Failed to change directory to test"
	./runtests || die "Tests failed"
}

src_install() {
	default

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ragel.vim
	fi
}
