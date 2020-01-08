# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit toolchain-funcs eutils

DESCRIPTION="Assembler and loader used to create kernel bootsector"
HOMEPAGE="http://v3.sk/~lkundrak/dev86/"
SRC_URI="http://v3.sk/~lkundrak/dev86/${P}.tar.gz
	https://github.com/lkundrak/dev86/commit/2c95336f19eeff761ecb858c5a2a58484bb3ceeb.patch -> ${PN}-0.16.20-fix_lilo_build.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE=""

src_prepare() {
	sed -i \
		-e '/^PREFIX/s:=.*:=$(DESTDIR)/usr:' \
		-e '/^MANDIR/s:)/man/man1:)/share/man/man1:' \
		-e '/^INSTALL_OPTS/s:-s::' \
		-e "/^CFLAGS/s:=.*:=${CFLAGS} -D_POSIX_SOURCE ${CPPFLAGS}:" \
		-e "/^LDFLAGS/s:=.*:=${LDFLAGS}:" \
		Makefile || die
	epatch "${FILESDIR}"/${PN}-0.16.17-amd64-build.patch \
		"${DISTDIR}"/${P}-fix_lilo_build.patch
	tc-export CC
}

src_install() {
	dodir /usr/bin /usr/share/man/man1
	default
}
