# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="library for accessing Quake pak files"
HOMEPAGE="https://sourceforge.net/projects/paklib/"
SRC_URI="mirror://sourceforge/paklib/pak-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/pak"

src_compile() {
	"$(tc-getCC)" \
		${LDFLAGS} \
		${CFLAGS} \
		${CPPFLAGS} \
		-Wl,-soname,libpak.so \
		-fPIC \
		-shared \
		pak.c -o libpak.so || die "pak.so failed"
}

src_install() {
	dolib.so libpak.so
	doheader pak.h

	dodoc AUTHORS NEWS README TODO pak.c pak.h
}
