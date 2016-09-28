# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

#if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/bartobri/${PN}.git"
	SRC_URI=""
	inherit git-r3
	KEYWORDS=""
#else
#	SRC_URI=""
#	KEYWORDS=""
#fi

DESCRIPTION="recreate decrypting text from 1992 movie 'Sneakers'"
HOMEPAGE="https://github.com/bartobri/no-more-secrets"

LICENSE="GPL-3"
SLOT=0

DEPEND="sys-libs/ncurses:0="

RDEPEND="${DEPEND}"

src_prepare() {
	sed -i 's#CC =#CC ?=#' Makefile
	sed -i 's#prefix =#prefix ?=#' Makefile
	sed -i 's#CFLAGS =#CFLAGS ?=#' Makefile
}

src_compile() {
	CC=$(tc-getCC) CFLAGS=${CFLAGS} emake
}

src_install() {
	prefix=/usr DESTDIR="${ED}" emake install
}
