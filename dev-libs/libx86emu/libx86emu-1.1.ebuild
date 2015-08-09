# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit multilib rpm toolchain-funcs

DESCRIPTION="A library for emulating x86"
HOMEPAGE="http://www.opensuse.org/"
SRC_URI="http://download.opensuse.org/source/factory/repo/oss/suse/src/${P}-9.8.src.rpm"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	sed -i \
		-e 's:$(CC) -shared:& $(LDFLAGS):' \
		Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -fPIC -Wall"
}

src_test() {
	ln -sf libx86emu.so.1.1 libx86emu.so || die
	ln -sf libx86emu.so.1.1 libx86emu.so.1 || die
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${LDFLAGS} -Wl,-rpath,${S} -fPIC -Wall -I../include/ -L../" test
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	dodoc Changelog README
}
