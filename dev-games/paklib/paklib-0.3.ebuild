# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/paklib/paklib-0.3.ebuild,v 1.4 2015/02/19 09:42:13 mr_bones_ Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="library for accessing Quake pak files"
HOMEPAGE="http://sourceforge.net/projects/paklib/"
SRC_URI="mirror://sourceforge/paklib/pak-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/pak

src_compile() {
	$(tc-getCC) ${LDFLAGS} ${CFLAGS} -fPIC -shared pak.c -o libpak.so || die "pak.so failed"
	$(tc-getCC) ${CFLAGS} -c pak.c -o libpak.a || die "pak.a failed"
}

src_install() {
	dolib.so libpak.so
	dolib.a libpak.a
	insinto /usr/include
	doins pak.h
	dodoc AUTHORS NEWS README TODO pak.c pak.h
}
