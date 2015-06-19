# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fidlib/fidlib-0.9.10.ebuild,v 1.5 2012/06/13 12:59:29 johu Exp $

EAPI=4

inherit toolchain-funcs flag-o-matic eutils multilib

DESCRIPTION="Run-time filter design and execution library"
HOMEPAGE="http://uazu.net/fidlib/"
SRC_URI="http://uazu.net/fidlib/${P}.tgz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

doecho() {
	echo "$@"
	"$@" || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cpp-extern.patch

	# Avoid ICE under gcc-4.6, fixed in 4.6.3
	if [[ $(gcc-version) == "4.6" && $(gcc-micro-version) -le 2 ]] ; then
		replace-flags -O? -O0
	fi
}

src_compile() {
	# build library
	doecho $(tc-getCC) ${CFLAGS} -DT_LINUX ${LDFLAGS} -Wl,-soname,libfidlib.so.${PV:0:1} \
		-fPIC -shared fidlib.c -lm -o libfidlib.so.${PV:0:1}

	# build command-line tool
	doecho $(tc-getCC) ${CFLAGS} ${LDFLAGS} firun.c -lm ./libfidlib.so.${PV:0:1} -o firun
}

src_install() {
	dobin firun
	dolib.so libfidlib.so.${PV:0:1}
	dosym libfidlib.so.${PV:0:1} /usr/$(get_libdir)/libfidlib.so

	insinto /usr/include/fidlib
	doins fidlib.h

	dodoc NEWS README fidlib.txt firun.txt
}
