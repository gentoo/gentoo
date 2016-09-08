# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="A desktop sticky note program for the unix geek"
HOMEPAGE="http://xnots.sourceforge.net https://github.com/thePalindrome/xnots"
EGIT_REPO_URI="https://github.com/thePalindrome/xnots"

LICENSE="GPL-2"
SLOT="0"
IUSE="vim-syntax"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango[X]
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
"

src_prepare() {
	sed -i -e 's|LICENCE||g' Makefile || die

	append-cflags -std=gnu89
}

src_compile() {
	emake CC="$(tc-getCC)" NO_DEBUG=1
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		mandir=/usr/share/man \
		prefix=/usr \
		install
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins etc/xnots.vim
	fi
}
