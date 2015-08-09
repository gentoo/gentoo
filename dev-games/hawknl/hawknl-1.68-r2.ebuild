# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs eutils multilib

DESCRIPTION="A cross-platform network library designed for games"
HOMEPAGE="http://www.hawksoft.com/hawknl/"
SRC_URI="http://www.sonic.net/~philf/download/HawkNL${PV/./}src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="doc"

RDEPEND=""
DEPEND=""

S=${WORKDIR}/hawknl${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	sed -i\ -e '/echo /d' src/makefile.linux || die
}

src_compile() {
	emake -C src -f makefile.linux \
		CC="$(tc-getCC)" \
		OPTFLAGS="${CFLAGS} -D_GNU_SOURCE -D_REENTRANT"
}

src_install() {
	emake -j1 -C src -f makefile.linux \
		LIBDIR="${D}/usr/$(get_libdir)" \
		INCDIR="${D}/usr/include" install
	if use doc ; then
		dodoc -r samples
	fi
}
