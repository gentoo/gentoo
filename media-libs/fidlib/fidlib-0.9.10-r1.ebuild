# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="Run-time filter design and execution library"
HOMEPAGE="http://uazu.net/fidlib/"
SRC_URI="http://uazu.net/fidlib/${P}.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${P}-extern.patch
	"${FILESDIR}"/${PN}-0.9.10-Add-missing-unistd.h-include.patch
)

src_compile() {
	# build library
	edo $(tc-getCC) ${CFLAGS} -DT_LINUX ${LDFLAGS} -Wl,-soname,libfidlib.so.${PV:0:1} \
		-fPIC -shared fidlib.c -lm -o libfidlib.so.${PV:0:1}

	# build command-line tool
	edo $(tc-getCC) ${CFLAGS} ${LDFLAGS} firun.c -lm ./libfidlib.so.${PV:0:1} -o firun
}

src_install() {
	dobin firun
	dolib.so libfidlib.so.${PV:0:1}
	dosym libfidlib.so.${PV:0:1} /usr/$(get_libdir)/libfidlib.so

	insinto /usr/include/fidlib
	doins fidlib.h

	dodoc NEWS README fidlib.txt firun.txt
}
