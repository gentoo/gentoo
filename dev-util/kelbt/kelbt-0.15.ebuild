# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kelbt/kelbt-0.15.ebuild,v 1.2 2012/06/24 07:56:56 flameeyes Exp $

EAPI=4

inherit eutils

DESCRIPTION="A backtracking LR parser by the author of Ragel"
HOMEPAGE="http://www.complang.org/kelbt/"
SRC_URI="http://www.complang.org/kelbt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE="vim-syntax"

RDEPEND=""

src_prepare() {
	find "${S}" -iname "Makefile*" -exec sed -i \
		-e '/\$(CXX)/s:CFLAGS:CXXFLAGS:' \
		{} \;

	epatch "${FILESDIR}"/ragel-6.7+gcc-4.7.patch
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	cd "${S}"/test
	./runtests || die "tests failed"
}

src_install() {
	dobin kelbt/kelbt
	dodoc TODO CREDITS ChangeLog

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ${PN}.vim
	fi
}
